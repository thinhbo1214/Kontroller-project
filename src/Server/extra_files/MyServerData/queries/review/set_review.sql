-- DECLARE @UserId UNIQUEIDENTIFIER;
-- DECLARE @GameId UNIQUEIDENTIFIER;
-- DECLARE @Content NVARCHAR(MAX);
-- DECLARE @Rating INT;
-- DECLARE @ReviewId UNIQUEIDENTIFIER;
DECLARE @Result INT = 1;
DECLARE @Temp INT = 1;

BEGIN TRY
    BEGIN TRANSACTION
        IF DBO.RUF_ReviewUserExists(@UserId, @ReviewId) = 0
            RAISERROR('User không sở hữu review!',16,1);
    
        DECLARE @CurrentRate INT;
        EXEC DBO.RP_GetReviewRating @ReviewId, @Rating = @CurrentRate OUTPUT;

        EXEC DBO.RP_UpdateReviewAll @ReviewId, @Content, @Rating, @Result = @Temp OUTPUT;
        SET @Result *= @Temp; 
       
        IF @Rating IS NOT NULL
        BEGIN
            DECLARE @CurrentAvgRate DECIMAL(4,2);
            DECLARE @CurrentNumberReview INT;
            EXEC DBO.GP_GetGameAvgRating @GameId, @AvgRating = @CurrentAvgRate OUTPUT;
            EXEC DBO.GP_GetGameNumberReview @GameId, @NumberReview = @CurrentNumberReview OUTPUT;
            DECLARE @NewAvgRating DECIMAL(4,2) = (@CurrentAvgRate * @CurrentNumberReview + @Rating - @CurrentRate) / (@CurrentNumberReview);

            EXEC DBO.GP_UpdateGameAvgRating @GameId, @NewAvgRating, @Result = @Temp OUTPUT;
            SET @Result *= @Temp; 
        END
     
        IF @Result = 0
            RAISERROR('Cập nhật review không thành công!', 16, 1);

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @Result = 0;
END CATCH

SELECT @Result;