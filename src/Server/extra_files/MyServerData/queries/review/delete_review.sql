-- DECLARE @UserId UNIQUEIDENTIFIER;
-- DECLARE @GameId UNIQUEIDENTIFIER;
-- DECLARE @ReviewId UNIQUEIDENTIFIER;
DECLARE @Result INT = 1;
DECLARE @Temp INT = 1;

BEGIN TRY
    BEGIN TRANSACTION;

        IF DBO.RUF_ReviewUserExists(@UserId, @ReviewId) = 0
            RAISERROR('User không sở hữu review!',16,1);

        DECLARE @Comments IdList;
        DECLARE @ReactionsC IdList;
        DECLARE @ReactionsR IdList;

        -- Lấy tất cả comment của review
        INSERT INTO @Comments (Id)
        EXEC DBO.CRP_GetCommentsByReview @ReviewId = @ReviewId;

        -- Lấy tất cả reaction liên quan đến các comment vừa lấy
        INSERT INTO @ReactionsC (Id)
        SELECT reactionId
        FROM Comment_Reaction
        WHERE commentId IN (SELECT Id FROM @Comments);

         -- Lấy tất cả reaction liên quan đến review
        INSERT INTO @ReactionsR (Id)
        EXEC DBO.RRP_GetReactionsByReview @ReviewId = @ReviewId;

        -- Xoá liên kết giữa comment với review
        EXEC DBO.CRP_DeleteComments @Comments, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xoá liên kết comment với user
        EXEC DBO.CUP_DeleteComments @Comments, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xoá liên kết giữa reaction với comment
        EXEC DBO.CRP_DeleteReactions @ReactionsC, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xoá liên kết giữa reaction với user
        EXEC DBO.RUP_DeleteReactions @ReactionsC, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xoá liên kết giữa reaction với review
        EXEC DBO.RRP_DeleteReactions @ReactionsR, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xoá liên kết giữa reaction với user
        EXEC DBO.RUP_DeleteReactions @ReactionsR, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xoá liên kết review với game
        EXEC DBO.GRP_DeleteGameReview @GameId, @ReviewId, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xoá liên kết review với user
        EXEC DBO.RUP_DeleteReviewUser @UserId, @ReviewId, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xoá reaction ở comment
        EXEC DBO.RP_DeleteReactions @ReactionsC, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xoá reaction ở review
        EXEC DBO.RP_DeleteReactions @ReactionsR, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xoá comment
        EXEC DBO.CP_DeleteComments @Comments, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xoá review
        EXEC DBO.RP_DeleteReview @ReviewId, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        EXEC DBO.GP_UpdateGameDecreaseReview @GameId, @Result = @Temp;
        SET @Result *= @Temp;

        IF @Result = 0
            RAISERROR('Xoá review không thành công!',16,1);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @Result = 0;
END CATCH

SELECT @Result;