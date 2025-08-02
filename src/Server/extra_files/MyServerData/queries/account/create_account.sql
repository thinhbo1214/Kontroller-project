-- DECLARE @Username varchar(100) = 'admin1'
-- DECLARE @Password varchar(100) = 'Admin1@123'
-- DECLARE @Email varchar(100) = 'admin1@gmail.com'

BEGIN TRY
    BEGIN TRANSACTION;

       EXEC DBO.UP_CreateUser @Username, @Password, @Email; -- Create user and return the user ID if success

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT NULL AS UserID;
END CATCH