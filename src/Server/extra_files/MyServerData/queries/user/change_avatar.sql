-- DECLARE @UserId UNIQUEIDENTIFIER = 'a21fb87f-2185-4863-abe5-0da8a0c41b20';
-- DECLARE @Avatar varchar(255) = 'https://img.tripi.vn/cdn-cgi/image/width=700,height=700/https://gcs.tripi.vn/public-tripi/tripi-feed/img/482752AXp/anh-mo-ta.png'

BEGIN TRY
    BEGIN TRANSACTION;

        EXEC DBO.UP_UpdateUserAvatar @UserId, @Avatar;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SELECT -1 ERROR_CODE;
END CATCH

