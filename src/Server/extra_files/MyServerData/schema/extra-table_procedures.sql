-- # Procedures for Game_Service table
-- 1. Procedure to add a game to a service
CREATE OR ALTER PROCEDURE GSP_AddGameToService
@GameId UNIQUEIDENTIFIER,
@ServiceName NVARCHAR(30)
AS
BEGIN
    IF DBO.GSF_IsGameServiceUsable(@GameId, @ServiceName) = 0
    BEGIN
        RAISERROR ('Failed to add game to service.', 16, 1);
        SELECT 0 AS GameServiceAdded;
        RETURN;
    END;

    INSERT INTO [Game_Service] (gameId, serviceName)
    VALUES (@GameId, @ServiceName);

    IF DBO.GSF_GameServiceExists(@GameId, @ServiceName) = 0
    BEGIN
        RAISERROR ('Failed to add game to service.', 16, 1);
        SELECT 0 AS GameServiceAdded;
        RETURN;
    END;
END;
GO

-- 2. Procedure to remove a game from a service
CREATE OR ALTER PROCEDURE GSP_RemoveGameFromService
@GameId UNIQUEIDENTIFIER,
@ServiceName NVARCHAR(30)
AS
BEGIN
    IF DBO.GSF_GameServiceExists(@GameId, @ServiceName) = 0
    BEGIN
        RAISERROR ('Failed to remove game from service.', 16, 1);
        SELECT 0 AS GameServiceRemoved;
        RETURN;
    END;

    DELETE FROM [Game_Service] WHERE gameId = @GameId AND serviceName = @ServiceName;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS GameServiceRemoved;
END;
GO

-- 3. Procedure to get all services for a game
CREATE OR ALTER PROCEDURE GSP_GetGameServices
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        RETURN;
    END;

    SELECT * FROM [Game_Service] WHERE gameId = @GameId;
END;
GO

-- 4. Procedure to get all games for a service
CREATE OR ALTER PROCEDURE GSP_GetServiceGames
@ServiceName NVARCHAR(30)
AS
BEGIN
    IF DBO.GSF_IsServiceNameLegal(@ServiceName) = 0
    BEGIN 
        RETURN;
    END;

    SELECT * FROM [Game_Service] WHERE serviceName = @ServiceName;
END;
GO

-- # User_diary
CREATE OR ALTER PROCEDURE UDP_AddUserDiary
@UserId UNIQUEIDENTIFIER,
@DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0 OR 
       DBO.DF_DiaryIdExists(@DiaryId) = 0 OR 
       DBO.UDF_UserDiaryExists(@UserId, @DiaryId) = 1
    BEGIN
        RAISERROR ('Failed to add user diary.', 16, 1);
        SELECT 0 AS UserDiaryAdded;
        RETURN;
    END

    INSERT INTO User_Diary (userId, diaryId)
    VALUES (@UserId, @DiaryId);

    IF DBO.UDF_UserDiaryExists(@UserId, @DiaryId) = 0
    BEGIN
        RAISERROR ('Failed to add user diary.', 16, 1);
        SELECT 0 AS UserDiaryAdded;
        RETURN;
    END;

    SELECT 1 AS UserDiaryAdded;
END;
GO

CREATE OR ALTER PROCEDURE UDP_DeleteUserDiary
@UserId UNIQUEIDENTIFIER,
@DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UDF_UserDiaryExists(@UserId, @DiaryId) = 0
    BEGIN
        RAISERROR ('Failed to delete user diary.', 16, 1);
        SELECT 0 AS UserDiaryDeleted;
        RETURN;
    END

    DELETE FROM User_Diary WHERE userId = @UserId AND diaryId = @DiaryId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS UserDiaryDeleted;
END;
GO

CREATE OR ALTER PROCEDURE UDP_GetAllUserDiary
AS
BEGIN
    SELECT * FROM User_Diary;
END;
GO

CREATE OR ALTER PROCEDURE UDP_GetDiariesOfUser
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SELECT NULL AS DiaryId;
        RETURN;
    END

    SELECT diaryId FROM User_Diary WHERE userId = @UserId;
END;
GO

CREATE OR ALTER PROCEDURE UDP_GetUsersOfDiary
@DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        SELECT NULL AS UserId;
        RETURN;
    END

    SELECT userId FROM User_Diary WHERE diaryId = @DiaryId;
END;
GO

-- # User_List
CREATE OR ALTER PROCEDURE ULP_AddUserList
@UserId UNIQUEIDENTIFIER,
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0 OR 
       DBO.LF_ListIdExists(@ListId) = 0 OR 
       DBO.ULF_UserListExists(@UserId, @ListId) = 1
    BEGIN
        RAISERROR ('Failed to add user list.', 16, 1);
        SELECT 0 AS UserListAdded;
        RETURN;
    END;

    INSERT INTO User_List (userId, listId)
    VALUES (@UserId, @ListId);

    IF DBO.ULF_UserListExists(@UserId, @ListId) = 0
    BEGIN
        RAISERROR ('Failed to add user list.', 16, 1);
        SELECT 0 AS UserListAdded;
        RETURN;
    END;

    SELECT 1 AS UserListAdded;
END;
GO

CREATE OR ALTER PROCEDURE ULP_DeleteUserList
@UserId UNIQUEIDENTIFIER,
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.ULF_UserListExists(@UserId, @ListId) = 0
    BEGIN
        RAISERROR ('Failed to delete user list.', 16, 1);
        SELECT 0 AS UserListDeleted;
        RETURN;
    END;

    DELETE FROM User_List WHERE userId = @UserId AND listId = @ListId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS UserListDeleted;
END;
GO

CREATE OR ALTER PROCEDURE ULP_GetAllUserList
AS
BEGIN
    SELECT * FROM User_List;
END;
GO

CREATE OR ALTER PROCEDURE ULP_GetListsOfUser
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SELECT NULL AS ListId;
        RETURN;
    END;

    SELECT listId FROM User_List WHERE userId = @UserId;
END;
GO

CREATE OR ALTER PROCEDURE ULP_GetUsersOfList
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        SELECT NULL AS UserId;
        RETURN;
    END;

    SELECT userId FROM User_List WHERE listId = @ListId;
END;
GO
-- # User_User
-- 1. Thủ tục thêm quan hệ follow
CREATE OR ALTER PROCEDURE UUP_AddUserFollow
    @UserFollower UNIQUEIDENTIFIER,
    @UserFollowing UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserFollower) = 0 OR 
       DBO.UF_UserIdExists(@UserFollowing) = 0 OR
       DBO.UUF_UserUserExists(@UserFollower, @UserFollowing) = 1 OR
       @UserFollower = @UserFollowing
    BEGIN
        RAISERROR ('Failed to add follow relationship.', 16, 1);
        SELECT 0 AS UserFollowAdded;
        RETURN;
    END;

    INSERT INTO User_User (userFollower, userFollowing)
    VALUES (@UserFollower, @UserFollowing);

    IF DBO.UUF_UserUserExists(@UserFollower, @UserFollowing) = 0
    BEGIN
        RAISERROR ('Failed to add follow relationship.', 16, 1);
        SELECT 0 AS UserFollowAdded;
    END;

END;
GO

-- 2. Thủ tục xóa quan hệ follow
CREATE OR ALTER PROCEDURE UUP_RemoveUserFollow
    @UserFollower UNIQUEIDENTIFIER,
    @UserFollowing UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UUF_UserUserExists(@UserFollower, @UserFollowing) = 0
    BEGIN
        RAISERROR ('Failed to remove follow relationship.', 16, 1);
        SELECT 0 AS UserFollowRemoved;
        RETURN;
    END;

    DELETE FROM User_User
    WHERE userFollower = @UserFollower AND userFollowing = @UserFollowing;

    IF DBO.UUF_UserUserExists(@UserFollower, @UserFollowing) = 1
    BEGIN
        RAISERROR ('Failed to remove follow relationship.', 16, 1);
        SELECT 0 AS UserFollowRemoved;
    END;
END;
GO

-- 3. Thủ tục lấy tất cả user người dùng đang follow
CREATE OR ALTER PROCEDURE UUP_GetFollowingUsers
    @UserFollower UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserFollower) = 0
    BEGIN
        SELECT NULL AS userFollowing;
        RETURN;
    END;

    SELECT userFollowing
    FROM User_User
    WHERE userFollower = @UserFollower;
END;
GO

-- 4. Thủ tục lấy tất cả người đang follow user
CREATE OR ALTER PROCEDURE UUP_GetFollowerUsers
    @UserFollowing UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserFollowing) = 0
    BEGIN
        SELECT NULL AS userFollower;
        RETURN;
    END;

    SELECT userFollower
    FROM User_User
    WHERE userFollowing = @UserFollowing;
END;
GO

-- # User_Activity
CREATE OR ALTER PROCEDURE UAP_CreateUserActivity
@UserId UNIQUEIDENTIFIER,
@ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0 OR 
       DBO.AF_ActivityIdExists(@ActivityId) = 0 OR
       DBO.UAF_UserActivityExists(@UserId, @ActivityId) = 1
    BEGIN
        RAISERROR ('Failed to create user activity.', 16, 1);
        SELECT 0 AS UserActivityCreated;
        RETURN;
    END;

    INSERT INTO User_Activity (userId, activityId)
    VALUES (@UserId, @ActivityId);

    IF DBO.UAF_UserActivityExists(@UserId, @ActivityId) = 0
    BEGIN
        RAISERROR ('Failed to create user activity.', 16, 1);
        SELECT 0 AS UserActivityCreated;
        RETURN;
    END;

END;
GO

CREATE OR ALTER PROCEDURE UAP_DeleteUserActivity
@UserId UNIQUEIDENTIFIER,
@ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UAF_UserActivityExists(@UserId, @ActivityId) = 0
    BEGIN
        RAISERROR ('Failed to delete user activity.', 16, 1);
        SELECT 0 AS UserActivityDeleted;
        RETURN;
    END;

    DELETE FROM User_Activity
    WHERE userId = @UserId AND activityId = @ActivityId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS UserActivityDeleted;
END;
GO

CREATE OR ALTER PROCEDURE UAP_GetAllUserActivity
AS
BEGIN
    SELECT * FROM User_Activity;
END;
GO

CREATE OR ALTER PROCEDURE UAP_GetActivitiesByUser
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SELECT NULL AS ActivityId;
        RETURN;
    END;

    SELECT activityId FROM User_Activity
    WHERE userId = @UserId;
END;
GO

CREATE OR ALTER PROCEDURE UAP_GetUsersByActivity
@ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
    BEGIN
        SELECT NULL AS UserId;
        RETURN;
    END;

    SELECT userId FROM User_Activity
    WHERE activityId = @ActivityId;
END;
GO

-- # Review_User
CREATE OR ALTER PROCEDURE RUP_CreateReviewUser
@Author UNIQUEIDENTIFIER,
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@Author) = 0 OR 
       DBO.RF_ReviewIdExists(@ReviewId) = 0 OR 
       DBO.RUF_ReviewUserExists(@Author, @ReviewId) = 1
    BEGIN
        RAISERROR ('Failed to create review user.', 16, 1);
        SELECT 0 AS ReviewUserCreated;
        RETURN;
    END;

    INSERT INTO Review_User (author, reviewId)
    VALUES (@Author, @ReviewId);

    IF DBO.RUF_ReviewUserExists(@Author, @ReviewId) = 0
    BEGIN
        RAISERROR ('Failed to create review user.', 16, 1);
        SELECT 0 AS ReviewUserCreated;
        RETURN;
    END;

    SELECT 1 AS ReviewUserCreated;
END;
GO

CREATE OR ALTER PROCEDURE RUP_DeleteReviewUser
@Author UNIQUEIDENTIFIER,
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RUF_ReviewUserExists(@Author, @ReviewId) = 0
    BEGIN
        RAISERROR ('Failed to delete review user.', 16, 1);
        SELECT 0 AS ReviewUserDeleted;
        RETURN;
    END;

    DELETE FROM Review_User
    WHERE author = @Author AND reviewId = @ReviewId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ReviewUserDeleted;
END;
GO


-- 3. Procedure: Get all Review_User links
CREATE OR ALTER PROCEDURE RUP_GetAllReviewUsers
AS
BEGIN
    SELECT * FROM Review_User;
END;
GO

-- 4. Procedure: Get all reviewIds by author
CREATE OR ALTER PROCEDURE RUP_GetReviewIdsByAuthor
@Author UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@Author) = 0
    BEGIN
        SELECT NULL AS ReviewId;
        RETURN;
    END;

    SELECT reviewId
    FROM Review_User
    WHERE author = @Author;
END;
GO


-- 5. Procedure: Get all authors by reviewId
CREATE OR ALTER PROCEDURE RUP_GetAuthorsByReviewId
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SELECT NULL AS Author;
        RETURN;
    END;

    SELECT author
    FROM Review_User
    WHERE reviewId = @ReviewId;
END;
GO

-- # Review_Rate
CREATE OR ALTER PROCEDURE RRP_AddReviewRate
@RateId UNIQUEIDENTIFIER,
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_RateIdExists(@RateId) = 0 OR 
       DBO.RF_ReviewIdExists(@ReviewId) = 0 OR 
       DBO.RRF_ReviewRateExists(@RateId, @ReviewId) = 1
    BEGIN
        RAISERROR ('Failed to add review rate.', 16, 1);
        SELECT 0 AS ReviewRateAdded;
        RETURN;
    END;

    INSERT INTO Review_Rate (rateId, reviewId)
    VALUES (@RateId, @ReviewId);

    IF DBO.RRF_ReviewRateExists(@RateId, @ReviewId) = 0
    BEGIN
        RAISERROR ('Failed to add review rate.', 16, 1);
        SELECT 0 AS ReviewRateAdded;
        RETURN;
    END;

    SELECT 1 AS ReviewRateAdded;
END;
GO

CREATE OR ALTER PROCEDURE RRP_DeleteReviewRate
@RateId UNIQUEIDENTIFIER,
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RRF_ReviewRateExists(@RateId, @ReviewId) = 0
    BEGIN
        RAISERROR ('Failed to delete review rate.', 16, 1);
        SELECT 0 AS ReviewRateDeleted;
        RETURN;
    END;

    DELETE FROM Review_Rate WHERE rateId = @RateId AND reviewId = @ReviewId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ReviewRateDeleted;
END;
GO

CREATE OR ALTER PROCEDURE RRP_GetAllReviewRate
AS
BEGIN
    SELECT * FROM Review_Rate;
END;
GO

CREATE OR ALTER PROCEDURE RRP_GetReviewsOfRate
@RateId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_RateIdExists(@RateId) = 0
    BEGIN
        SELECT NULL AS ReviewId;
        RETURN;
    END;

    SELECT reviewId FROM Review_Rate WHERE rateId = @RateId;
END;
GO

CREATE OR ALTER PROCEDURE RRP_GetRatesOfReview
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SELECT NULL AS RateId;
        RETURN;
    END;

    SELECT rateId FROM Review_Rate WHERE reviewId = @ReviewId;
END;
GO

-- #R Review_Reaction
CREATE OR ALTER PROCEDURE RRP_CreateReviewReaction
@ReactionId UNIQUEIDENTIFIER,
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0 OR 
       DBO.RF_ReviewIdExists(@ReviewId) = 0 OR 
       DBO.RRF_ReviewReactionExists(@ReactionId, @ReviewId) = 1
    BEGIN
        RAISERROR ('Failed to create review reaction.', 16, 1);
        SELECT 0 AS ReviewReactionCreated;
        RETURN;
    END;

    INSERT INTO Review_Reaction (reactionId, reviewId)
    VALUES (@ReactionId, @ReviewId);

    IF DBO.RRF_ReviewReactionExists(@ReactionId, @ReviewId) = 0
    BEGIN
        RAISERROR ('Failed to create review reaction.', 16, 1);
        SELECT 0 AS ReviewReactionCreated;
        RETURN;
    END;

    SELECT 1 AS ReviewReactionCreated;
END;
GO

CREATE OR ALTER PROCEDURE RRP_DeleteReviewReaction
@ReactionId UNIQUEIDENTIFIER,
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RRF_ReviewReactionExists(@ReactionId, @ReviewId) = 0
    BEGIN
        RAISERROR ('Failed to delete review reaction.', 16, 1);
        SELECT 0 AS ReviewReactionDeleted;
        RETURN;
    END;

    DELETE FROM Review_Reaction
    WHERE reactionId = @ReactionId AND reviewId = @ReviewId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ReviewReactionDeleted;
END;
GO

CREATE OR ALTER PROCEDURE RRP_GetAllReviewReactions
AS
BEGIN
    SELECT * FROM Review_Reaction;
END;
GO

CREATE OR ALTER PROCEDURE RRP_GetReactionsByReview
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SELECT NULL AS ReactionId;
        RETURN;
    END;

    SELECT reactionId FROM Review_Reaction
    WHERE reviewId = @ReviewId;
END;
GO

CREATE OR ALTER PROCEDURE RRP_GetReviewsByReaction
@ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SELECT NULL AS ReviewId;
        RETURN;
    END;

    SELECT reviewId FROM Review_Reaction
    WHERE reactionId = @ReactionId;
END;
GO

-- # Game_Review
CREATE OR ALTER PROCEDURE GRP_AddGameReview
@GameId UNIQUEIDENTIFIER,
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0 OR 
       DBO.LF_ReviewIdExists(@ReviewId) = 0 OR 
       DBO.GRF_GameReviewExists(@GameId, @ReviewId) = 1
    BEGIN
        RAISERROR ('Failed to add game review.', 16, 1);
        SELECT 0 AS GameReviewAdded;
        RETURN;
    END;

    INSERT INTO Game_Review (gameId, reviewId)
    VALUES (@GameId, @ReviewId);

    IF DBO.GRF_GameReviewExists(@GameId, @ReviewId) = 0
    BEGIN
        RAISERROR ('Failed to add game review.', 16, 1);
        SELECT 0 AS GameReviewAdded;
        RETURN;
    END;

    SELECT 1 AS GameReviewAdded;
END;
GO

CREATE OR ALTER PROCEDURE GRP_DeleteGameReview
@GameId UNIQUEIDENTIFIER,
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.GRF_GameReviewExists(@GameId, @ReviewId) = 0
    BEGIN
        RAISERROR ('Failed to delete game review.', 16, 1);
        SELECT 0 AS GameReviewDeleted;
        RETURN;
    END;

    DELETE FROM Game_Review WHERE gameId = @GameId AND reviewId = @ReviewId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS GameReviewDeleted;
END;
GO

CREATE OR ALTER PROCEDURE GRP_GetAllGameReview
AS
BEGIN
    SELECT * FROM Game_Review;
END;
GO

CREATE OR ALTER PROCEDURE GRP_GetGameOfReview
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SELECT NULL AS ReviewId;
        RETURN;
    END;

    SELECT gameId FROM Game_Review WHERE reviewId = @ReviewId;
END;
GO

CREATE OR ALTER PROCEDURE GRP_GetReviewOfGame
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        SELECT NULL AS GameId;
        RETURN;
    END;

    SELECT reviewId FROM Game_Review WHERE gameId = @GameId;
END;
GO

-- # Reaction_User
CREATE OR ALTER PROCEDURE RUP_AddReactionUser
@ReactionId UNIQUEIDENTIFIER,
@Author UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@Author) = 0 OR 
       DBO.RF_ReactionIdExists(@ReactionId) = 0 OR 
       DBO.RUF_ReactionUserExists(@ReactionId, @Author) = 1
    BEGIN
        RAISERROR ('Failed to add reaction user.', 16, 1);
        SELECT 0 AS ReactionUserAdded;
        RETURN;
    END;

    INSERT INTO Reaction_User (reactionId, author)
    VALUES (@ReactionId, @Author);

    IF DBO.RUF_ReactionUserExists(@ReactionId, @Author) = 0
    BEGIN
        RAISERROR ('Failed to add reaction user.', 16, 1);
        SELECT 0 AS ReactionUserAdded;
        RETURN;
    END;

    SELECT 1 AS ReactionUserAdded;
END;
GO

CREATE OR ALTER PROCEDURE RUP_DeleteReactionUser
@ReactionId UNIQUEIDENTIFIER,
@Author UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RUF_ReactionUserExists(@ReactionId, @Author) = 0
    BEGIN
        RAISERROR ('Failed to delete reaction user.', 16, 1);
        SELECT 0 AS ReactionUserDeleted;
        RETURN;
    END;

    DELETE FROM Reaction_User WHERE reactionId = @ReactionId AND author = @Author;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ReactionUserDeleted;
END;
GO

CREATE OR ALTER PROCEDURE RUP_GetAllReactionUser
AS
BEGIN
    SELECT * FROM Reaction_User;
END;
GO

CREATE OR ALTER PROCEDURE RUP_GetReactionsOfUser
@Author UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@Author) = 0
    BEGIN
        SELECT NULL AS ReactionId;
        RETURN;
    END;

    SELECT reactionId FROM Reaction_User WHERE author = @Author;
END;
GO

CREATE OR ALTER PROCEDURE RUP_GetUsersOfReaction
@ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SELECT NULL AS Author;
        RETURN;
    END;

    SELECT author FROM Reaction_User WHERE reactionId = @ReactionId;
END;
GO

-- # Rate_User
CREATE OR ALTER PROCEDURE RUP_AddRateUser
@RateId UNIQUEIDENTIFIER,
@Rater UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@Rater) = 0 OR 
       DBO.RF_RateIdExists(@RateId) = 0 OR 
       DBO.RUF_RateUserExists(@RateId, @Rater) = 1
    BEGIN
        RAISERROR ('Failed to add RateUser', 16, 1);
        SELECT 0 AS RateUserAdded;
        RETURN;
    END;

    INSERT INTO Rate_User (rateId, rater)
    VALUES (@RateId, @Rater);

    IF DBO.RUF_RateUserExists(@RateId, @Rater) = 0
    BEGIN
        SELECT 0 AS RateUserAdded;
        RETURN;
    END;

    SELECT 1 AS RateUserAdded;
END;
GO

CREATE OR ALTER PROCEDURE RUP_DeleteRateUser
@RateId UNIQUEIDENTIFIER,
@Rater UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RUF_RateUserExists(@RateId, @Rater) = 0
    BEGIN
        RAISERROR ('Failed to delete RateUser', 16, 1);
        SELECT 0 AS RateUserDeleted;
        RETURN;
    END;

    DELETE FROM Rate_User WHERE rateId = @RateId AND rater = @Rater;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS RateUserDeleted;
END;
GO

CREATE OR ALTER PROCEDURE RUP_GetAllRateUser
AS
BEGIN
    SELECT * FROM Rate_User;
END;
GO

CREATE OR ALTER PROCEDURE RUP_GetRatesOfUser
@Rater UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@Rater) = 0
    BEGIN
        SELECT NULL AS RateId;
        RETURN;
    END;

    SELECT rateId FROM Rate_User WHERE rater = @Rater;
END;
GO

CREATE OR ALTER PROCEDURE RUP_GetUsersOfRate
@RateId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_RateIdExists(@RateId) = 0
    BEGIN
        SELECT NULL AS Rater;
        RETURN;
    END;

    SELECT rater FROM Rate_User WHERE rateId = @RateId;
END;
GO

-- # Rate_Game
CREATE OR ALTER PROCEDURE RGP_AddRateGame
@RateId UNIQUEIDENTIFIER,
@TargetGame UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_RateIdExists(@RateId) = 0 OR 
       DBO.GF_GameIdExists(@TargetGame) = 0 OR 
       DBO.RGF_RateGameExists(@RateId, @TargetGame) = 1
    BEGIN
        RAISERROR ('Failed to add rate game.', 16, 1);
        SELECT 0 AS RateGameAdded;
        RETURN;
    END;

    INSERT INTO Rate_Game (rateId, targetGame)
    VALUES (@RateId, @TargetGame);

    IF DBO.RGF_RateGameExists(@RateId, @TargetGame) = 0
    BEGIN
        RAISERROR ('Failed to add rate game.', 16, 1);
        SELECT 0 AS RateGameAdded;
        RETURN;
    END;

    SELECT 1 AS RateGameAdded;
END;
GO

CREATE OR ALTER PROCEDURE RGP_DeleteRateGame
@RateId UNIQUEIDENTIFIER,
@TargetGame UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RGF_RateGameExists(@RateId, @TargetGame) = 0
    BEGIN
        RAISERROR ('Failed to delete rate game.', 16, 1);
        SELECT 0 AS RateGameDeleted;
        RETURN;
    END;

    DELETE FROM Rate_Game WHERE rateId = @RateId AND targetGame = @TargetGame;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS RateGameDeleted;
END;
GO

CREATE OR ALTER PROCEDURE RGP_GetAllRateGame
AS
BEGIN
    SELECT * FROM Rate_Game;
END;
GO

CREATE OR ALTER PROCEDURE RGP_GetRatesOfGame
@TargetGame UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.GF_GameIdExists(@TargetGame) = 0
    BEGIN
        SELECT NULL AS RateId;
        RETURN;
    END;

    SELECT rateId FROM Rate_Game WHERE targetGame = @TargetGame;
END;
GO

CREATE OR ALTER PROCEDURE RGP_GetGamesOfRate
@RateId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_RateIdExists(@RateId) = 0
    BEGIN
        SELECT NULL AS TargetGame;
        RETURN;
    END;

    SELECT targetGame FROM Rate_Game WHERE rateId = @RateId;
END;
GO

-- #List_ListItem
CREATE OR ALTER PROCEDURE LLP_AddListListItem
@ListId UNIQUEIDENTIFIER,
@ListItemId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0 OR 
       DBO.LIF_ListItemIdExists(@ListItemId) = 0 OR 
       DBO.LLF_ListListItemExists(@ListId, @ListItemId) = 1
    BEGIN
        RAISERROR('Failed to add list item.', 16, 1);
        SELECT 0 AS ListListItemAdded;
        RETURN;
    END;

    INSERT INTO List_ListItem (listId, listItemId)
    VALUES (@ListId, @ListItemId);

    IF DBO.LLF_ListListItemExists(@ListId, @ListItemId) = 0
    BEGIN
        RAISERROR('Failed to add list item.', 16, 1);
        SELECT 0 AS ListListItemAdded;
        RETURN;
    END;

    SELECT 1 AS ListListItemAdded;
END;
GO

CREATE OR ALTER PROCEDURE LLP_DeleteListListItem
@ListId UNIQUEIDENTIFIER,
@ListItemId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.LLF_ListListItemExists(@ListId, @ListItemId) = 0
    BEGIN
        RAISERROR('Failed to delete list item.', 16, 1);
        SELECT 0 AS ListListItemDeleted;
        RETURN;
    END;

    DELETE FROM List_ListItem WHERE listId = @ListId AND listItemId = @ListItemId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ListListItemDeleted;
END;
GO

CREATE OR ALTER PROCEDURE LLP_GetAllListListItem
AS
BEGIN
    SELECT * FROM List_ListItem;
END;
GO

CREATE OR ALTER PROCEDURE LLP_GetListItemsOfList
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        SELECT NULL AS ListItemId;
        RETURN;
    END;

    SELECT listItemId FROM List_ListItem WHERE listId = @ListId;
END;
GO

CREATE OR ALTER PROCEDURE LLP_GetListsOfListItem
@ListItemId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0
    BEGIN
        SELECT NULL AS ListId;
        RETURN;
    END;

    SELECT listId FROM List_ListItem WHERE listItemId = @ListItemId;
END;
GO

-- #ListItem_Game
CREATE OR ALTER PROCEDURE LIGP_AddListItemGame
@ListItemId UNIQUEIDENTIFIER,
@TargetGame UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0 OR 
       DBO.GF_GameIdExists(@TargetGame) = 0 OR 
       DBO.LIGF_ListItemGameExists(@ListItemId, @TargetGame) = 1
    BEGIN
        RAISERROR ('Failed to add ListItemGame.', 16, 1);
        SELECT 0 AS ListItemGameAdded;
        RETURN;
    END;

    INSERT INTO ListItem_Game (listItemId, targetGame)
    VALUES (@ListItemId, @TargetGame);

    IF DBO.LIGF_ListItemGameExists(@ListItemId, @TargetGame) = 0
    BEGIN
        RAISERROR ('Failed to add ListItemGame.', 16, 1);
        SELECT 0 AS ListItemGameAdded;
        RETURN;
    END;

    SELECT 1 AS ListItemGameAdded;
END;
GO

CREATE OR ALTER PROCEDURE LIGP_DeleteListItemGame
@ListItemId UNIQUEIDENTIFIER,
@TargetGame UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.LIGF_ListItemGameExists(@ListItemId, @TargetGame) = 0
    BEGIN
        RAISERROR ('Failed to delete ListItemGame.', 16, 1);
        SELECT 0 AS ListItemGameDeleted;
        RETURN;
    END;

    DELETE FROM ListItem_Game WHERE listItemId = @ListItemId AND targetGame = @TargetGame;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ListItemGameDeleted;
END;
GO

CREATE OR ALTER PROCEDURE LIGP_GetAllListItemGame
AS
BEGIN
    SELECT * FROM ListItem_Game;
END;
GO

CREATE OR ALTER PROCEDURE LIGP_GetGamesOfListItem
@ListItemId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0
    BEGIN
        SELECT NULL AS TargetGame;
        RETURN;
    END;

    SELECT targetGame FROM ListItem_Game WHERE listItemId = @ListItemId;
END;
GO

CREATE OR ALTER PROCEDURE LIGP_GetListItemsOfGame
@TargetGame UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.GF_GameIdExists(@TargetGame) = 0
    BEGIN
        SELECT NULL AS ListItemId;
        RETURN;
    END;

    SELECT listItemId FROM ListItem_Game WHERE targetGame = @TargetGame;
END;
GO

-- # Comment_User
CREATE OR ALTER PROCEDURE CUP_AddCommentUser
@CommentId UNIQUEIDENTIFIER,
@Author UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0 OR 
       DBO.UF_UserIdExists(@Author) = 0 OR 
       DBO.CUF_CommentUserExists(@CommentId, @Author) = 1
    BEGIN
        RAISERROR ('Failed to add CommentUser.', 16, 1);
        SELECT 0 AS CommentUserAdded;
        RETURN;
    END;

    INSERT INTO Comment_User (commentId, author)
    VALUES (@CommentId, @Author);

    IF DBO.CUF_CommentUserExists(@CommentId, @Author) = 0
    BEGIN
        RAISERROR ('Failed to add CommentUser.', 16, 1);
        SELECT 0 AS CommentUserAdded;
        RETURN;
    END;

    SELECT 1 AS CommentUserAdded;
END;
GO

CREATE OR ALTER PROCEDURE CUP_DeleteCommentUser
@CommentId UNIQUEIDENTIFIER,
@Author UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.CUF_CommentUserExists(@CommentId, @Author) = 0
    BEGIN
        RAISERROR ('Failed to delete CommentUser.', 16, 1);
        SELECT 0 AS CommentUserDeleted;
        RETURN;
    END;

    DELETE FROM Comment_User WHERE commentId = @CommentId AND author = @Author;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS CommentUserDeleted;
END;
GO

CREATE OR ALTER PROCEDURE CUP_GetAllCommentUser
AS
BEGIN
    SELECT * FROM Comment_User;
END;
GO

CREATE OR ALTER PROCEDURE CUP_GetCommentsOfUser
@Author UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@Author) = 0
    BEGIN
        SELECT NULL AS CommentId;
        RETURN;
    END;

    SELECT commentId FROM Comment_User WHERE author = @Author;
END;
GO

CREATE OR ALTER PROCEDURE CUP_GetUsersOfComment
@CommentId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        SELECT NULL AS Author;
        RETURN;
    END;

    SELECT author FROM Comment_User WHERE commentId = @CommentId;
END;
GO

-- #Comment_Reaction
CREATE OR ALTER PROCEDURE CRP_AddCommentReaction
@CommentId UNIQUEIDENTIFIER,
@ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0 OR 
       DBO.RF_ReactionIdExists(@ReactionId) = 0 OR 
       DBO.CRF_CommentReactionExists(@CommentId, @ReactionId) = 1
    BEGIN
        RAISERROR ('Failed to add comment reaction.', 16, 1);
        SELECT 0 AS CommentReactionAdded;
        RETURN;
    END;

    INSERT INTO Comment_Reaction (commentId, reactionId)
    VALUES (@CommentId, @ReactionId);

    IF DBO.CRF_CommentReactionExists(@CommentId, @ReactionId) = 0
    BEGIN
        RAISERROR ('Failed to add comment reaction.', 16, 1);
        SELECT 0 AS CommentReactionAdded;
        RETURN;
    END;

    SELECT 1 AS CommentReactionAdded;
END;
GO

CREATE OR ALTER PROCEDURE CRP_DeleteCommentReaction
@CommentId UNIQUEIDENTIFIER,
@ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.CRF_CommentReactionExists(@CommentId, @ReactionId) = 0
    BEGIN
        RAISERROR ('Failed to delete comment reaction.', 16, 1);
        SELECT 0 AS CommentReactionDeleted;
        RETURN;
    END;

    DELETE FROM Comment_Reaction WHERE commentId = @CommentId AND reactionId = @ReactionId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS CommentReactionDeleted;
END;
GO

CREATE OR ALTER PROCEDURE CRP_GetAllCommentReaction
AS
BEGIN
    SELECT * FROM Comment_Reaction;
END;
GO

CREATE OR ALTER PROCEDURE CRP_GetReactionsOfComment
@CommentId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        SELECT NULL AS ReactionId;
        RETURN;
    END;

    SELECT reactionId FROM Comment_Reaction WHERE commentId = @CommentId;
END;
GO

CREATE OR ALTER PROCEDURE CRP_GetCommentsOfReaction
@ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SELECT NULL AS CommentId;
        RETURN;
    END;

    SELECT commentId FROM Comment_Reaction WHERE reactionId = @ReactionId;
END;
GO

-- #Comment_Review
CREATE OR ALTER PROCEDURE CRP_AddCommentReview
    @CommentId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0 OR 
       DBO.RF_ReviewIdExists(@ReviewId) = 0 OR 
       DBO.CRF_CommentReviewExists(@CommentId, @ReviewId) = 1
    BEGIN
        RAISERROR ('Failed to add comment review.', 16, 1);
        SELECT 0 AS CommentReviewAdded;
        RETURN;
    END;

    INSERT INTO Comment_Review (commentId, reviewId)
    VALUES (@CommentId, @ReviewId);

    IF DBO.CRF_CommentReviewExists(@CommentId, @ReviewId) = 0
    BEGIN
        RAISERROR ('Failed to add comment review.', 16, 1);
        SELECT 0 AS CommentReviewAdded;
        RETURN;
    END;

    SELECT 1 AS CommentReviewAdded;
END;
GO

CREATE OR ALTER PROCEDURE CRP_DeleteCommentReview
    @CommentId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.CRF_CommentReviewExists(@CommentId, @ReviewId) = 0
    BEGIN
        RAISERROR ('Failed to delete comment review.', 16, 1);
        SELECT 0 AS CommentReviewDeleted;
        RETURN;
    END;

    DELETE FROM Comment_Review WHERE commentId = @CommentId AND reviewId = @ReviewId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS CommentReviewDeleted;
END;
GO

CREATE OR ALTER PROCEDURE CRP_GetAllCommentReview
AS
BEGIN
    SELECT * FROM Comment_Review;
END;
GO

CREATE OR ALTER PROCEDURE CRP_GetReviewsByComment
    @CommentId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        SELECT NULL AS ReviewId;
        RETURN;
    END;

    SELECT reviewId FROM Comment_Review WHERE commentId = @CommentId;
END;
GO

CREATE OR ALTER PROCEDURE CRP_GetCommentsByReview
    @ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SELECT NULL AS CommentId;
        RETURN;
    END;

    SELECT commentId FROM Comment_Review WHERE reviewId = @ReviewId;
END;
GO

