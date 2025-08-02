DECLARE @UserId UNIQUEIDENTIFIER;
BEGIN TRY
    SELECT @UserId =  DBO.UP_CreateUser @Username, @Password, @Email; -- Create user and return the user ID if success
END TRY
BEGIN CATCH
    SET @UserId = NULL;
END CATCH

SELECT  @UserId AS UserId