-- DECLARE @UserId UNIQUEIDENTIFIER = '2d1f1b33-8d1e-4722-b566-125fca142750';
-- DECLARE @Avatar varchar(255) = 'https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/482752AXp/anh-mo-ta.png'
DECLARE @Result INT;

BEGIN TRY
    BEGIN TRANSACTION;

        EXEC DBO.UP_UpdateUserAvatar @UserId, @Avatar, @Result = @Result OUTPUT;

        IF @Result = 0
            RAISERROR('Cập nhật avatar không thành công!', 16, 1);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SELECT 
         ERROR_MESSAGE(),
         ERROR_SEVERITY(),
         ERROR_STATE();

    SET @Result = 0;
END CATCH

SELECT @Result;