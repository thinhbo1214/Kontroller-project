-- DECLARE @UserId UNIQUEIDENTIFIER = '45B4C3C5-BEA0-4251-98C6-A81828CB0B9C';
-- DECLARE @ReviewId UNIQUEIDENTIFIER = '3D0A6A38-2B2B-4670-9260-AFB2CF4AD698';
-- DECLARE @CommentId UNIQUEIDENTIFIER = 'FB6D39AB-C2EA-430B-9BD7-91701E614857';
DECLARE @Result INT = 1;
DECLARE @Temp INT = 1;

BEGIN TRY
    BEGIN TRANSACTION;

        -- Kiểm tra xem user có sở hữu comment không
        IF DBO.CUF_CommentUserExists(@CommentId, @UserId) = 0
            RAISERROR('User không sở hữu comment!', 16, 1);

        DECLARE @ReactionsC IdList;

        -- Lấy tất cả reaction liên quan đến comment
        INSERT INTO @ReactionsC (Id)
        SELECT reactionId
        FROM Comment_Reaction
        WHERE commentId = @CommentId;

        -- Xóa liên kết giữa reaction và comment
        EXEC DBO.CRP_DeleteReactions @ReactionsC, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xóa liên kết giữa reaction và user
        EXEC DBO.RUP_DeleteReactions @ReactionsC, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;


        -- Xóa liên kết giữa comment và review
        EXEC DBO.CRP_DeleteCommentReview @CommentId,@ReviewId, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xóa liên kết giữa comment và user
        EXEC DBO.CUP_DeleteCommentUser @CommentId, @UserId, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xóa reaction của comment
        EXEC DBO.RP_DeleteReactions @ReactionsC, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xóa comment
        EXEC DBO.CP_DeleteComment @CommentId, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Cập nhật số lượng comment của review
        EXEC DBO.RP_UpdateReviewDecreaseComment @ReviewId, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        IF @Result = 0
            RAISERROR('Xóa comment không thành công!', 16, 1);

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

SELECT @Result t8;