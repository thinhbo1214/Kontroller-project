-- DECLARE @UserId UNIQUEIDENTIFIER;
-- DECLARE @Target UNIQUEIDENTIFIER;
DECLARE @Result INT;

BEGIN TRY
    BEGIN TRANSACTION;
        SET @Result = 1;
        DECLARE @Temp INT;

        EXEC DBO.UUP_RemoveUserFollow 
            @UserFollower = @UserId, 
            @UserFollowing = @Target, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        EXEC DBO.UP_UpdateUserDecreaseFollower @UserId = @Target, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        EXEC DBO.UP_UpdateUserDecreaseFollowing @UserId = @UserId, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        IF @Result = 0
            RAISERROR('Unfollow ko thành công!', 16, 1);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @Result = 0;
END CATCH

SELECT @Result;
