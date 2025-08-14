-- DECLARE @UserId UNIQUEIDENTIFIER = '45B4C3C5-BEA0-4251-98C6-A81828CB0B9C';
-- DECLARE @GameId UNIQUEIDENTIFIER = 'A85E5BD2-71BD-4079-B194-03C727DF60F4';
-- DECLARE @Content NVARCHAR(MAX) = N'Game tạm chấp nhận được';
-- DECLARE @Rating INT = 6;
DECLARE @ReviewId UNIQUEIDENTIFIER;
DECLARE @Result INT = 1;
DECLARE @Temp INT = 1;

BEGIN TRY
    BEGIN TRANSACTION;

        -- 1. Kiểm tra user đã review game này chưa
        IF EXISTS (
            SELECT 1
            FROM Game_Review GR
            INNER JOIN Review_User RU ON GR.reviewId = RU.reviewId
            WHERE GR.gameId = @GameId
              AND RU.author = @UserId
        )
        BEGIN
            RAISERROR('User đã review game này!', 16, 1);
        END

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

    SELECT 
         ERROR_MESSAGE(),
         ERROR_SEVERITY(),
         ERROR_STATE();

    SET @Result = 0;
END CATCH

SELECT @Result;