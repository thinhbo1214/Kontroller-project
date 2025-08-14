-- DECLARE @Username VARCHAR(100) = 'admin';
BEGIN TRY
    BEGIN TRANSACTION

        SELECT userId
        FROM Users
        WHERE username = @Username

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SELECT 
         ERROR_MESSAGE(),
         ERROR_SEVERITY(),
         ERROR_STATE();

    SELECT  NULL AS UserInfo
END CATCH