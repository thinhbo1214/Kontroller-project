
-- DECLARE @UserId UNIQUEIDENTIFIER;
-- DECLARE @GameId UNIQUEIDENTIFIER;
-- DECLARE @Content NVARCHAR(MAX);
-- DECLARE @Rating FLOAT;
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
            @GameId = @gameId, 
            @ReviewId = @reviewId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;  

        EXEC DBO.GP_UpdateGameIncreaseReview
            @GameId = @gameId, 
            @Result = @Temp OUTPUT;
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