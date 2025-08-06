--DECLARE @UserId UNIQUEIDENTIFIER = 'F498B4E1-1E91-4BD4-9CC5-06821885D549';
--DECLARE @Username VARCHAR(100) = 'admin1';
DECLARE @Result INT;

BEGIN TRY
    BEGIN TRANSACTION;
        
        EXEC DBO.UP_UpdateUsername @UserId, @Username, @Result = @Result OUTPUT;

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
