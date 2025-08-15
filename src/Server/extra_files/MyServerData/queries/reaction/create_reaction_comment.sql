-- DECLARE @UserId UNIQUEIDENTIFIER = '45B4C3C5-BEA0-4251-98C6-A81828CB0B9C';
-- DECLARE @CommentId UNIQUEIDENTIFIER = '225EE596-2873-4B4F-AA56-25A998F9B7ED';
-- DECLARE @ReactionType INT = 1; -- Giả định ReactionType là kiểu reaction, ví dụ: Like, Dislike, v.v.
-- DECLARE @ReactionId UNIQUEIDENTIFIER;
DECLARE @Result INT = 1;
DECLARE @Temp INT = 1;

BEGIN TRY
    BEGIN TRANSACTION;

        -- 1. Kiểm tra đã tồn tại reaction của user trên comment này chưa
        IF EXISTS (
            SELECT 1
            FROM Comment_Reaction CR
            INNER JOIN Reaction_User RU ON CR.reactionId = RU.reactionId
            WHERE CR.commentId = @CommentId
              AND RU.author = @UserId
        )
        BEGIN
            RAISERROR('User đã reaction comment này!', 16, 1);
        END

        -- Tạo reaction mới
        EXEC DBO.RP_CreateReaction 
            @ReactionType = @ReactionType, 
            @ReactionId = @ReactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction
            @CommentId = @CommentId, 
            @ReactionId = @ReactionId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser
            @ReactionId = @ReactionId, 
            @Author = @UserId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Cập nhật số lượng reaction của comment
        EXEC DBO.CP_UpdateCommentIncreaseReaction
            @CommentId = @CommentId, 
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
