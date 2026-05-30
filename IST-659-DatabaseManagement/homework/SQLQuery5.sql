USE tinyu;
go

CREATE OR ALTER FUNCTION dbo.f_concat
(
	-- Add the parameters for the function here
	@a varchar(50), @b varchar(50), @c varchar(50)
)
RETURNS varchar(150)
AS
BEGIN
	RETURN @a + @c + @b;

END
go

SELECT dbo.f_concat('leading', 'trailing', '-');
go

CREATE OR ALTER VIEW dbo.v_students 
AS
SELECT	[student_id], dbo.f_concat([student_lastname], 
		[student_firstname], ',') AS student_name,
		[student_year_name], [student_major_id], 
		[student_gpa], [student_notes]
FROM	[dbo].[students];
go

SELECT * FROM dbo.v_students;
go

ALTER TABLE dbo.students ADD student_active char(1) NOT NULL DEFAULT ('Y');
go

ALTER TABLE dbo.students ADD student_inactive_date date null;
go

