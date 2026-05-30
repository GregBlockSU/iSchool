DECLARE @isThisNull varchar(30);
SELECT @isThisNull, ISNULL(@isThisNull, 'Yep, it is null');


SET @isThisNull = 'Nope. It is not NULL'
SELECT @isThisNull, ISNULL(@isThisNull, 'Yep, it is null') 
GO

CREATE OR ALTER FUNCTION dbo.AddTwoInts(@firstNumber int, @secondNumber int)
RETURNS int AS
BEGIN
	DECLARE @returnValue int 

	SET @returnValue = @firstNumber + @secondNumber

	RETURN @returnValue
END
GO
SELECT dbo.AddTwoInts(5,10)
GO


CREATE OR ALTER FUNCTION dbo.vc_VidCastCount(@userID int)
RETURNS int AS 
BEGIN
	DECLARE @returnValue int -- matches the function's return type
	SELECT @returnValue = COUNT(vc_UserID) FROM vc_VidCast
	WHERE vc_VidCast.vc_UserID = @userID
	RETURN @returnValue
END
go

SELECT TOP 10 *, dbo.vc_VidCastCount(vc_UserID) as VidCastCount
FROM	vc_User
ORDER BY VidCastCount DESC
go

CREATE OR ALTER FUNCTION dbo.vc_TagIDLookup(@tagText varchar(20))
RETURNS int AS
BEGIN
	DECLARE @returnValue int 

	SELECT @returnValue = vc_TagID FROM vc_Tag
	WHERE TagText = @tagText
	
	RETURN @returnValue
END
go

SELECT dbo.vc_TagIDLookup('Music')
SELECT dbo.vc_TagIDLookup('Tunes')
GO

CREATE OR ALTER VIEW vc_MostProlificUsers 
AS
SELECT	TOP 10 *, dbo.vc_VidCastCount(vc_UserID) as VidCastCount
FROM	vc_User
ORDER	BY VidCastCount DESC
go

SELECT * 
FROM vc_MostProlificUsers;
go

CREATE OR ALTER PROCEDURE vc_ChangeUserEmail
	@userName varchar(20), 
	@newEmail varchar(50)
AS
BEGIN
	UPDATE vc_User SET EmailAddress = @newEmail
	WHERE UserName = @userName
END
go

EXEC vc_ChangeUserEmail 'tardy', 'kmstudent@syr.edu';
go

SELECT * 
FROM vc_User 
WHERE UserName = 'tardy'
go

INSERT vc_Tag (TagText) VALUES ('Cat Videos');
go

SELECT	* 
FROM	vc_Tag 
WHERE vc_TagID = SCOPE_IDENTITY();
go

INSERT vc_Tag (TagText) 
VALUES ('Dog Videos');
go

SELECT * FROM vc_Tag 
WHERE vc_TagID = SCOPE_IDENTITY()	
go

CREATE OR ALTER PROCEDURE vc_AddUserLogin
	@userName varchar(20), 
	@loginFrom varchar(50)
AS
BEGIN
	DECLARE @userID int

	SELECT @userID = vc_UserID FROM vc_User
	WHERE UserName = @userName
	
	INSERT INTO vc_UserLogin (vc_UserID, LoginLocation)
	VALUES (@userID, @loginFrom)

	RETURN SCOPE_IDENTITY()
END
go

DECLARE @addedValue int;
EXEC @addedValue = vc_AddUserLogin 'tardy', 'localhost';

SELECT
	vc_User.vc_UserID
	, vc_User.UserName
	, vc_UserLogin.UserLoginTimestamp
	, vc_UserLogin.LoginLocation
FROM vc_User
	JOIN vc_UserLogin ON vc_User.vc_UserID = vc_UserLogin.vc_UserID
WHERE vc_UserLoginID = @addedValue;
go

CREATE OR ALTER FUNCTION dbo.vc_UserIDLookup
(
	@userName varchar(20)
)
RETURNS int AS
BEGIN
	DECLARE @returnValue int

	SELECT @returnValue = vc_UserID FROM vc_User
	WHERE UserName = @userName

	RETURN @returnValue
END
go

SELECT 'Trying the vc_UserIDLookup function.', dbo.vc_UserIDLookup('tardy')
go

CREATE OR ALTER FUNCTION dbo.vc_TagVidCastCount
(
	@tagID int
)
RETURNS int AS
BEGIN
	DECLARE @returnValue int

	SELECT @returnValue = count(vc_VidCastID) FROM vc_VidCastTagList
	WHERE vc_TagID = @tagID

	RETURN @returnValue
END
go

SELECT 
	vc_Tag.TagText, 
	dbo.vc_TagVidCastCount(vc_Tag.vc_TagID) as VidCasts
FROM vc_Tag;
go

CREATE OR ALTER FUNCTION dbo.vc_VidCastDuration
(
	@userID int
)
RETURNS int AS
BEGIN
	DECLARE @returnValue int

	SELECT @returnValue = SUM(DATEDIFF(n, StartDateTime, EndDateTime)) 
	FROM	vc_VidCast AS VC
	INNER	JOIN vc_Status AS ST ON VC.vc_StatusID = ST.vc_StatusID
	WHERE	VC.vc_UserID = @userID AND 
			ST.StatusText = 'Finished';

	RETURN @returnValue;
END
go
SELECT	*, dbo.vc_VidCastDuration(vc_UserID) as TotalMinutes 
FROM	vc_User;
GO

CREATE OR ALTER VIEW vc_TagReport 
AS
SELECT	vc_Tag.TagText, dbo.vc_TagVidCastCount(vc_Tag.vc_TagID) as VidCasts
FROM vc_Tag
go

SELECT * 
FROM vc_TagReport 
ORDER BY VidCasts DESC;
go

CREATE OR ALTER VIEW vc_MostProlificUsers 
AS
SELECT TOP 10
	*
	, dbo.vc_VidCastCount(vc_UserID) as VidCastCount
	, dbo.vc_VidCastDuration(vc_UserID) as TotalMinutes
FROM vc_User
ORDER BY VidCastCount DESC
go

SELECT UserName, VidCastCount, TotalMinutes 
FROM vc_MostProlificUsers;
go

CREATE OR ALTER PROCEDURE vc_AddTag
	@tagText varchar(20), 
	@description varchar(100) = NULL
AS
BEGIN
	INSERT vc_Tag (TagText, TagDescription) 
	VALUES (@tagText, @description)

	RETURN SCOPE_IDENTITY();
END
go

DECLARE @newTagID int;
EXEC @newTagID = vc_AddTag 'SQL', 'Finally, a SQL Tag';
SELECT * 
FROM vc_Tag 
where vc_TagID = @newTagID;
go

CREATE OR ALTER PROCEDURE vc_FinishVidCast
	@vidcastID int
AS
BEGIN
UPDATE	vc_VidCast
SET		EndDateTime = GETDATE(),
		vc_StatusID = (SELECT vc_StatusID FROM vc_Status WHERE StatusText = 'Finished')
WHERE	vc_VidCast.vc_VidCastID = @vidcastID;
END
go

DECLARE @newVC int;
INSERT INTO vc_VidCast (VidCastTitle, StartDateTime, ScheduleDurationMinutes, vc_UserID, vc_StatusID)
VALUES ('Finally done with sprocs', DATEADD(n, -45, GETDATE()), 45,
		(SELECT vc_UserID FROM vc_User WHERE UserName = 'tardy'),
		(SELECT vc_statusID FROM vc_Status WHERE StatusText='Started') );
SET @newVC = SCOPE_IDENTITY();
SELECT * FROM vc_VidCast 
WHERE vc_VidCastID = @newVC;
EXEC vc_FinishVidCast @newVC;
SELECT * FROM vc_VidCast 
WHERE vc_VidCastID = @newVC;
go