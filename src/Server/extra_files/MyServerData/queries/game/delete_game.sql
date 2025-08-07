DECLARE @GameId UNIQUEIDENTIFIER = 'E4C7B7E5-0173-459B-AD6B-63FA5855E0CA';
DECLARE @Result INT;

BEGIN TRY
    BEGIN TRANSACTION;

        EXEC DBO.GP_DeleteGame @GameId, @Result = @Result OUTPUT;

        IF @Result < 1
            RAISERROR('Xoá game không thành công!',16,1); 

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @Result = 0;
END CATCH

SELECT @Result;

