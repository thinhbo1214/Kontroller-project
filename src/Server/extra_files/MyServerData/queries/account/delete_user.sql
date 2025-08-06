--DECLARE @UserId UNIQUEIDENTIFIER = '9919728E-43C9-43B5-87B2-C79A0B8763F3';
--DECLARE @Password VARCHAR(100) = 'Admin1@123';
DECLARE @Result INT;

BEGIN TRY
    BEGIN TRANSACTION;

        EXEC DBO.UP_DeleteUser @UserId, @Password, @Result = @Result OUTPUT;

        IF @Result < 1
            RAISERROR('Xoá tài khoản không thành công!',16,1); 

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @Result = 0;
END CATCH

SELECT @Result;

