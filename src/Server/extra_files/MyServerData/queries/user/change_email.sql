--DECLARE @UserId UNIQUEIDENTIFIER = '838844B4-24CC-44B6-A990-3D01B6B5F3DD';
--DECLARE @NewEmail varchar(100) = 'admin1@gmail.com';
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
