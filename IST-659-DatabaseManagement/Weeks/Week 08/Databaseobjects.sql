
CREATE OR ALTER PROCEDURE InsertFollower
	@UserName1 AS varchar(30),
	@UserName2 AS varchar(30)
AS

IF NOT EXISTS (SELECT * FROM vc_FollowerList WHERE FollowedID = (SELECT vc_UserID FROM vc_User WHERE UserName = @UserName1) AND
	FollowerID = (SELECT vc_UserID FROM vc_User WHERE UserName = @UserName2))
BEGIN
	INSERT vc_FollowerList (FollowedID, FollowerID, FollowerSince) 
	VALUES ((SELECT vc_UserID FROM vc_User WHERE UserName = @UserName1), 
			(SELECT vc_UserID FROM vc_User WHERE UserName = @UserName2),
			CURRENT_TIMESTAMP );
END
	SELECT * FROM vc_FollowerList
	WHERE FollowedID = (SELECT vc_UserID FROM vc_User WHERE UserName = @UserName1) AND
			FollowerID = (SELECT vc_UserID FROM vc_User WHERE UserName = @UserName2);
go

EXEC InsertFollower 'infatuated', 'camel';