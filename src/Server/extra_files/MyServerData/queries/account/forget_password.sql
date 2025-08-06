--DECLARE @Email varchar(100) = 'admin1@gmail.com'
DECLARE @NewPassword VARCHAR(100);

BEGIN TRY
    BEGIN TRANSACTION;
     
        EXEC DBO.UP_ForgetPassword @Email, @NewPassword OUTPUT;
        
        IF @NewPassword IS NULL
            RAISERROR('Khôi phục mật khẩu không thành công!',16,1); 

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @NewPassword = NULL;
END CATCH

SELECT @NewPassword;
