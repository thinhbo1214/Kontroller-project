-- DECLARE @UserId UNIQUEIDENTIFIER = '...';
-- DECLARE @Target UNIQUEIDENTIFIER = '...';
DECLARE @Result INT = 1;
DECLARE @Temp INT;

BEGIN TRY
    BEGIN TRANSACTION;

        -- Thêm follow
        EXEC DBO.UUP_AddUserFollow 
            @UserFollower = @UserId, 
            @UserFollowing = @Target, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Tăng follower cho target
        EXEC DBO.UP_UpdateUserIncreaseFollower 
            @UserId = @Target, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Tăng following cho user
        EXEC DBO.UP_UpdateUserIncreaseFollowing 
            @UserId = @UserId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        IF @Result = 0
            RAISERROR('Follow ko thành công!', 16, 1);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @Result = 0;
END CATCH

SELECT @Result;
