-- Đảm bảo con trỏ không tồn tại trước khi khai báo mới
IF CURSOR_STATUS('local', 'game_cursor') >= -1
BEGIN
    CLOSE game_cursor;
    DEALLOCATE game_cursor;
END

IF CURSOR_STATUS('local', 'user_cursor') >= -1
BEGIN
    CLOSE user_cursor;
    DEALLOCATE user_cursor;
END

DECLARE 
    @gameId UNIQUEIDENTIFIER,
    @userId UNIQUEIDENTIFIER, 
    @reviewId UNIQUEIDENTIFIER,
    @commentId UNIQUEIDENTIFIER,
    @reactionId UNIQUEIDENTIFIER,
    @result INT,
    @Temp INT = 1,
    @contentReview NVARCHAR(MAX),
    @contentComment NVARCHAR(MAX),
    @rating FLOAT,
    @reactionType INT;

DECLARE game_cursor CURSOR LOCAL FAST_FORWARD FOR
    SELECT gameId FROM Games;

DECLARE @phrases TABLE (phrase NVARCHAR(100));
INSERT INTO @phrases VALUES 
(N'Cốt truyện hấp dẫn'),
(N'Đồ họa đẹp'),
(N'Gameplay mượt mà'),
(N'Trải nghiệm rất tốt'),
(N'Nhân vật phong phú');

BEGIN TRY
    OPEN game_cursor;
    FETCH NEXT FROM game_cursor INTO @gameId;

    WHILE @@FETCH_STATUS = 0
    BEGIN

        -- Declare user_cursor ở đây, bên trong vòng lặp game
        DECLARE user_cursor CURSOR LOCAL FAST_FORWARD FOR
            SELECT userId FROM Users;

        OPEN user_cursor;
        FETCH NEXT FROM user_cursor INTO @userId;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            BEGIN TRANSACTION;

            SET @result = 1;
            SET @Temp = 1;

            -- Tạo nội dung review ngẫu nhiên
            SELECT @contentReview = STRING_AGG(phrase, ', ') 
            FROM (
                SELECT TOP 3 phrase FROM @phrases ORDER BY NEWID()
            ) AS T;

            SET @rating = ROUND((RAND(CHECKSUM(NEWID())) * 10), 1);

            EXEC DBO.RP_CreateReview 
                @Content = @contentReview, 
                @Rating = @rating, 
                @ReviewId = @reviewId OUTPUT;

            EXEC DBO.GRP_AddGameReview 
                @GameId = @gameId, 
                @ReviewId = @reviewId, 
                @Result = @result OUTPUT;
            SET @Temp *= @result;

            EXEC DBO.RUP_CreateReviewUser 
                @ReviewId = @reviewId, 
                @Author = @userId, 
                @Result = @result OUTPUT;
            SET @Temp *= @result;

            -- Tạo nội dung comment ngẫu nhiên
            SELECT @contentComment = STRING_AGG(phrase, ', ') 
            FROM (
                SELECT TOP 2 phrase FROM @phrases ORDER BY NEWID()
            ) AS T;

            EXEC DBO.CP_CreateComment 
                @Content = @contentComment, 
                @CommentId = @commentId OUTPUT;

            EXEC DBO.CRP_AddCommentReview 
                @ReviewId = @reviewId, 
                @CommentId = @commentId, 
                @Result = @result OUTPUT;
            SET @Temp *= @result;

            EXEC DBO.CUP_AddCommentUser 
                @CommentId = @commentId, 
                @Author = @userId, 
                @Result = @result OUTPUT;
            SET @Temp *= @result;

            -- Reaction cho comment
            SET @reactionType = 1 + FLOOR(RAND(CHECKSUM(NEWID())) * 5);

            EXEC DBO.RP_CreateReaction 
                @ReactionType = @reactionType, 
                @ReactionId = @reactionId OUTPUT;

            EXEC DBO.CRP_AddCommentReaction 
                @CommentId = @commentId, 
                @ReactionId = @reactionId, 
                @Result = @result OUTPUT;
            SET @Temp *= @result;

            EXEC DBO.RUP_AddReactionUser 
                @ReactionId = @reactionId, 
                @Author = @userId, 
                @Result = @result OUTPUT;
            SET @Temp *= @result;

            -- Reaction cho review
            SET @reactionType = 1 + FLOOR(RAND(CHECKSUM(NEWID())) * 5);

            EXEC DBO.RP_CreateReaction 
                @ReactionType = @reactionType, 
                @ReactionId = @reactionId OUTPUT;

            EXEC DBO.RRP_CreateReviewReaction 
                @ReviewId = @reviewId, 
                @ReactionId = @reactionId, 
                @Result = @result OUTPUT;
            SET @Temp *= @result;

            EXEC DBO.RUP_AddReactionUser 
                @ReactionId = @reactionId, 
                @Author = @userId, 
                @Result = @result OUTPUT;
            SET @Temp *= @result;

            IF @Temp = 0
            BEGIN
                ROLLBACK TRANSACTION;
            END
            ELSE
            BEGIN
                COMMIT TRANSACTION;
            END

            FETCH NEXT FROM user_cursor INTO @userId;
        END

        CLOSE user_cursor;
        DEALLOCATE user_cursor;

        FETCH NEXT FROM game_cursor INTO @gameId;
    END

    CLOSE game_cursor;
    DEALLOCATE game_cursor;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    -- Kiểm tra và đóng game_cursor nếu tồn tại
    IF CURSOR_STATUS('local', 'game_cursor') >= 0
    BEGIN
        CLOSE game_cursor;
        DEALLOCATE game_cursor;
    END

    -- Kiểm tra và đóng user_cursor nếu tồn tại và đang mở
    IF CURSOR_STATUS('local', 'user_cursor') >= 0
    BEGIN
        CLOSE user_cursor;
        DEALLOCATE user_cursor;
    END

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

PRINT N'Hoàn thành tạo dữ liệu nền cho tất cả game trong bảng Games.';
