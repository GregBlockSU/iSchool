--Q1
USE [tinyu];
go

/*
1.	In the TinyU database: 
a.	Write an SQL Stored procedure called p_upsert_major, which, given a major_code (business key) and a major_name, does an Upsert, which is the following:
i.	Checks if the major_code exists in the table already.
ii.	If yes, updates the table and makes the major_name match the new major name.
iii.	If no, inserts the new major_name and major_code into the table. HINT: major_id is not a surrogate key, so you will need to determine the next ID yourself in code!
b.	Test your stored procedure by executing it to make these changes:
i.	Change : CSC—Computer Sciences to CSC—Computer Science
ii.	Add: FIN—Finance
*/
CREATE OR ALTER PROCEDURE [dbo].[p_upsert_major]
	@major_code varchar(3),
	@major_name varchar(50)
AS
IF EXISTS (
	SELECT *
	FROM [dbo].[majors]
	WHERE [major_code] = @major_code
		)
BEGIN
	UPDATE	[dbo].[majors]
	SET		[major_name] = @major_name
	WHERE	[major_code] = @major_code;
END
ELSE
BEGIN
	INSERT INTO [dbo].[majors] ([major_id],[major_code],[major_name])
	VALUES (1 + (SELECT max(major_id) FROM [dbo].[majors]),@major_code,@major_name);
END
go

EXEC [dbo].[p_upsert_major] @major_code = 'CSC', @major_name = 'Computer Science'
go

EXEC p_upsert_major @major_code = 'FIN', @major_name = 'Finance';
go

SELECT	*
FROM	[dbo].[majors];
go

/*
2.	In the TinyU database:
a.	Write a user-defined function called f_concat that combines the any two varchars @a and @b together with  a one-character @sep in between. 
For example:
 
b.	Now create a view called v_students that displays the student_id, student name 
(first last), student name (last, first), GPA, and name of major. You should call 
the function you created in 2.a. After you create the view, execute it with a 
SELECT statement.
*/
CREATE OR ALTER FUNCTION [dbo].[f_concat]
(
	@a varchar(50),
	@b varchar(50),
	@sep varchar(50)
)
RETURNS varchar(150)
AS
BEGIN
	RETURN @a + @sep + @b;
END 
go

SELECT [dbo].[f_concat]('hello', 'world',' ');
go

CREATE OR ALTER VIEW [dbo].[v_students]
AS
SELECT	[student_id],
		[dbo].[f_concat]([student_firstname], [student_lastname], ' ') AS student_name1,
		[dbo].[f_concat]([student_lastname], [student_firstname], ',') AS student_name2,
		[student_gpa],
		MJR.major_name
FROM	[dbo].[students] AS STU
LEFT	JOIN [dbo].[majors] AS MJR ON STU.student_major_id = MJR.major_id;
go

SELECT *
FROM [dbo].[v_students];
go

/*
3.	In the TinyU database:
a.	Write a query on the majors table so that the major_name is 
broken up into keywords, one per row. HINT: You must use 
string_split() with cross-apply. 
 
b.	Then use the query in 3.a to create a table-valued 
function f_search_majors that allows you to search the majors by 
keyword. Demonstrate calling the TVF by querying all majors with 
the “Science” keyword.
*/
-- Q3
CREATE OR ALTER FUNCTION [dbo].[f_search_majors]
(
	@keyword AS varchar(50)
)
RETURNS TABLE
AS
RETURN
WITH keyword_lookup AS 
(
	SELECT	[major_id],
			[major_code],
			[major_name],
			[value]
	FROM	[dbo].[majors]
	CROSS	APPLY STRING_SPLIT([major_name], ' ') AS keyword
)
SELECT	[major_id],
		[major_code],
		[major_name],
		[value] AS keyword
FROM	keyword_lookup
WHERE	@keyword = [value];
go

SELECT	*
FROM	dbo.f_search_majors('Science')
go

/*
4.	In the TinyU database: 
a.	Alter the students table and add the following columns:
i.	student_active char(1) default (‘Y’) not null
ii.	student_inactive_date date null 
b.	Create a trigger on the students table: when there is an 
	student_inactive_date set, set student_active to ‘N’, and 
	whenever there is not a student_inactive_date, then 
	student_active is set to ‘Y’.
c.	Write SQL code to deactivate all the ‘Graduate’ students 
	with a date of ‘2020-08-01’.
d.	Write SQL code to reactivate all the ‘Graduate’ students.
Provide a screen shot of your code from 4.a. and 4.b working. Provide another screen shot demonstrating 4.c worked. Then, provide a final screen shot of code and demonstration of 4.d working.

*/
ALTER TABLE [dbo].[students] DROP CONSTRAINT IF EXISTS [DF_students_student_active];
go

ALTER TABLE [dbo].[students] DROP COLUMN IF EXISTS [student_active];
go

ALTER TABLE [dbo].[students] DROP COLUMN IF EXISTS [student_inactive_date];
go

--Q4
ALTER TABLE [dbo].[students] ADD [student_active] char(1) 
	CONSTRAINT [DF_students_student_active] DEFAULT('Y') NOT NULL;
go

ALTER TABLE [dbo].[students] ADD [student_inactive_date] date NULL;
go

DROP TRIGGER IF EXISTS [dbo].[student_update_trigger];
go

CREATE OR ALTER TRIGGER [dbo].[student_update_trigger] 
ON [dbo].[students]
AFTER UPDATE
AS
SET NOCOUNT ON;

UPDATE	TGT
SET		[student_active] = IIF(TGT.student_inactive_date IS NOT NULL, 'N', 'Y')
FROM	[dbo].[students] AS TGT
INNER	JOIN inserted AS INS ON INS.student_id = TGT.student_id
go

UPDATE	[dbo].[students]
SET		[student_inactive_date] = '2024-08-20'
WHERE	[student_year_name] = 'Senior';
go

UPDATE	[dbo].[students]
SET		[student_inactive_date] = NULL
WHERE	[student_year_name] = 'Senior';
go

SELECT	*
FROM	[dbo].[students];
go

