-- DECLARE @UserId UNIQUEIDENTIFIER = '45B4C3C5-BEA0-4251-98C6-A81828CB0B9C';
-- DECLARE @ReviewId UNIQUEIDENTIFIER = '753E0E2C-6B2C-46ED-A6C4-A7F0E4EC33AE';
-- DECLARE @Content NVARCHAR(MAX) = N'Bình luận rất hay!';
DECLARE @CommentId UNIQUEIDENTIFIER;
DECLARE @Result INT = 1;
DECLARE @Temp INT = 1;

BEGIN TRY
    BEGIN TRANSACTION;

        -- Tạo comment mới
        EXEC DBO.CP_CreateComment 
            @Content = @Content, 
            @CommentId = @CommentId OUTPUT;

        -- Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview 
            @ReviewId = @ReviewId, 
            @CommentId = @CommentId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Liên kết comment với user
        EXEC DBO.CUP_AddCommentUser 
            @CommentId = @CommentId, 
            @Author = @UserId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Cập nhật số lượng comment của review
        EXEC DBO.RP_UpdateReviewIncreaseComment
            @ReviewId = @ReviewId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        IF @Result = 0
            RAISERROR('Tạo comment không thành công!', 16, 1);

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