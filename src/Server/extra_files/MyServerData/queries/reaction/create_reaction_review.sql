-- DECLARE @UserId UNIQUEIDENTIFIER = '45B4C3C5-BEA0-4251-98C6-A81828CB0B9C';
-- DECLARE @ReviewId UNIQUEIDENTIFIER = '3D0A6A38-2B2B-4670-9260-AFB2CF4AD698';
-- DECLARE @ReactionType INT = 1; -- Giả định ReactionType là kiểu reaction, ví dụ: Like, Dislike, v.v.
DECLARE @ReactionId UNIQUEIDENTIFIER;
DECLARE @Result INT = 1;
DECLARE @Temp INT = 1;

BEGIN TRY
    BEGIN TRANSACTION;

        IF EXISTS (
            SELECT 1
            FROM Review_Reaction RR
            JOIN Reaction_User RU ON RR.reactionId = RU.reactionId
            WHERE RR.reviewId = @ReviewId
              AND RU.author = @UserId
        )
        BEGIN
            RAISERROR('Reaction đã tồn tại cho user này trên review này!', 16, 1);
            RETURN;
        END

        -- Tạo reaction mới
        EXEC DBO.RP_CreateReaction 
            @ReactionType = @ReactionType, 
            @ReactionId = @ReactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction
            @ReviewId = @ReviewId, 
            @ReactionId = @ReactionId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser 
            @ReactionId = @ReactionId, 
            @Author = @UserId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Cập nhật số lượng reaction của review
        EXEC DBO.RP_UpdateReviewIncreaseReaction
            @ReviewId = @ReviewId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        IF @Result = 0
            RAISERROR('Tạo reaction không thành công!', 16, 1);

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