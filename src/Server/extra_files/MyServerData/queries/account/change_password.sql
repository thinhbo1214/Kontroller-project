--DECLARE @UserId UNIQUEIDENTIFIER = 'F498B4E1-1E91-4BD4-9CC5-06821885D549';
--DECLARE @OldPassword varchar(100) = 'Admin1@124'
--DECLARE @NewPassword varchar(100) = 'Admin1@123'
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