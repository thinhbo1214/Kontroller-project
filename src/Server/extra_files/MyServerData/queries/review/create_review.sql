-- DECLARE @UserId UNIQUEIDENTIFIER;
-- DECLARE @GameId UNIQUEIDENTIFIER;
-- DECLARE @Content NVARCHAR(MAX);
-- DECLARE @Rating INT;
DECLARE @ReviewId UNIQUEIDENTIFIER;
DECLARE @Result INT = 1;
DECLARE @Temp INT = 1;

BEGIN TRY
    BEGIN TRANSACTION;

        EXEC DBO.RP_CreateReview 
            @Content = @Content, 
            @Rating = @Rating, 
            @ReviewId = @reviewId OUTPUT;

        EXEC DBO.GRP_AddGameReview 
            @GameId = @GameId, 
            @ReviewId = @ReviewId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;  

        DECLARE @CurrentAvgRate DECIMAL(4,2);
        DECLARE @CurrentNumberReview INT;
        EXEC DBO.GP_GetGameAvgRating @GameId, @AvgRating = @CurrentAvgRate OUTPUT;
        EXEC DBO.GP_GetGameNumberReview @GameId, @NumberReview = @CurrentNumberReview OUTPUT;
        DECLARE @NewAvgRating DECIMAL(4,2) = (@CurrentAvgRate * @CurrentNumberReview + @Rating) / (@CurrentNumberReview + 1)

        EXEC DBO.GP_UpdateGameAvgRating @GameId, @NewAvgRating, @Result = @Temp OUTPUT;
        SET @Result *= @Temp; 

        EXEC DBO.GP_UpdateGameIncreaseReview
            @GameId = @GameId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;  

        EXEC DBO.RUP_CreateReviewUser 
            @ReviewId = @reviewId, 
            @Author = @UserId, 
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