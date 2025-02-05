USE tinyu;
GO

DROP PROCEDURE IF EXISTS dbo.p_upsert_major
GO

/*
1.	Provide a screen shot of your code execution from the walkthrough where you modified p_upsert_major  in the TinyU database to be transaction safe.
*/

CREATE PROCEDURE dbo.p_upsert_major 
    @major_code CHAR(3),
    @major_name VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        IF EXISTS (SELECT * FROM majors WHERE major_code = @major_code)
        BEGIN
            UPDATE majors
               SET major_code = @major_code
             WHERE major_code = @major_code
            if @@ROWCOUNT <> 1
                THROW 50001, 'p_upsert_major: Update Error', 1
        END
        ELSE
        BEGIN
            DECLARE @id INT = (SELECT MAX(major_id) from majors) + 1
            INSERT INTO majors (major_id,
                                major_code,
                                major_name)
            VALUES (@id, @major_code, @major_name)
            IF @@ROWCOUNT <> 1
                THROW 50002, 'p_upsert_major: Insert Error', 1
        END
        COMMIT
    END TRY
    BEGIN CATCH
        ROLLBACK;
        THROW
    END CATCH
END
GO

/*
2.	Provide a screen shot of examples of executing the p_upsert_major procedure to demonstrate it is transaction safe.
*/

EXEC p_upsert_major @major_code = 'FIN', @major_name = 'Finance'
GO

/*
3.	Rewrite the p_place_bid stored procedure from the vBay database so that it is transaction safe. Provide a screen shot of the code and its execution.
*/
USE [vbay]
GO

CREATE OR ALTER procedure [dbo].[p_place_bid] (
    @bid_item_id int,
    @bid_user_id int,
    @bid_amount money)
as
begin transaction
declare @max_bid_amount money
declare @item_seller_user_id int
declare @bid_status varchar(20)
-- be optimistic :-)
set @bid_status = 'ok'
-- TODO: 5.5.1 set @max_bid_amount to the higest bid amount for that item id 
set @max_bid_amount = (   select max(bid_amount)
                            from vb_bids
                           where bid_item_id = @bid_item_id
                             and bid_status  = 'ok')
-- TODO: 5.5.2 set @item_seller_user_id to the seller_user_id for the item id
set @item_seller_user_id = (select item_seller_user_id from vb_items where item_id = @bid_item_id)
-- TODO: 5.5.3 if no bids then set the @max_bid_amount to the item_reserve amount for the item_id

begin try
    if (@max_bid_amount is null)
        set @max_bid_amount = (select item_reserve from vb_items where item_id = @bid_item_id)
    -- if you're the item seller, set bid status
    if (@item_seller_user_id = @bid_user_id)
        set @bid_status = 'item_seller'
    -- if the current bid lower or equal to the last bid, set bid status
    if (   @bid_amount <= @max_bid_amount
     and   @bid_user_id <> (SELECT bid_user_id from vb_bids))
        set @bid_status = 'low_bid'
    -- TODO: 5.5.4 insert the bid at this point and return the bid_id 		
    insert into vb_bids (bid_user_id,
                         bid_item_id,
                         bid_amount,
                         bid_status)
    values (@bid_user_id, @bid_item_id, @bid_amount, @bid_status)
    return SCOPE_IDENTITY();
    commit
end try
begin catch
    rollback;
end catch
GO

/*
4.	Execute your stored procedure in Step 3 to demonstrate the procedure works. Make User 2 bid $105 on Item 36 and show the bid was placed with a SELECT.
*/

USE vbay;
Go

EXEC dbo.p_place_bid @bid_item_id = 36,
                     @bid_user_id = 2,
                     @bid_amount = 105
GO

select *
  from dbo.vb_bids
 where bid_user_id = 2
   and bid_item_id = 36
Go

/*
5.	Rewrite the p_rate_user stored procedure from the VBay database so that it is transaction safe. Provide a screen shot of the code and its execution.
*/

USE [vbay]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE OR ALTER procedure [dbo].[p_rate_user] (
    @rating_by_user_id int,
    @rating_for_user_id int,
    @rating_astype varchar(20),
    @rating_value int,
    @rating_comment text)
as
begin transaction
begin try
    insert into vb_user_ratings (rating_by_user_id,
                                 rating_for_user_id,
                                 rating_astype,
                                 rating_value,
                                 rating_comment)
    values (@rating_by_user_id, @rating_for_user_id, @rating_astype, @rating_value, @rating_comment)
    return @@identity
    commit
end try
begin catch
    print 'rolled back'
    rollback;
end catch
go

/*
6.	Execute the stored procedure in Step 5 to demonstrate the rollback works. You should give a six-star rating and then execute again where someone attempts to rate themselves. Produce a screen shot as evidence the rollback worked.
*/

EXEC dbo.[p_rate_user] @rating_by_user_id = 1,
                       @rating_for_user_id = 1,
                       @rating_astype = 'Buyer',
                       @rating_value = 2,
                       @rating_comment = 'lol'
Go

EXEC dbo.[p_rate_user] @rating_by_user_id = 1,
                       @rating_for_user_id = 2,
                       @rating_astype = 'Buyer',
                       @rating_value = 6,
                       @rating_comment = 'lol'
Go

use vbay;
go
select *
  from vb_user_ratings
go

/*
7.	There is a conceptual data requirement that says that no TinyU major can have more than 15 students in it. (I know, this seems silly, but think of the bigger problem—how do we enforce a specific minimum or maximum cardinality instead of just one or “many”?)  Write data logic using an instead-of trigger to do this.
*/
USE tinyu
go

CREATE OR ALTER TRIGGER dbo.students_insteadof_trigger
ON dbo.students
INSTEAD OF INSERT
AS
BEGIN
    -- CPE
    WITH AllStudents
    AS 
	(
		SELECT student_major_id
		FROM dbo.students
			  UNION ALL
		SELECT student_major_id
		FROM inserted
	)
    SELECT student_major_id,
           COUNT(*) AS ct
    -- # means temporary table
    INTO   #majors
      FROM AllStudents
     GROUP BY student_major_id
    HAVING COUNT(*) > 15;

    IF (SELECT COUNT(*) FROM #majors) > 0
    BEGIN;
        THROW 50001, 'Too many same majors', 1;
    END
    INSERT dbo.students ([student_firstname],
                         [student_lastname],
                         [student_major_id],
                         [student_year_name],
                         [student_gpa],
                         [student_notes],
                         [student_active],
                         [student_inactive_date])
    SELECT [student_firstname],
           [student_lastname],
           [student_major_id],
           [student_year_name],
           [student_gpa],
           [student_notes],
           [student_active],
           [student_inactive_date]
      FROM inserted;
END
go

/*
8.	 Test Step 7 by trying to add or update a student and change their major to ADS. The ADS major has 15 students already.  Your code should drop/create the trigger and also test the success and failure of the trigger.
*/

--insert works
INSERT dbo.students ([student_firstname],
                     [student_lastname],
                     [student_major_id],
                     [student_year_name],
                     [student_gpa],
                     [student_notes],
                     [student_active],
                     [student_inactive_date])
values ('john', 'lee', 3, 'Senior', 4, 'good student', 'Y', NULL)

--throw error
INSERT dbo.students ([student_firstname],
                     [student_lastname],
                     [student_major_id],
                     [student_year_name],
                     [student_gpa],
                     [student_notes],
                     [student_active],
                     [student_inactive_date])
values ('john', 'lee', 2, 'Senior', 4, 'good student', 'Y', NULL)

select *
  from dbo.majors

select *
  FROM dbo.students
 WHERE [student_firstname] = 'john'
   and [student_lastname]  = 'lee'
Go

SELECT student_major_id,
       COUNT(*)
  FROM dbo.students
 GROUP BY student_major_id
