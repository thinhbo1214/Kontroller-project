-- DECLARE @UserId UNIQUEIDENTIFIER;
-- DECLARE @GameId UNIQUEIDENTIFIER;
-- DECLARE @ReviewId UNIQUEIDENTIFIER;
DECLARE @Result INT = 1;
DECLARE @Temp INT = 1;

BEGIN TRY
    BEGIN TRANSACTION;

        DECLARE @Comments TABLE (Id UNIQUEIDENTIFIER);

        INSERT INTO @Comments (Id)
        EXEC DBO.CRP_GetCommentsByReview @ReviewId = @ReviewId;

        EXEC DBO.CRP_DeleteCommentByReview @ReviewId, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        EXEC DBO.CP_DeleteCommentByReview @ReviewId, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        EXEC DBO.RRP_DeleteReactionByReview @ReviewId, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        EXEC DBO.RP_DeleteReactionByReview @ReviewId, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        EXEC DBO.RUP_CreateReviewUser 
            @ReviewId = @reviewId, 
            @Author = @userId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;         

        IF @Result = 0
            RAISERROR('Tạo review không thành công!',16,1);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @Result = 0;
END CATCH

SELECT @Result;