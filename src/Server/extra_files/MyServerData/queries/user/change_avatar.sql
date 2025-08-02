-- DECLARE @UserId UNIQUEIDENTIFIER = 'B570F1D1-B092-4A16-BD0F-F73837A5F3DF';
-- DECLARE @Avatar varchar(100) = 'https://drive.google.com/file/d/1vqINurv3bx5mZOfC4zsQyHoIwM0SC_nj/view?usp=drive_link'

BEGIN TRY
    BEGIN TRANSACTION;

        EXEC DBO.UP_UpdateUserAvatar @UserId, @Avatar;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT -1 ERROR_CODE;
END CATCH

