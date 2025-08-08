-- DECLARE @UserId UNIQUEIDENTIFIER = 'ab66556f-4bcf-4259-a7c2-f1818f0d3f37';
-- DECLARE @Username VARCHAR(100) = 'admin1';
DECLARE @Result INT;

BEGIN TRY
    BEGIN TRANSACTION;
        
        EXEC DBO.UP_UpdateUserUsername @UserId, @Username, @Result = @Result OUTPUT;

        IF @Result < 1
            RAISERROR('Cập nhật username không thành công!',16,1); 

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @Result = 0;
END CATCH

SELECT @Result;
