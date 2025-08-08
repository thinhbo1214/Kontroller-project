-- DECLARE @Username varchar(100) = 'admin1'
-- DECLARE @Password varchar(100) = 'Admin1@123'
-- DECLARE @Email varchar(100) = 'admin1@gmail.com'
DECLARE @UserId UNIQUEIDENTIFIER;

BEGIN TRY
    BEGIN TRANSACTION;

       EXEC DBO.UP_CreateUser @Username, @Password, @Email, @NewUserId = @UserId OUTPUT;

        IF @UserId IS NULL
            RAISERROR('Đăng ký không thành công!',16,1); 

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @UserId = NULL
END CATCH

SELECT @UserId;