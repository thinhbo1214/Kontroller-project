-- DECLARE @UserId UNIQUEIDENTIFIER = 'ab66556f-4bcf-4259-a7c2-f1818f0d3f37';
-- DECLARE @OldPassword varchar(100) = 'Admin1@124'
-- DECLARE @NewPassword varchar(100) = 'Admin1@123'
DECLARE @Result INT;

BEGIN TRY
    BEGIN TRANSACTION;

        EXEC DBO.UP_ChangePassword @UserId, @OldPassword, @NewPassword, @Result = @Result OUTPUT;

        IF @Result < 1
            RAISERROR('Đổi mật khẩu khoản thành công!',16,1); 

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @Result = 0;
END CATCH

SELECT @Result;