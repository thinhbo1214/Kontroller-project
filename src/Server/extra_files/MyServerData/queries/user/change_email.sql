-- DECLARE @UserId UNIQUEIDENTIFIER = '2d1f1b33-8d1e-4722-b566-125fca142750';
-- DECLARE @NewEmail varchar(100) = 'kingnemacc1@gmail.com';
DECLARE @Result INT;

BEGIN TRY
    BEGIN TRANSACTION;
        EXEC DBO.UP_UpdateUserEmail @UserId, @NewEmail, @Result = @Result OUTPUT;

        IF @Result = 0
            RAISERROR('Cập nhật email không thành công!', 16, 1);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @Result = 0;
END CATCH

SELECT @Result;
