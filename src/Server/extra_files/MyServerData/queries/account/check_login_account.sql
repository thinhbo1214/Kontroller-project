--DECLARE @Username varchar(100) = 'admin1'
--DECLARE @Password varchar(100) = 'Admin1@123'
DECLARE @UserId UNIQUEIDENTIFIER;

BEGIN TRY
    BEGIN TRANSACTION

        EXEC DBO.UP_CheckLoginAccount @Username, @Password, @UserId = @UserId OUTPUT; -- Check if the account exists and return UsedId if success
  
        IF @UserId IS NULL
            RAISERROR('Đăng nhập không thành công!',16,1); 
    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @UserId = NULL
END CATCH

SELECT @UserId;