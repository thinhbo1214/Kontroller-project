USE KontrollerDB;
GO

-- Declare variable for gameId
DECLARE @gameId UNIQUEIDENTIFIER;
DECLARE @userId UNIQUEIDENTIFIER;
DECLARE @commentId UNIQUEIDENTIFIER;
DECLARE @reviewId UNIQUEIDENTIFIER;
DECLARE @reactionId UNIQUEIDENTIFIER;
DECLARE @result INT;
DECLARE @Temp INT;

-- Insert data into Games table for Cabernet
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Cabernet',
         'A 2D narrative-driven RPG set in 19th-century Eastern Europe, exploring vampire lore through grounded storytelling.',
         'RPG, Narrative, 2D',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co6x36.webp',
         'https://cdn.checkpointgaming.net/wp-content/uploads/2025/03/18140754/20250312225541_1.jpg',
         'Studio: Independent, Publisher: Indie Publisher, Release Date: 2025-06-15, Country: Eastern Europe, Languages: English, German'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox'),
        (@gameId, 'Switch');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_cabernet001', @Password = 'Cabernet@001', @Email = 'cabernet001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Cabernet có cốt truyện hấp dẫn và hình ảnh đẹp!', @Rating = 8.0, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Đồng ý, cốt truyện rất sâu sắc!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH


-- Insert data into Games table for Blue Prince
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Blue Prince',
         'A challenging roguelike puzzle game set in a shapeshifting manor house with intricate details and grand mysteries.',
         'Puzzle, Roguelike, Adventure',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9mzd.webp',
         'https://images.squarespace-cdn.com/content/v1/65ef2c66a5782874ae97e65c/ef5f6b59-bfe2-4527-832e-0f31f70e817b/HouseLandscape+1.png?format=2500w',
         'Studio: Independent, Publisher: Indie Publisher, Release Date: 2025-05-10, Country: USA, Languages: English'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_blueprince001', @Password = 'BluePrince@001', @Email = 'blueprince001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Blue Prince có các câu đố rất thú vị!', @Rating = 7.5, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Đúng vậy, rất thử thách!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Wuchang: Fallen Feathers
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Wuchang: Fallen Feathers',
         'A soulslike action RPG set in the late Ming Dynasty, featuring deep combat and a mysterious illness spawning monsters.',
         'Action RPG, Souls-like, Dark Fantasy',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9xif.webp',
         'https://static.wixstatic.com/media/f95046_7a6cc533f4214fa894629d3b2d6b5abe~mv2.webp/v1/fill/w_568,h_320,al_c,q_80,usm_0.66_1.00_0.01,enc_avif,quality_auto/f95046_7a6cc533f4214fa894629d3b2d6b5abe~mv2.webp',
         'Studio: Leenzee Games, Publisher: Independent, Release Date: 2025-07-24, Country: China, Languages: English, Chinese'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_wuchang001', @Password = 'Wuchang@001', @Email = 'wuchang001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Combat trong Wuchang rất mượt mà!', @Rating = 9.0, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Đồng ý, rất giống soulslike!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for The First Berserker: Khazan
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'The First Berserker: Khazan',
         'A challenging soulslike game with parry-heavy combat and stunning visuals, inspired by Sekiro.',
         'Action, Souls-like, RPG',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co8roc.webp',
         'https://images.rpgsite.net/image/da49c9a1/148347/original/The-First-Berserker-Khazan-Review_07.jpg',
         'Studio: Neople, Publisher: Independent, Release Date: 2025-04-15, Country: South Korea, Languages: English, Korean'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_berserker001', @Password = 'Berserker@001', @Email = 'berserker001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'The First Berserker: Khazan có combat tuyệt vời!', @Rating = 8.8, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Parry heavy, giống Sekiro lắm!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Mario Kart World
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Mario Kart World',
         'A new installment in the Mario Kart series with rail grinding and new characters like Cow and Wario.',
         'Racing, Party, Multiplayer',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9m78.webp',
         'https://assets.bwbx.io/images/users/iqjWHBFdfxIU/izvTNxMZQ.TY/v1/-1x-1.webp',
         'Studio: Nintendo, Publisher: Nintendo, Release Date: 2025-03-01, Country: Japan, Languages: English, Japanese, Spanish'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'Switch'),
        (@gameId, 'Switch 2');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_mariokart001', @Password = 'MarioKart@001', @Email = 'mariokart001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Mario Kart World vui nhộn và đầy bất ngờ!', @Rating = 9.5, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Nhân vật mới rất thú vị!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for FBC: Firebreak
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'FBC: Firebreak',
         'A Control spin-off with class-based builds and solid gunplay, venturing into live-service territory.',
         'Action, Shooter, Live-Service',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9p0f.webp',
         'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/2272540/ss_f1eed20e5754ed972cc59508dfdaf8a0b21de5ca.1920x1080.jpg?t=1750276227',
         'Studio: Remedy Entertainment, Publisher: 505 Games, Release Date: 2025-06-01, Country: Finland, Languages: English, German, French'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_fbc001', @Password = 'FBC@001', @Email = 'fbc001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'FBC: Firebreak có gunplay hay và live-service hấp dẫn!', @Rating = 8.2, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Class-based builds rất thú vị!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for The Sims 4: Enchanted By Nature
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'The Sims 4: Enchanted By Nature',
         'A DLC for The Sims 4 featuring vibrant locales and fairy gameplay for a fantasy life experience.',
         'Simulation, Life Sim',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/coa1af.webp',
         'https://gamingtrend.com/content/images/size/w1200/2025/07/sis-4-5-1-1.png',
         'Studio: Maxis, Publisher: Electronic Arts, Release Date: 2025-05-20, Country: USA, Languages: English, Spanish, French'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_sims001', @Password = 'Sims@001', @Email = 'sims001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'The Sims 4: Enchanted By Nature mang đến trải nghiệm fantasy tuyệt vời!', @Rating = 8.7, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Fairy gameplay rất vui!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Skin Deep
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Skin Deep',
         'An oddball immersive sim blending absurdity with challenging puzzles and environmental experimentation.',
         'Immersive Sim, Puzzle, Action',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9qg3.webp',
         'https://cdn.mos.cms.futurecdn.net/xRxVBSibHtvQQDcHSZku4g.jpg',
         'Studio: Independent, Publisher: Indie Publisher, Release Date: 2025-07-10, Country: USA, Languages: English'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_skindeep001', @Password = 'SkinDeep@001', @Email = 'skindeep001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Skin Deep lạ lẫm và thú vị với các puzzle!', @Rating = 7.8, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Immersive sim hay đấy!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for South of Midnight
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'South of Midnight',
         'An action-adventure with a fantastic story and authentic Southern U.S. setting with imaginative visuals.',
         'Action-Adventure, Narrative',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co8bot.webp',
         'https://sm.ign.com/ign_fr/video/s/south-of-m/south-of-midnight-official-reveal-trailer-xbox-game-showcase_mkfc.jpg',
         'Studio: Compulsion Games, Publisher: Xbox Game Studios, Release Date: 2025-08-01, Country: Canada, Languages: English, French'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_southmidnight001', @Password = 'SouthMidnight@001', @Email = 'southmidnight001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'South of Midnight có cốt truyện tuyệt vời và hình ảnh ấn tượng!', @Rating = 9.2, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Bối cảnh Southern U.S. rất chân thực!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for WWE 2K25
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'WWE 2K25',
         'A wrestling game with an engaging Showcase Mode, large roster, and new features like The Island.',
         'Sports, Wrestling, Simulation',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9c1v.webp',
         'https://cdn.wccftech.com/wp-content/uploads/2025/02/WCCFwwe2k2511.jpg',
         'Studio: Visual Concepts, Publisher: 2K, Release Date: 2025-03-15, Country: USA, Languages: English, Spanish, French'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_wwe001', @Password = 'WWE@001', @Email = 'wwe001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'WWE 2K25 có Showcase Mode hay và roster lớn!', @Rating = 8.5, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'The Island feature mới mẻ lắm!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Clair Obscur: Expedition 33
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Clair Obscur: Expedition 33',
         'A turn-based RPG with real-time mechanics, set in a Belle Époque-inspired fantasy world.',
         'RPG, Turn-Based, Fantasy',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9gam.webp',
         'https://static1.polygonimages.com/wordpress/wp-content/uploads/2025/04/ss_9e050e6a61a4d9f4fe54bc62c8c73da38e9a63b0.1920x1080.jpg',
         'Studio: Independent, Publisher: Indie Publisher, Release Date: 2025-06-30, Country: France, Languages: English, French'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_clair001', @Password = 'Clair@001', @Email = 'clair001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Clair Obscur: Expedition 33 có mechanics turn-based hay!', @Rating = 8.4, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Belle Époque-inspired world đẹp!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Mafia: The Old Country
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Mafia: The Old Country',
         'A gritty mob story set in 1900s Sicily, exploring the origins of organized crime.',
         'Action-Adventure, Crime, Open World',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9s2c.webp',
         'https://i0.wp.com/twistedvoxel.com/wp-content/uploads/2025/05/mafia-the-old-country2.jpg?resize=1170%2C658&ssl=1',
         'Studio: Hangar 13, Publisher: 2K, Release Date: 2025-08-08, Country: USA, Languages: English, Italian'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_mafia001', @Password = 'Mafia@001', @Email = 'mafia001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Mafia: The Old Country có cốt truyện mafia hay!', @Rating = 8.9, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Bối cảnh Sicily 1900s chân thực!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Dying Light: The Beast
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Dying Light: The Beast',
         'A standalone zombie adventure featuring Kyle Crane in a rural region with a focus on revenge.',
         'Action, Survival Horror, Open World',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co8pey.webp',
         'https://static1.thegamerimages.com/wordpress/wp-content/uploads/2024/08/dying-light-the-beast-gameplay-reveal.jpg',
         'Studio: Techland, Publisher: Techland, Release Date: 2025-08-22, Country: Poland, Languages: English, Polish, German'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_dyinglight001', @Password = 'DyingLight@001', @Email = 'dyinglight001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Dying Light: The Beast có adventure zombie hay!', @Rating = 8.6, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Kyle Crane trở lại, tuyệt!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Metal Gear Solid Delta: Snake Eater
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Metal Gear Solid Delta: Snake Eater',
         'A remake of the classic Metal Gear Solid 3 using Unreal Engine 5, focusing on stealth gameplay.',
         'Action, Stealth, Third-Person',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co7lb7.webp',
         'https://www.destructoid.com/wp-content/uploads/2025/08/image-2025-08-06T134042.426.jpg?quality=75',
         'Studio: Konami, Publisher: Konami, Release Date: 2025-08-28, Country: Japan, Languages: English, Japanese, French'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_metalgear001', @Password = 'MetalGear@001', @Email = 'metalgear001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Metal Gear Solid Delta: Snake Eater remake tuyệt vời!', @Rating = 9.3, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Stealth gameplay đỉnh cao!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Lost Soul Aside
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Lost Soul Aside',
         'An action RPG with a unique combat system, stunning graphics, and a compelling storyline.',
         'Action RPG, Third-Person',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9ph5.webp',
         'https://sm.ign.com/t/ign_za/video/l/lost-soul-/lost-soul-aside-official-gameplay-trailer_ex8d.1280.png',
         'Studio: UltiZero Games, Publisher: Independent, Release Date: 2025-07-31, Country: China, Languages: English, Chinese'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_lostsoul001', @Password = 'LostSoul@001', @Email = 'lostsoul001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Lost Soul Aside có combat độc đáo và đồ họa đẹp!', @Rating = 8.5, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Cốt truyện hấp dẫn lắm!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for NINJA GAIDEN: Ragebound
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'NINJA GAIDEN: Ragebound',
         'A side-scrolling ninja adventure redefining the classic NINJA GAIDEN series with challenging gameplay.',
         'Action, Platformer, Ninja',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9qrg.webp',
         'https://www.cnet.com/a/img/resize/23733081b869c78ca778c3c02ac22100f5dd4f30/hub/2025/07/30/446b7cfe-f0d4-4ca3-b0dc-6924ad827436/ninja-gaiden-ragebound-screenshot-5.png?auto=webp&fit=crop&height=675&width=1200',
         'Studio: The Game Kitchen, Publisher: Independent, Release Date: 2025-07-31, Country: Spain, Languages: English, Spanish'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox'),
        (@gameId, 'Switch');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_ninjagaiden001', @Password = 'NinjaGaiden@001', @Email = 'ninjagaiden001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'NINJA GAIDEN: Ragebound tái định nghĩa series cổ điển!', @Rating = 8.1, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Gameplay thử thách cao!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Battlefield 6
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Battlefield 6',
         'A highly anticipated multiplayer shooter with large-scale battles and modern warfare settings.',
         'First-Person Shooter, Multiplayer, War',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/coa5zt.webp',
         'https://static1.thegamerimages.com/wordpress/wp-content/uploads/2025/02/battlefield-6-screenshot-of-player-running-through-the-streets-by-a-tank.jpg?q=70&fit=contain&w=1200&h=628&dpr=1',
         'Studio: DICE, Publisher: Electronic Arts, Release Date: 2025-07-31, Country: Sweden, Languages: English, German, French'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_battlefield001', @Password = 'Battlefield@001', @Email = 'battlefield001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Battlefield 6 có battles quy mô lớn và hiện đại!', @Rating = 9.0, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Multiplayer hay lắm!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Frostpunk 2
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Frostpunk 2',
         'A sequel to Frostpunk, focusing on city-building and survival in a frozen dystopian world.',
         'Strategy, Simulation, Survival',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co8yrc.webp',
         'https://static.wikia.nocookie.net/frostpunk_gamepedia_en/images/1/1f/Announcementwp.jpg/revision/latest/scale-to-width-down/1200?cb=20230128125612',
         'Studio: 11 bit studios, Publisher: 11 bit studios, Release Date: 2025-07-25, Country: Poland, Languages: English, Polish'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox'),
        (@gameId, 'Switch');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_frostpunk001', @Password = 'Frostpunk@001', @Email = 'frostpunk001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Frostpunk 2 tập trung vào city-building và survival hay!', @Rating = 9.1, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Thế giới dystopian lạnh giá!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Echoes of Eternity
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Echoes of Eternity',
         'A narrative-driven adventure exploring time travel and ancient mysteries in a richly detailed world.',
         'Adventure, Narrative, Puzzle',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/zsfr5oevm1umycmuudcp.webp',
         'https://d19y2ttatozxjp.cloudfront.net/wp-content/uploads/2020/01/15224421/EchoesofEternity_LargeHero-1024x584.png',
         'Studio: Eternal Studios, Publisher: Independent, Release Date: 2025-10-10, Country: Canada, Languages: English, Spanish'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_echoes001', @Password = 'Echoes@001', @Email = 'echoes001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Echoes of Eternity khám phá time travel hay!', @Rating = 8.3, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Cổ đại mysteries hấp dẫn!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Shadow Realm
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Shadow Realm',
         'A dark fantasy RPG with a focus on stealth and intricate lore set in a cursed kingdom.',
         'RPG, Stealth, Dark Fantasy',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/e6lkj8r168e9pr5pc0vf.webp',
         'https://oyster.ignimgs.com/mediawiki/apis.ign.com/shadow-realms/9/93/Realms2.jpg?width=640',
         'Studio: Shadow Craft, Publisher: Bandai Namco Entertainment, Release Date: 2025-11-05, Country: Japan, Languages: English, Japanese'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_shadow001', @Password = 'Shadow@001', @Email = 'shadow001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Shadow Realm tập trung vào stealth và lore hay!', @Rating = 8.7, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Cursed kingdom hấp dẫn!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Neon Blitz
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Neon Blitz',
         'A fast-paced multiplayer shooter set in a cyberpunk city with vibrant neon aesthetics.',
         'Shooter, Multiplayer, Cyberpunk',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co8m6k.webp',
         'https://img.freepik.com/free-vector/abstract-glowing-led-lines-modern-wallpaper-design_1017-55438.jpg?semt=ais_hybrid&w=740&q=80',
         'Studio: Neon Games, Publisher: Electronic Arts, Release Date: 2025-12-01, Country: USA, Languages: English, German'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_neon001', @Password = 'Neon@001', @Email = 'neon001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Neon Blitz nhanh-paced và neon aesthetics đẹp!', @Rating = 8.4, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Cyberpunk city tuyệt vời!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Crystal Kingdom
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Crystal Kingdom',
         'A family-friendly platformer featuring magical crystals and cooperative multiplayer modes.',
         'Platformer, Family, Multiplayer',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/ksl8fbzknwchlaqpoxk8.webp',
         'https://png.pngtree.com/thumb_back/fh260/background/20241007/pngtree-the-portrayal-of-a-crystal-kingdom-background-wallpaper-gorgeous-with-shimmering-image_16292289.jpg',
         'Studio: Crystal Studios, Publisher: Nintendo, Release Date: 2025-09-20, Country: Japan, Languages: English, Japanese'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'Switch'),
        (@gameId, 'Switch 2');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_crystal001', @Password = 'Crystal@001', @Email = 'crystal001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Crystal Kingdom thân thiện với gia đình và multiplayer hay!', @Rating = 8.0, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Magical crystals vui nhộn!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Voidwalker
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Voidwalker',
         'A survival horror game set in deep space, where players must escape a derelict spaceship.',
         'Survival Horror, Sci-Fi, Adventure',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co7f84.webp',
         'https://fc07.deviantart.net/fs70/f/2014/280/e/4/destiny___voidwalker_by_morningwar-d81xcek.png',
         'Studio: Void Games, Publisher: Independent, Release Date: 2025-10-25, Country: USA, Languages: English'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_voidwalker001', @Password = 'Voidwalker@001', @Email = 'voidwalker001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Voidwalker mang đến survival horror trong không gian hay!', @Rating = 8.5, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Deep space đáng sợ!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Rune Masters
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Rune Masters',
         'A tactical RPG with turn-based combat and a rich mythology inspired by Norse legends.',
         'RPG, Tactical, Fantasy',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co2ibb.webp',
         'https://images.alphacoders.com/532/532506.png',
         'Studio: Rune Studios, Publisher: Square Enix, Release Date: 2025-11-15, Country: Sweden, Languages: English, Swedish'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_rune001', @Password = 'Rune@001', @Email = 'rune001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Rune Masters có combat turn-based và mythology Norse hay!', @Rating = 8.6, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Norse legends hấp dẫn!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Drift Legends
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Drift Legends',
         'A realistic driving simulator focused on drift racing with customizable cars and tracks.',
         'Simulation, Racing, Sports',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co57f0.webp',
         'https://play-lh.googleusercontent.com/dXpBGlzU0i2Xhtx2S0JwVm5izCvpxcKehX4PvsoYaJJdfMsyQyYwi9CaYv3UYFhgrw=w526-h296-rw',
         'Studio: Drift Dynamics, Publisher: Indie Publisher, Release Date: 2025-12-10, Country: Germany, Languages: English, German'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_drift001', @Password = 'Drift@001', @Email = 'drift001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Drift Legends có physics drift thực tế!', @Rating = 8.2, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Customizable cars hay!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Skyforge Chronicles
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Skyforge Chronicles',
         'An open-world action game where players build and defend floating islands in the sky.',
         'Action, Open World, Fantasy',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co3wf8.webp',
         'https://o.aolcdn.com/hss/storage/midas/df5962578926a9f87f8d4e667844092c/201187297/sf_celestial_fortress_art_001.jpg',
         'Studio: Skyforge Studios, Publisher: Ubisoft, Release Date: 2025-09-30, Country: France, Languages: English, French'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_skyforge001', @Password = 'Skyforge@001', @Email = 'skyforge001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Skyforge Chronicles cho phép build floating islands hay!', @Rating = 8.8, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Defend islands in the sky thú vị!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Inferno Rising
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Inferno Rising',
         'A challenging platformer set in a volcanic world with intense heat-based puzzles.',
         'Platformer, Puzzle, Adventure',
         0.00,
         'https://dyn.media.forbiddenplanet.com/i78_QTOhlhznAiYjWJS11nGK9tk=/fit-in/1500x1500/https://media.forbiddenplanet.com/products/59/71/2e0758c5c1d8c3d515c9e8909801b8e0db0b.jpg',
         'https://png.pngtree.com/thumb_back/fh260/background/20250401/pngtree-chaotic-inferno-scene-blazing-flames-rising-from-rocky-ground-with-glowing-image_17163939.jpg',
         'Studio: Inferno Games, Publisher: Independent, Release Date: 2025-10-15, Country: Italy, Languages: English, Italian'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_inferno001', @Password = 'Inferno@001', @Email = 'inferno001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Inferno Rising có platformer thử thách và puzzle heat-based!', @Rating = 8.0, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Volcanic world đáng sợ!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Galactic Wars
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Galactic Wars',
         'A strategy game where players command fleets in epic space battles across the galaxy.',
         'Strategy, Sci-Fi, Multiplayer',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/mdzv2492wi4srs2jxntt.webp',
         'https://media.istockphoto.com/id/1195199589/photo/dark-blue-spaceship-futuristic-interior-with-window-view-on-planet-earth-3d-rendering.jpg?s=612x612&w=0&k=20&c=H0_qt9Ry98ksk32RKqUBXlyWbnXtGlAt9ulqzq_UWl8=',
         'Studio: Galactic Studios, Publisher: Sega, Release Date: 2025-11-20, Country: Japan, Languages: English, Japanese'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_galactic001', @Password = 'Galactic@001', @Email = 'galactic001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Galactic Wars cho phép command fleets hay!', @Rating = 8.9, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Epic space battles hấp dẫn!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Mystic Forest
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Mystic Forest',
         'A serene exploration game with magical creatures and environmental puzzles.',
         'Exploration, Puzzle, Fantasy',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co5sui.webp',
         'https://wallpapers.com/images/hd/mystical-forest-1920-x-1080-qf4vghj9i70zl6yq.jpg',
         'Studio: Mystic Games, Publisher: Indie Publisher, Release Date: 2025-12-05, Country: Australia, Languages: English'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_mystic001', @Password = 'Mystic@001', @Email = 'mystic001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Mystic Forest có exploration bình yên và puzzle môi trường!', @Rating = 8.2, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Magical creatures dễ thương!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Harmony Quest
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Harmony Quest',
         'A rhythm-based adventure game with musical challenges and vibrant visuals.',
         'Rhythm, Adventure, Family',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co7oph.webp',
         'https://cdn.soft112.com/my-little-pony-harmony-quest-ios/00/00/0G/5S/00000G5S7T/pad_screenshot_3A6F3X6V5E.png',
         'Studio: Harmony Studios, Publisher: Nintendo, Release Date: 2025-10-30, Country: Japan, Languages: English, Japanese'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'Switch'),
        (@gameId, 'Switch 2');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_harmony001', @Password = 'Harmony@001', @Email = 'harmony001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Harmony Quest có musical challenges vui nhộn!', @Rating = 8.0, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Vibrant visuals đẹp!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Dark Horizon
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Dark Horizon',
         'A stealth-action game set in a noir-inspired city with deep character customization.',
         'Stealth, Action, Noir',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9nhj.webp',
         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQcdDogepxuzQXh8gwTygYuaKWgLnI9QTOU8d4SVgy7y5Nk4tukgQ4SkP7M5OW7GMZHjlg&usqp=CAU',
         'Studio: Dark Games, Publisher: Warner Bros. Interactive, Release Date: 2025-11-10, Country: USA, Languages: English, French'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_dark001', @Password = 'Dark@001', @Email = 'dark001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Dark Horizon có stealth-action và customization sâu!', @Rating = 8.5, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Noir-inspired city hay!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Echoes of War
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Echoes of War',
         'A historical strategy game recreating epic battles from various eras.',
         'Strategy, Historical, Tactical',
         0.00,
         'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1704462892i/202012592.jpg',
         'https://w0.peakpx.com/wallpaper/280/850/HD-wallpaper-the-dark-horizon-clouds-moon-horizon-sky-night-mountains.jpg',
         'Studio: War Echoes, Publisher: Paradox Interactive, Release Date: 2025-10-20, Country: Sweden, Languages: English, Swedish'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_echoeswar001', @Password = 'EchoesWar@001', @Email = 'echoeswar001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Echoes of War tái tạo epic battles hay!', @Rating = 8.4, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Historical strategy tuyệt vời!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Crystal Caverns
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Crystal Caverns',
         'A puzzle adventure game set in underground caves filled with crystalline puzzles.',
         'Puzzle, Adventure, Fantasy',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9naa.webp',
         'https://i.pinimg.com/736x/9a/de/d5/9aded51ff2b9d681341b3b6b6585af82.jpg',
         'Studio: Cavern Games, Publisher: Indie Publisher, Release Date: 2025-11-25, Country: Spain, Languages: English, Spanish'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_crystalcaverns001', @Password = 'CrystalCaverns@001', @Email = 'crystalcaverns001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Crystal Caverns có puzzle crystalline hay!', @Rating = 8.1, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Underground caves đẹp!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Solar Strike
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Solar Strike',
         'A space combat simulator with intense dogfights and planetary exploration.',
         'Simulation, Shooter, Sci-Fi',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co9i99.webp',
         'https://cdn.mos.cms.futurecdn.net/ecAJ5nfpHLWxUC2Xd7RGbW-1200-80.jpg',
         'Studio: Solar Games, Publisher: Ubisoft, Release Date: 2025-12-20, Country: France, Languages: English, French'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_solar001', @Password = 'Solar@001', @Email = 'solar001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Solar Strike có dogfights căng thẳng và exploration hành tinh!', @Rating = 8.5, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Space combat simulator tuyệt!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Twilight Realm
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Twilight Realm',
         'A dark fantasy RPG with a focus on magic and cooperative multiplayer campaigns.',
         'RPG, Fantasy, Multiplayer',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co5ubz.webp',
         'https://www.architectureofzelda.com/uploads/3/7/1/2/37126503/published/wvw69kiqsacqwhbwmh.jpg?1490155642',
         'Studio: Twilight Studios, Publisher: Bandai Namco Entertainment, Release Date: 2025-09-05, Country: Japan, Languages: English, Japanese'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_twilight001', @Password = 'Twilight@001', @Email = 'twilight001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Twilight Realm tập trung vào magic và multiplayer coop hay!', @Rating = 8.6, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Dark fantasy RPG đỉnh cao!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Drift Kings
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Drift Kings',
         'A competitive drifting game with realistic physics and global leaderboards.',
         'Racing, Sports, Simulation',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co3oz2.webp',
         'https://shared.fastly.steamstatic.com/store_item_assets/steam/apps/1469690/capsule_616x353.jpg?t=1750717020',
         'Studio: Drift Kings Games, Publisher: Indie Publisher, Release Date: 2025-10-15, Country: Germany, Languages: English, German'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_driftkings001', @Password = 'DriftKings@001', @Email = 'driftkings001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Drift Kings có physics thực tế và leaderboards toàn cầu!', @Rating = 8.3, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Competitive drifting hay!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Cyber Nexus
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Cyber Nexus',
         'A hacking simulator with real-time strategy elements in a digital world.',
         'Simulation, Strategy, Cyberpunk',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co6vue.webp',
         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9Kq16JMSEbJfTqlryXPHqHTYKeYwvrcCh9Q&s',
         'Studio: Nexus Games, Publisher: Independent, Release Date: 2025-09-25, Country: USA, Languages: English'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_cyber001', @Password = 'Cyber@001', @Email = 'cyber001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Cyber Nexus có hacking simulator và strategy real-time!', @Rating = 8.4, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Digital world hấp dẫn!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Rogue Waves
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Rogue Waves',
         'A naval combat game with strategic depth and historical naval battles.',
         'Strategy, Simulation, Historical',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co2nve.webp',
         'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGPsY5FeaYT6vGN1MrQHhtCVlvgrmnhnVWBvIh_RBTyhANu1OT-L9Pt54JmV1DtbcyAAM&usqp=CAU',
         'Studio: Wave Games, Publisher: Sega, Release Date: 2025-11-15, Country: Japan, Languages: English, Japanese'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_rogue001', @Password = 'Rogue@001', @Email = 'rogue001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Rogue Waves có naval combat chiến lược!', @Rating = 8.5, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Historical naval battles hay!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Hollow Knight
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Hollow Knight',
         'A challenging 2D action-adventure game set in the haunting kingdom of Hallownest, filled with intricate exploration and intense combat.',
         'Action-Adventure, Metroidvania, Platformer',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co93cr.webp',
         'https://static1.thegamerimages.com/wordpress/wp-content/uploads/2025/06/mixcollage-11-jun-2025-02-21-pm-2407.jpg',
         'Studio: Team Cherry, Publisher: Team Cherry, Release Date: 2017-02-24, Country: Australia, Languages: English'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_hollow001', @Password = 'Hollow@001', @Email = 'hollow001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Hollow Knight có exploration và combat thử thách!', @Rating = 9.5, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Hallownest haunting và intricate!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for God of War Ragnarok
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'God of War Ragnarok',
         'A cinematic action game following Kratos and Atreus as they confront Norse gods in a sprawling mythological adventure.',
         'Action, Hack and Slash, Adventure',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co5s5v.webp',
         'https://static1.cbrimages.com/wordpress/wp-content/uploads/2022/05/God-of-War-Ragnar%C3%B6k-boat-art.jpg',
         'Studio: Santa Monica Studio, Publisher: Sony Interactive Entertainment, Release Date: 2022-11-09, Country: USA, Languages: English, Spanish, French'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_godofwar001', @Password = 'GodOfWar@001', @Email = 'godofwar001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'God of War Ragnarok có mythological adventure hay!', @Rating = 9.4, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Kratos and Atreus trở lại!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 2, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Minecraft
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Minecraft',
         'A sandbox game that allows players to explore, build, and survive in a blocky, procedurally generated world.',
         'Sandbox, Survival, Adventure',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co8fu7.webp',
         'https://www.exitlag.com/blog/wp-content/uploads/2024/12/cute-minecraft-house-2.webp',
         'Studio: Mojang Studios, Publisher: Xbox Game Studios, Release Date: 2011-11-18, Country: Sweden, Languages: English, German, Spanish'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_minecraft001', @Password = 'Minecraft@001', @Email = 'minecraft001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Minecraft cho phép explore và build tự do!', @Rating = 9.2, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Blocky world sáng tạo!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Red Dead Redemption 2
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Red Dead Redemption 2',
         'An open-world action-adventure game set in the American Wild West, following the story of Arthur Morgan and the Van der Linde gang.',
         'Action-Adventure, Open World, Western',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co1q1f.webp',
         'https://media.wired.com/photos/5bdca1cf35226a3b7363f84c/191:100/w_1280,c_limit/Red-Dead-Redemption.jpg',
         'Studio: Rockstar Games, Publisher: Rockstar Games, Release Date: 2018-10-26, Country: USA, Languages: English, French, German'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_reddead001', @Password = 'RedDead@001', @Email = 'reddead001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Red Dead Redemption 2 có open-world Wild West hay!', @Rating = 9.8, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Arthur Morgan và Van der Linde gang cốt truyện đỉnh!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Silent Hill 2
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Silent Hill 2',
         'A psychological horror game that revisits the foggy town of Silent Hill, delving into themes of grief and redemption.',
         'Horror, Survival, Psychological',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co5l7s.webp',
         'https://cdn.mos.cms.futurecdn.net/3LUxtsRydTT6zTCwR57DzT-1200-80.jpg',
         'Studio: Bloober Team, Publisher: Konami, Release Date: 2024-10-08, Country: Poland, Languages: English, Japanese'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_silenthill001', @Password = 'SilentHill@001', @Email = 'silenthill001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Silent Hill 2 mang đến psychological horror sâu sắc!', @Rating = 9.0, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Themes of grief and redemption hay!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 1, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH

-- Insert data into Games table for Cuphead
BEGIN TRY
    BEGIN TRANSACTION
        SET @gameId = NEWID();
        INSERT INTO Games (gameId, title, descriptions, genre, avgRating, poster, backdrop, details) VALUES
        (@gameId,
         'Cuphead',
         'A run-and-gun indie game featuring hand-drawn art and challenging boss battles inspired by 1930s cartoons.',
         'Action, Platformer, Run and Gun',
         0.00,
         'https://images.igdb.com/igdb/image/upload/t_cover_big/co65ip.webp',
         'https://cdnb.artstation.com/p/assets/images/images/012/688/907/large/wender-silva-sem-titulo-42.jpg?1536031380',
         'Studio: Studio MDHR, Publisher: Studio MDHR, Release Date: 2017-09-29, Country: Canada, Languages: English'
        );

        INSERT INTO Game_Service (gameId, serviceName) VALUES
        (@gameId, 'PC'),
        (@gameId, 'PlayStation'),
        (@gameId, 'Xbox');

        SET @result = 1;
        SET @Temp = 1;

        -- Thêm người dùng mới
        EXEC DBO.UP_CreateUser @Username = 'user_cuphead001', @Password = 'Cuphead@001', @Email = 'cuphead001@gmail.com', @NewUserId = @userId OUTPUT;

        -- Thêm review bởi người dùng
        EXEC DBO.RP_CreateReview @Content = N'Cuphead có hand-drawn art và boss battles thử thách!', @Rating = 9.0, @ReviewId = @reviewId OUTPUT;

        -- Thêm liên kết review với game được review
        EXEC DBO.GRP_AddGameReview @GameId = @gameId, @ReviewId = @reviewId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết review với người dùng
        EXEC DBO.RUP_CreateReviewUser @ReviewId = @reviewId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Tạo comment
        EXEC DBO.CP_CreateComment @Content = N'Inspired by 1930s cartoons hay!', @CommentId = @commentId OUTPUT;

        -- Thêm Liên kết comment với review
        EXEC DBO.CRP_AddCommentReview @ReviewId = @reviewId, @CommentId = @commentId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Thêm liên kết comment với user
        EXEC DBO.CUP_AddCommentUser @CommentId = @commentId, @Author = @userId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Reaction cho comment
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với comment
        EXEC DBO.CRP_AddCommentReaction @CommentId = @commentId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Reaction cho review
        EXEC DBO.RP_CreateReaction @ReactionType = 3, @ReactionId = @reactionId OUTPUT;

        -- Liên kết reaction với review
        EXEC DBO.RRP_CreateReviewReaction @ReviewId = @reviewId, @ReactionId = @reactionId, @Result = @result OUTPUT;
        SET @Temp *= @result;

        -- Liên kết reaction với user
        EXEC DBO.RUP_AddReactionUser @ReactionId = @reactionId, @Author = @userId, @Result = @result OUTPUT
        SET @Temp *= @result;

        -- Thêm thất bại thì huỷ mọi thao tác
        IF @Temp = 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
        ELSE IF @@TRANCOUNT > 0
        BEGIN
            COMMIT TRANSACTION;
        END
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION

    SELECT 
        ERROR_NUMBER() AS ErrorNumber,
        ERROR_MESSAGE() AS ErrorMessage;
END CATCH