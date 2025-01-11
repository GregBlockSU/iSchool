USE tinyu;
go

CREATE OR ALTER PROCEDURE dbo.UpsertMajor
	@major_code char(3),
	@major_name varchar(50)
AS
MERGE	dbo.majors AS TGT
USING	(
			SELECT @major_code AS major_code, @major_name AS major_name
		) AS SRC ON SRC.major_code = TGT.major_code 
WHEN	MATCHED THEN UPDATE
SET		major_name = SRC.major_name
WHEN	NOT MATCHED THEN INSERT
		(
			[major_id], [major_code], [major_name]
		)
VALUES	(1 + (SELECT MAX(major_id) FROM dbo.majors), @major_code, @major_name);
--IF EXISTS (SELECT * FROM [dbo].[majors] WHERE [major_code] = @major_code)
--BEGIN
--	PRINT 'Record exists';
--	UPDATE	[dbo].[majors]
--	SET		[major_name] = @major_name
--	WHERE	[major_code] = @major_code;
--END
--ELSE
--BEGIN
--	PRINT 'Record does not exist';
--	INSERT	[dbo].[majors] ([major_id], [major_code], [major_name])
--	VALUES	(1 + (SELECT MAX(major_id) FROM dbo.majors), @major_code, @major_name);
--END
go

EXEC dbo.UpsertMajor @major_code =  'ACC', @major_name = 'My accounting';
go

EXEC dbo.UpsertMajor @major_code =  'IST', @major_name = 'Data Science';
go

SELECT * FROM [dbo].[majors];
