--  DECLARE @UserId UNIQUEIDENTIFIER = 'a96e7ea1-425b-4c86-a9d3-8ed076db7e9a';
 -- DECLARE @OldPassword varchar(100) = '}qW9v9Aoe!X+'
 -- DECLARE @NewPassword varchar(100) = 'Admin1@123'

BEGIN TRY
    BEGIN TRANSACTION;

        EXEC DBO.UP_ChangePassword @UserId, @OldPassword, @NewPassword;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT -1 ERROR_CODE;
END CATCH

