-- DECLARE @UserId UNIQUEIDENTIFIER = '45B4C3C5-BEA0-4251-98C6-A81828CB0B9C';
-- DECLARE @CommentId UNIQUEIDENTIFIER = '8BF84BBD-EC6F-40DD-969D-9EE2AF9DB169';
- DECLARE @ReactionId UNIQUEIDENTIFIER = 'AB7C3886-B5DF-49F7-A984-741EB3D817B8';
DECLARE @Result INT = 1;
DECLARE @Temp INT = 1;

BEGIN TRY
    BEGIN TRANSACTION;

        -- Kiểm tra xem user có sở hữu reaction không
        IF DBO.RUF_ReactionUserExists(@ReactionId, @UserId) = 0
            RAISERROR('User không sở hữu reaction!', 16, 1);

        -- Xóa liên kết giữa reaction và comment
        EXEC DBO.CRP_DeleteCommentReaction
            @CommentId = @CommentId, 
            @ReactionId = @ReactionId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xóa liên kết giữa reaction và user
        EXEC DBO.RUP_DeleteReactionUser 
            @Author = @UserId, 
            @ReactionId = @ReactionId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xóa reaction
        EXEC DBO.RP_DeleteReaction 
            @ReactionId = @ReactionId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Cập nhật số lượng reaction của comment
        EXEC DBO.CP_UpdateCommentDecreaseReaction 
            @CommentId = @CommentId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        IF @Result = 0
            RAISERROR('Xóa reaction không thành công!', 16, 1);

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