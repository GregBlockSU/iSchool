USE vbay;
go

CREATE OR ALTER PROCEDURE dbo.NoCommit
	@user_id int,
	@user_email varchar(50)
AS
BEGIN TRANSACTION;
UPDATE dbo.vb_users
SET user_email = @user_email
WHERE	user_id = @user_id;
IF @@ROWCOUNT > 0
COMMIT;
go

EXEC dbo.NoCommit
	@user_id = 1,
	@user_email = 'abuss@mail.org';

	select @@TRANCOUNT
	ROLLBACK


BEGIN TRY
	EXEC dbo.NoCommit @user_id = 1,
	@user_email = 'abuss@mail.org';

	BEGIN TRAN;

	COMMIT;
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
		ROLLBACK;
END CATCH
go