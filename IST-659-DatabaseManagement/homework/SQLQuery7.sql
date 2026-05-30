USE tinyu;
go

DROP TRIGGER IF EXISTS dbo.students_update_trigger;
go

CREATE TRIGGER dbo.students_update_trigger
   ON  dbo.students
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

UPDATE	TGT
SET		student_active = IIF(TGT.student_inactive_date IS NOT NULL, 'N', 'Y')
FROM	dbo.students AS TGT
INNER	JOIN inserted AS INS ON INS.student_id = TGT.student_id

END
GO

UPDATE dbo.students
SET student_inactive_date = GETDATE()
WHERE student_year_name = 'Senior';
go

SELECT * FROM dbo.students;
go


