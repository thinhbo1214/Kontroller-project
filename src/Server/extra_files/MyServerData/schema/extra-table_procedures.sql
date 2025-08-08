/*
    Database: KontrollerDB
    Description: Database for a game management system, storing information about users, games, reviews, comments, reactions, lists, activities, diaries, and their relationships.
*/
USE KontrollerDB;
GO

/* 
    Procedure: GSP_AddServiceToGame
    Description: Adds a game to a specified service in the Game_Service table.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to add.
        @ServiceName (NVARCHAR(30)): Name of the service to associate with the game.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE GSP_AddServiceToGame
    @GameId UNIQUEIDENTIFIER,
    @ServiceName NVARCHAR(30),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate game-service pair */
    IF DBO.GSF_IsGameServiceUsable(@GameId, @ServiceName) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert game-service pair */
    INSERT INTO [Game_Service] (gameId, serviceName)
    VALUES (@GameId, @ServiceName);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.GSF_GameServiceExists(@GameId, @ServiceName) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: GSP_RemoveGameService
    Description: Removes a game from a specified service in the Game_Service table.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to remove.
        @ServiceName (NVARCHAR(30)): Name of the service to disassociate.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE GSP_RemoveGameService
    @GameId UNIQUEIDENTIFIER,
    @ServiceName NVARCHAR(30),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify game-service pair existence */
    IF DBO.GSF_GameServiceExists(@GameId, @ServiceName) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete game-service pair */
    DELETE FROM [Game_Service] WHERE gameId = @GameId AND serviceName = @ServiceName;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.GSF_GameServiceExists(@GameId, @ServiceName) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: GSP_RemoveServiceByGame
    Description: Removes all services associated with a specified game from the Game_Service table.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to remove services for.
        @Result (INT OUTPUT): Number of rows affected (number of services removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE GSP_RemoveServiceByGame
    @GameId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify game existence */
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all services for the game */
    DELETE FROM [Game_Service] WHERE gameId = @GameId;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: GSP_GetGameServices
    Description: Retrieves all services associated with a specified game from the Game_Service table.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to query.
    Returns: Result set containing all services for the specified game, or empty if game does not exist.
*/
CREATE OR ALTER PROCEDURE GSP_GetGameServices
    @GameId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate game ID */
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        RETURN;
    END;

    /* Select all services for the game */
    SELECT serviceName FROM [Game_Service] WHERE gameId = @GameId;
END;
GO

/* 
    Procedure: GSP_GetServiceGames
    Description: Retrieves all games associated with a specified service from the Game_Service table.
    Parameters:
        @ServiceName (NVARCHAR(30)): Name of the service to query.
    Returns: Result set containing all games for the specified service, or empty if service is invalid.
*/
CREATE OR ALTER PROCEDURE GSP_GetServiceGames
    @ServiceName NVARCHAR(30)
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate service name */
    IF DBO.GSF_IsServiceNameLegal(@ServiceName) = 0
    BEGIN 
        RETURN;
    END;

    /* Select all games for the service */
    SELECT gameId FROM [Game_Service] WHERE serviceName = @ServiceName;
END;
GO

/* 
    Procedure: UDP_AddUserDiary
    Description: Adds a user-diary association to the User_Diary table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user.
        @DiaryId (UNIQUEIDENTIFIER): ID of the diary.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE UDP_AddUserDiary
    @UserId UNIQUEIDENTIFIER,
    @DiaryId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user and diary existence */
    IF DBO.UF_UserIdExists(@UserId) = 0 OR DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Check if user-diary pair already exists */
    IF DBO.UDF_UserDiaryExists(@UserId, @DiaryId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert user-diary pair */
    INSERT INTO [User_Diary] (userId, diaryId)
    VALUES (@UserId, @DiaryId);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.UDF_UserDiaryExists(@UserId, @DiaryId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: UDP_DeleteUserDiary
    Description: Removes a user-diary association from the User_Diary table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user.
        @DiaryId (UNIQUEIDENTIFIER): ID of the diary.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE UDP_DeleteUserDiary
    @UserId UNIQUEIDENTIFIER,
    @DiaryId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if user-diary pair exists */
    IF DBO.UDF_UserDiaryExists(@UserId, @DiaryId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete user-diary pair */
    DELETE FROM [User_Diary] WHERE userId = @UserId AND diaryId = @DiaryId;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.UDF_UserDiaryExists(@UserId, @DiaryId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: UDP_DeleteDiaryByUser
    Description: Removes all diary associations for a specified user from the User_Diary table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to remove diaries for.
        @Result (INT OUTPUT): Number of rows affected (number of diaries removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE UDP_DeleteDiaryByUser
    @UserId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user existence */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all diaries for the user */
    DELETE FROM [User_Diary] WHERE userId = @UserId;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: UDP_GetAllUserDiary
    Description: Retrieves all user-diary associations from the User_Diary table.
    Parameters: None
    Returns: Result set containing all user-diary pairs.
*/
CREATE OR ALTER PROCEDURE UDP_GetAllUserDiary
AS
BEGIN
    SET NOCOUNT ON;

    /* Select all user-diary pairs */
    SELECT * FROM [User_Diary];
END;
GO

/* 
    Procedure: UDP_GetDiariesOfUser
    Description: Retrieves all diary IDs associated with a specified user from the User_Diary table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to query.
    Returns: Result set containing diary IDs for the specified user, or NULL if user does not exist.
*/
CREATE OR ALTER PROCEDURE UDP_GetDiariesOfUser
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SELECT NULL AS DiaryId;
        RETURN;
    END;

    /* Select diary IDs for the user */
    SELECT diaryId FROM [User_Diary] WHERE userId = @UserId;
END;
GO

/* 
    Procedure: UDP_GetUsersOfDiary
    Description: Retrieves all user IDs associated with a specified diary from the User_Diary table.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): ID of the diary to query.
    Returns: Result set containing user IDs for the specified diary, or NULL if diary does not exist.
*/
CREATE OR ALTER PROCEDURE UDP_GetUsersOfDiary
    @DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate diary ID */
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        SELECT NULL AS UserId;
        RETURN;
    END;

    /* Select user IDs for the diary */
    SELECT userId FROM [User_Diary] WHERE diaryId = @DiaryId;
END;
GO

/* 
    Procedure: ULP_AddUserList
    Description: Adds a user-list association to the User_List table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user.
        @ListId (UNIQUEIDENTIFIER): ID of the list.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE ULP_AddUserList
    @UserId UNIQUEIDENTIFIER,
    @ListId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user and list existence */
    IF DBO.UF_UserIdExists(@UserId) = 0 OR DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Check if user-list pair already exists */
    IF DBO.ULF_UserListExists(@UserId, @ListId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert user-list pair */
    INSERT INTO [User_List] (userId, listId)
    VALUES (@UserId, @ListId);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.ULF_UserListExists(@UserId, @ListId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: ULP_DeleteUserList
    Description: Removes a user-list association from the User_List table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user.
        @ListId (UNIQUEIDENTIFIER): ID of the list.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE ULP_DeleteUserList
    @UserId UNIQUEIDENTIFIER,
    @ListId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if user-list pair exists */
    IF DBO.ULF_UserListExists(@UserId, @ListId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete user-list pair */
    DELETE FROM [User_List] WHERE userId = @UserId AND listId = @ListId;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.ULF_UserListExists(@UserId, @ListId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: ULP_DeleteListByUser
    Description: Removes all list associations for a specified user from the User_List table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to remove lists for.
        @Result (INT OUTPUT): Number of rows affected (number of lists removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE ULP_DeleteListByUser
    @UserId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user existence */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all lists for the user */
    DELETE FROM [User_List] WHERE userId = @UserId;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: ULP_GetAllUserList
    Description: Retrieves all user-list associations from the User_List table.
    Parameters: None
    Returns: Result set containing all user-list pairs.
*/
CREATE OR ALTER PROCEDURE ULP_GetAllUserList
AS
BEGIN
    SET NOCOUNT ON;

    /* Select all user-list pairs */
    SELECT * FROM [User_List];
END;
GO

/* 
    Procedure: ULP_GetListsOfUser
    Description: Retrieves all list IDs associated with a specified user from the User_List table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to query.
    Returns: Result set containing list IDs for the specified user, or NULL if user does not exist.
*/
CREATE OR ALTER PROCEDURE ULP_GetListsOfUser
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SELECT NULL AS ListId;
        RETURN;
    END;

    /* Select list IDs for the user */
    SELECT listId FROM [User_List] WHERE userId = @UserId;
END;
GO

/* 
    Procedure: ULP_GetUsersOfList
    Description: Retrieves all user IDs associated with a specified list from the User_List table.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to query.
    Returns: Result set containing user IDs for the specified list, or NULL if list does not exist.
*/
CREATE OR ALTER PROCEDURE ULP_GetUsersOfList
    @ListId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate list ID */
    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        SELECT NULL AS UserId;
        RETURN;
    END;

    /* Select user IDs for the list */
    SELECT userId FROM [User_List] WHERE listId = @ListId;
END;
GO

/* 
    Procedure: UUP_AddUserFollow
    Description: Adds a follower-following relationship to the User_User table.
    Parameters:
        @UserFollower (UNIQUEIDENTIFIER): ID of the follower user.
        @UserFollowing (UNIQUEIDENTIFIER): ID of the user being followed.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE UUP_AddUserFollow
    @UserFollower UNIQUEIDENTIFIER,
    @UserFollowing UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user existence and prevent self-following */
    IF DBO.UF_UserIdExists(@UserFollower) = 0 OR 
       DBO.UF_UserIdExists(@UserFollowing) = 0 OR
       @UserFollower = @UserFollowing
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Check if follower-following pair already exists */
    IF DBO.UUF_UserUserExists(@UserFollower, @UserFollowing) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert follower-following pair */
    INSERT INTO [User_User] (userFollower, userFollowing)
    VALUES (@UserFollower, @UserFollowing);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.UUF_UserUserExists(@UserFollower, @UserFollowing) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: UUP_RemoveUserFollow
    Description: Removes a follower-following relationship from the User_User table.
    Parameters:
        @UserFollower (UNIQUEIDENTIFIER): ID of the follower user.
        @UserFollowing (UNIQUEIDENTIFIER): ID of the user being followed.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE UUP_RemoveUserFollow
    @UserFollower UNIQUEIDENTIFIER,
    @UserFollowing UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if follower-following pair exists */
    IF DBO.UUF_UserUserExists(@UserFollower, @UserFollowing) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete follower-following pair */
    DELETE FROM [User_User]
    WHERE userFollower = @UserFollower AND userFollowing = @UserFollowing;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.UUF_UserUserExists(@UserFollower, @UserFollowing) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: UUP_RemoveFollowingUser
    Description: Removes all users that a specified user is following from the User_User table.
    Parameters:
        @UserFollower (UNIQUEIDENTIFIER): ID of the follower user.
        @Result (INT OUTPUT): Number of rows affected (number of followings removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE UUP_RemoveFollowingUser
    @UserFollower UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user existence */
    IF DBO.UF_UserIdExists(@UserFollower) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all followings for the user */
    DELETE FROM [User_User]
    WHERE userFollower = @UserFollower;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: UUP_RemoveFollowerUser
    Description: Removes all users that are following a specified user from the User_User table.
    Parameters:
        @UserFollowing (UNIQUEIDENTIFIER): ID of the user being followed.
        @Result (INT OUTPUT): Number of rows affected (number of followers removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE UUP_RemoveFollowerUser
    @UserFollowing UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user existence */
    IF DBO.UF_UserIdExists(@UserFollowing) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all followers for the user */
    DELETE FROM [User_User]
    WHERE userFollowing = @UserFollowing;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: UUP_GetFollowingUsers
    Description: Retrieves all users that a specified user is following from the User_User table.
    Parameters:
        @UserFollower (UNIQUEIDENTIFIER): ID of the follower user.
    Returns: Result set containing IDs of users being followed, or NULL if user does not exist.
*/
CREATE OR ALTER PROCEDURE UUP_GetFollowingUsers
    @UserFollower UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@UserFollower) = 0
    BEGIN
        SELECT NULL AS userFollowing;
        RETURN;
    END;

    /* Select users being followed */
    SELECT userFollowing
    FROM [User_User]
    WHERE userFollower = @UserFollower;
END;
GO

/* 
    Procedure: UUP_GetFollowerUsers
    Description: Retrieves all users that are following a specified user from the User_User table.
    Parameters:
        @UserFollowing (UNIQUEIDENTIFIER): ID of the user being followed.
    Returns: Result set containing IDs of follower users, or NULL if user does not exist.
*/
CREATE OR ALTER PROCEDURE UUP_GetFollowerUsers
    @UserFollowing UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@UserFollowing) = 0
    BEGIN
        SELECT NULL AS userFollower;
        RETURN;
    END;

    /* Select follower users */
    SELECT userFollower
    FROM [User_User]
    WHERE userFollowing = @UserFollowing;
END;
GO

/* 
    Procedure: UAP_CreateUserActivity
    Description: Adds a user-activity association to the User_Activity table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user.
        @ActivityId (UNIQUEIDENTIFIER): ID of the activity.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE UAP_CreateUserActivity
    @UserId UNIQUEIDENTIFIER,
    @ActivityId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user and activity existence */
    IF DBO.UF_UserIdExists(@UserId) = 0 OR DBO.AF_ActivityIdExists(@ActivityId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Check if user-activity pair already exists */
    IF DBO.UAF_UserActivityExists(@UserId, @ActivityId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert user-activity pair */
    INSERT INTO [User_Activity] (userId, activityId)
    VALUES (@UserId, @ActivityId);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.UAF_UserActivityExists(@UserId, @ActivityId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: UAP_DeleteUserActivity
    Description: Removes a user-activity association from the User_Activity table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user.
        @ActivityId (UNIQUEIDENTIFIER): ID of the activity.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE UAP_DeleteUserActivity
    @UserId UNIQUEIDENTIFIER,
    @ActivityId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if user-activity pair exists */
    IF DBO.UAF_UserActivityExists(@UserId, @ActivityId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete user-activity pair */
    DELETE FROM [User_Activity]
    WHERE userId = @UserId AND activityId = @ActivityId;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.UAF_UserActivityExists(@UserId, @ActivityId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: UAP_DeleteAllActivityByUser
    Description: Removes all activity associations for a specified user from the User_Activity table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to remove activities for.
        @Result (INT OUTPUT): Number of rows affected (number of activities removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE UAP_DeleteAllActivityByUser
    @UserId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user existence */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all activities for the user */
    DELETE FROM [User_Activity]
    WHERE userId = @UserId;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: UAP_GetAllUserActivity
    Description: Retrieves all user-activity associations from the User_Activity table.
    Parameters: None
    Returns: Result set containing all user-activity pairs.
*/
CREATE OR ALTER PROCEDURE UAP_GetAllUserActivity
AS
BEGIN
    SET NOCOUNT ON;

    /* Select all user-activity pairs */
    SELECT * FROM [User_Activity];
END;
GO

/* 
    Procedure: UAP_GetActivitiesByUser
    Description: Retrieves all activity IDs associated with a specified user from the User_Activity table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to query.
    Returns: Result set containing activity IDs for the specified user, or NULL if user does not exist.
*/
CREATE OR ALTER PROCEDURE UAP_GetActivitiesByUser
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SELECT NULL AS ActivityId;
        RETURN;
    END;

    /* Select activity IDs for the user */
    SELECT activityId FROM [User_Activity]
    WHERE userId = @UserId;
END;
GO

/* 
    Procedure: UAP_GetUsersByActivity
    Description: Retrieves all user IDs associated with a specified activity from the User_Activity table.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): ID of the activity to query.
    Returns: Result set containing user IDs for the specified activity, or NULL if activity does not exist.
*/
CREATE OR ALTER PROCEDURE UAP_GetUsersByActivity
    @ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate activity ID */
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
    BEGIN
        SELECT NULL AS UserId;
        RETURN;
    END;

    /* Select user IDs for the activity */
    SELECT userId FROM [User_Activity]
    WHERE activityId = @ActivityId;
END;
GO

/* 
    Procedure: RUP_CreateReviewUser
    Description: Adds a review-author association to the Review_User table.
    Parameters:
        @Author (UNIQUEIDENTIFIER): ID of the user who authored the review.
        @ReviewId (UNIQUEIDENTIFIER): ID of the review.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE RUP_CreateReviewUser
    @Author UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user and review existence */
    IF DBO.UF_UserIdExists(@Author) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Check if review-author pair already exists */
    IF DBO.RUF_ReviewUserExists(@Author, @ReviewId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert review-author pair */
    INSERT INTO [Review_User] (author, reviewId)
    VALUES (@Author, @ReviewId);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.RUF_ReviewUserExists(@Author, @ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: RUP_DeleteReviewUser
    Description: Removes a review-author association from the Review_User table.
    Parameters:
        @Author (UNIQUEIDENTIFIER): ID of the user who authored the review.
        @ReviewId (UNIQUEIDENTIFIER): ID of the review.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE RUP_DeleteReviewUser
    @Author UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if review-author pair exists */
    IF DBO.RUF_ReviewUserExists(@Author, @ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete review-author pair */
    DELETE FROM [Review_User]
    WHERE author = @Author AND reviewId = @ReviewId;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.RUF_ReviewUserExists(@Author, @ReviewId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: RUP_DeleteReviewByUser
    Description: Removes all review associations for a specified user from the Review_User table.
    Parameters:
        @Author (UNIQUEIDENTIFIER): ID of the user to remove reviews for.
        @Result (INT OUTPUT): Number of rows affected (number of reviews removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE RUP_DeleteReviewByUser
    @Author UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user existence */
    IF DBO.UF_UserIdExists(@Author) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all reviews for the user */
    DELETE FROM [Review_User]
    WHERE author = @Author;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: RUP_GetAllReviewUsers
    Description: Retrieves all review-author associations from the Review_User table.
    Parameters: None
    Returns: Result set containing all review-author pairs.
*/
CREATE OR ALTER PROCEDURE RUP_GetAllReviewUsers
AS
BEGIN
    SET NOCOUNT ON;

    /* Select all review-author pairs */
    SELECT * FROM [Review_User];
END;
GO

/* 
    Procedure: RUP_GetReviewIdsByAuthor
    Description: Retrieves all review IDs authored by a specified user from the Review_User table.
    Parameters:
        @Author (UNIQUEIDENTIFIER): ID of the user to query.
    Returns: Result set containing review IDs for the specified author, or NULL if author does not exist.
*/
CREATE OR ALTER PROCEDURE RUP_GetReviewIdsByAuthor
    @Author UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@Author) = 0
    BEGIN
        SELECT NULL AS ReviewId;
        RETURN;
    END;

    /* Select review IDs for the author */
    SELECT reviewId
    FROM [Review_User]
    WHERE author = @Author;
END;
GO

/* 
    Procedure: RUP_GetAuthorsByReviewId
    Description: Retrieves all author IDs for a specified review from the Review_User table.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to query.
    Returns: Result set containing author IDs for the specified review, or NULL if review does not exist.
*/
CREATE OR ALTER PROCEDURE RUP_GetAuthorsByReviewId
    @ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate review ID */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SELECT NULL AS Author;
        RETURN;
    END;

    /* Select author IDs for the review */
    SELECT author
    FROM [Review_User]
    WHERE reviewId = @ReviewId;
END;
GO

/* 
    Procedure: RRP_CreateReviewReaction
    Description: Adds a reaction-review association to the Review_Reaction table.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction.
        @ReviewId (UNIQUEIDENTIFIER): ID of the review.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE RRP_CreateReviewReaction
    @ReactionId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify reaction and review existence */
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Check if reaction-review pair already exists */
    IF DBO.RRF_ReviewReactionExists(@ReactionId, @ReviewId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert reaction-review pair */
    INSERT INTO [Review_Reaction] (reactionId, reviewId)
    VALUES (@ReactionId, @ReviewId);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.RRF_ReviewReactionExists(@ReactionId, @ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: RRP_DeleteReviewReaction
    Description: Removes a reaction-review association from the Review_Reaction table.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction.
        @ReviewId (UNIQUEIDENTIFIER): ID of the review.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE RRP_DeleteReviewReaction
    @ReactionId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if reaction-review pair exists */
    IF DBO.RRF_ReviewReactionExists(@ReactionId, @ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete reaction-review pair */
    DELETE FROM [Review_Reaction]
    WHERE reactionId = @ReactionId AND reviewId = @ReviewId;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.RRF_ReviewReactionExists(@ReactionId, @ReviewId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: RRP_DeleteReactionByReview
    Description: Removes all reaction associations for a specified review from the Review_Reaction table.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to remove reactions for.
        @Result (INT OUTPUT): Number of rows affected (number of reactions removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE RRP_DeleteReactionByReview
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify review existence */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all reactions for the review */
    DELETE FROM [Review_Reaction]
    WHERE reviewId = @ReviewId;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: RRP_GetAllReviewReactions
    Description: Retrieves all reaction-review associations from the Review_Reaction table.
    Parameters: None
    Returns: Result set containing all reaction-review pairs.
*/
CREATE OR ALTER PROCEDURE RRP_GetAllReviewReactions
AS
BEGIN
    SET NOCOUNT ON;

    /* Select all reaction-review pairs */
    SELECT * FROM [Review_Reaction];
END;
GO

/* 
    Procedure: RRP_GetReactionsByReview
    Description: Retrieves all reaction IDs associated with a specified review from the Review_Reaction table.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to query.
    Returns: Result set containing reaction IDs for the specified review, or NULL if review does not exist.
*/
CREATE OR ALTER PROCEDURE RRP_GetReactionsByReview
    @ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate review ID */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SELECT NULL AS ReactionId;
        RETURN;
    END;

    /* Select reaction IDs for the review */
    SELECT reactionId FROM [Review_Reaction]
    WHERE reviewId = @ReviewId;
END;
GO

/* 
    Procedure: RRP_GetReviewsByReaction
    Description: Retrieves all review IDs associated with a specified reaction from the Review_Reaction table.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction to query.
    Returns: Result set containing review IDs for the specified reaction, or NULL if reaction does not exist.
*/
CREATE OR ALTER PROCEDURE RRP_GetReviewsByReaction
    @ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate reaction ID */
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SELECT NULL AS ReviewId;
        RETURN;
    END;

    /* Select review IDs for the reaction */
    SELECT reviewId FROM [Review_Reaction]
    WHERE reactionId = @ReactionId;
END;
GO

/* 
    Procedure: GRP_AddGameReview
    Description: Adds a game-review association to the Game_Review table.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game.
        @ReviewId (UNIQUEIDENTIFIER): ID of the review.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE GRP_AddGameReview
    @GameId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify game and review existence */
    IF DBO.GF_GameIdExists(@GameId) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Check if game-review pair already exists */
    IF DBO.GRF_GameReviewExists(@GameId, @ReviewId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert game-review pair */
    INSERT INTO [Game_Review] (gameId, reviewId)
    VALUES (@GameId, @ReviewId);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.GRF_GameReviewExists(@GameId, @ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: GRP_DeleteGameReview
    Description: Removes a game-review association from the Game_Review table.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game.
        @ReviewId (UNIQUEIDENTIFIER): ID of the review.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE GRP_DeleteGameReview
    @GameId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if game-review pair exists */
    IF DBO.GRF_GameReviewExists(@GameId, @ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete game-review pair */
    DELETE FROM [Game_Review] WHERE gameId = @GameId AND reviewId = @ReviewId;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.GRF_GameReviewExists(@GameId, @ReviewId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: GRP_DeleteReviewByGame
    Description: Removes all review associations for a specified game from the Game_Review table.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to remove reviews for.
        @Result (INT OUTPUT): Number of rows affected (number of reviews removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE GRP_DeleteReviewByGame
    @GameId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify game existence */
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all reviews for the game */
    DELETE FROM [Game_Review] WHERE gameId = @GameId;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: GRP_GetAllGameReview
    Description: Retrieves all game-review associations from the Game_Review table.
    Parameters: None
    Returns: Result set containing all game-review pairs.
*/
CREATE OR ALTER PROCEDURE GRP_GetAllGameReview
AS
BEGIN
    SET NOCOUNT ON;

    /* Select all game-review pairs */
    SELECT * FROM [Game_Review];
END;
GO

/* 
    Procedure: GRP_GetGameOfReview
    Description: Retrieves all game IDs associated with a specified review from the Game_Review table.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to query.
    Returns: Result set containing game IDs for the specified review, or NULL if review does not exist.
*/
CREATE OR ALTER PROCEDURE GRP_GetGameOfReview
    @ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate review ID */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SELECT NULL AS GameId;
        RETURN;
    END;

    /* Select game IDs for the review */
    SELECT gameId FROM [Game_Review] WHERE reviewId = @ReviewId;
END;
GO

/* 
    Procedure: GRP_GetReviewOfGame
    Description: Retrieves all review IDs associated with a specified game from the Game_Review table.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to query.
    Returns: Result set containing review IDs for the specified game, or NULL if game does not exist.
*/
CREATE OR ALTER PROCEDURE GRP_GetReviewOfGame
    @GameId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate game ID */
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        SELECT NULL AS ReviewId;
        RETURN;
    END;

    /* Select review IDs for the game */
    SELECT reviewId FROM [Game_Review] WHERE gameId = @GameId;
END;
GO

/* 
    Procedure: RUP_AddReactionUser
    Description: Adds a reaction-author association to the Reaction_User table.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction.
        @Author (UNIQUEIDENTIFIER): ID of the user who authored the reaction.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE RUP_AddReactionUser
    @ReactionId UNIQUEIDENTIFIER,
    @Author UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify reaction and user existence */
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0 OR DBO.UF_UserIdExists(@Author) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Check if reaction-author pair already exists */
    IF DBO.RUF_ReactionUserExists(@ReactionId, @Author) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert reaction-author pair */
    INSERT INTO [Reaction_User] (reactionId, author)
    VALUES (@ReactionId, @Author);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.RUF_ReactionUserExists(@ReactionId, @Author) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: RUP_DeleteReactionUser
    Description: Removes a reaction-author association from the Reaction_User table.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction.
        @Author (UNIQUEIDENTIFIER): ID of the user who authored the reaction.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE RUP_DeleteReactionUser
    @ReactionId UNIQUEIDENTIFIER,
    @Author UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if reaction-author pair exists */
    IF DBO.RUF_ReactionUserExists(@ReactionId, @Author) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete reaction-author pair */
    DELETE FROM [Reaction_User] WHERE reactionId = @ReactionId AND author = @Author;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.RUF_ReactionUserExists(@ReactionId, @Author) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: RUP_DeleteReactionByUser
    Description: Removes all reaction associations for a specified user from the Reaction_User table.
    Parameters:
        @Author (UNIQUEIDENTIFIER): ID of the user to remove reactions for.
        @Result (INT OUTPUT): Number of rows affected (number of reactions removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE RUP_DeleteReactionByUser
    @Author UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user existence */
    IF DBO.UF_UserIdExists(@Author) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all reactions for the user */
    DELETE FROM [Reaction_User] WHERE author = @Author;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: RUP_GetAllReactionUser
    Description: Retrieves all reaction-author associations from the Reaction_User table.
    Parameters: None
    Returns: Result set containing all reaction-author pairs.
*/
CREATE OR ALTER PROCEDURE RUP_GetAllReactionUser
AS
BEGIN
    SET NOCOUNT ON;

    /* Select all reaction-author pairs */
    SELECT * FROM [Reaction_User];
END;
GO

/* 
    Procedure: RUP_GetReactionsOfUser
    Description: Retrieves all reaction IDs authored by a specified user from the Reaction_User table.
    Parameters:
        @Author (UNIQUEIDENTIFIER): ID of the user to query.
    Returns: Result set containing reaction IDs for the specified user, or NULL if user does not exist.
*/
CREATE OR ALTER PROCEDURE RUP_GetReactionsOfUser
    @Author UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@Author) = 0
    BEGIN
        SELECT NULL AS ReactionId;
        RETURN;
    END;

    /* Select reaction IDs for the user */
    SELECT reactionId FROM [Reaction_User] WHERE author = @Author;
END;
GO

/* 
    Procedure: RUP_GetUsersOfReaction
    Description: Retrieves all user IDs associated with a specified reaction from the Reaction_User table.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction to query.
    Returns: Result set containing user IDs for the specified reaction, or NULL if reaction does not exist.
*/
CREATE OR ALTER PROCEDURE RUP_GetUsersOfReaction
    @ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate reaction ID */
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SELECT NULL AS Author;
        RETURN;
    END;

    /* Select user IDs for the reaction */
    SELECT author FROM [Reaction_User] WHERE reactionId = @ReactionId;
END;
GO

/* 
    Procedure: LGP_AddListGame
    Description: Adds a list-game association to the List_Game table.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list.
        @TargetGame (UNIQUEIDENTIFIER): ID of the game.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE LGP_AddListGame
    @ListId UNIQUEIDENTIFIER,
    @TargetGame UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify list and game existence */
    IF DBO.LF_ListIdExists(@ListId) = 0 OR DBO.GF_GameIdExists(@TargetGame) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Check if list-game pair already exists */
    IF DBO.LGF_ListGameExists(@ListId, @TargetGame) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert list-game pair */
    INSERT INTO [List_Game] (listId, targetGame)
    VALUES (@ListId, @TargetGame);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.LGF_ListGameExists(@ListId, @TargetGame) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: LGP_DeleteListGame
    Description: Removes a list-game association from the List_Game table.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list.
        @TargetGame (UNIQUEIDENTIFIER): ID of the game.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE LGP_DeleteListGame
    @ListId UNIQUEIDENTIFIER,
    @TargetGame UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if list-game pair exists */
    IF DBO.LGF_ListGameExists(@ListId, @TargetGame) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete list-game pair */
    DELETE FROM [List_Game] WHERE listId = @ListId AND targetGame = @TargetGame;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.LGF_ListGameExists(@ListId, @TargetGame) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: LGP_DeleteGameByList
    Description: Removes all game associations for a specified list from the List_Game table.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to remove games for.
        @Result (INT OUTPUT): Number of rows affected (number of games removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE LGP_DeleteGameByList
    @ListId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify list existence */
    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all games for the list */
    DELETE FROM [List_Game] WHERE listId = @ListId;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: LGP_GetAllListGame
    Description: Retrieves all list-game associations from the List_Game table.
    Parameters: None
    Returns: Result set containing all list-game pairs.
*/
CREATE OR ALTER PROCEDURE LGP_GetAllListGame
AS
BEGIN
    SET NOCOUNT ON;

    /* Select all list-game pairs */
    SELECT * FROM [List_Game];
END;
GO

/* 
    Procedure: LGP_GetGamesOfList
    Description: Retrieves all game IDs associated with a specified list from the List_Game table.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to query.
    Returns: Result set containing game IDs for the specified list, or NULL if list does not exist.
*/
CREATE OR ALTER PROCEDURE LGP_GetGamesOfList
    @ListId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate list ID */
    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        SELECT NULL AS TargetGame;
        RETURN;
    END;

    /* Select game IDs for the list */
    SELECT targetGame FROM [List_Game] WHERE listId = @ListId;
END;
GO

/* 
    Procedure: LGP_GetListsOfGame
    Description: Retrieves all list IDs associated with a specified game from the List_Game table.
    Parameters:
        @TargetGame (UNIQUEIDENTIFIER): ID of the game to query.
    Returns: Result set containing list IDs for the specified game, or NULL if game does not exist.
*/
CREATE OR ALTER PROCEDURE LGP_GetListsOfGame
    @TargetGame UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate game ID */
    IF DBO.GF_GameIdExists(@TargetGame) = 0
    BEGIN
        SELECT NULL AS ListId;
        RETURN;
    END;

    /* Select list IDs for the game */
    SELECT listId FROM [List_Game] WHERE targetGame = @TargetGame;
END;
GO

/* 
    Procedure: CUP_AddCommentUser
    Description: Adds a comment-author association to the Comment_User table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment.
        @Author (UNIQUEIDENTIFIER): ID of the user who authored the comment.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE CUP_AddCommentUser
    @CommentId UNIQUEIDENTIFIER,
    @Author UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify comment and user existence */
    IF DBO.CF_CommentIdExists(@CommentId) = 0 OR DBO.UF_UserIdExists(@Author) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Check if comment-author pair already exists */
    IF DBO.CUF_CommentUserExists(@CommentId, @Author) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert comment-author pair */
    INSERT INTO [Comment_User] (commentId, author)
    VALUES (@CommentId, @Author);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.CUF_CommentUserExists(@CommentId, @Author) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: CUP_DeleteCommentUser
    Description: Removes a comment-author association from the Comment_User table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment.
        @Author (UNIQUEIDENTIFIER): ID of the user who authored the comment.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE CUP_DeleteCommentUser
    @CommentId UNIQUEIDENTIFIER,
    @Author UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if comment-author pair exists */
    IF DBO.CUF_CommentUserExists(@CommentId, @Author) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete comment-author pair */
    DELETE FROM [Comment_User] WHERE commentId = @CommentId AND author = @Author;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.CUF_CommentUserExists(@CommentId, @Author) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: CUP_DeleteCommentByUser
    Description: Removes all comment associations for a specified user from the Comment_User table.
    Parameters:
        @Author (UNIQUEIDENTIFIER): ID of the user to remove comments for.
        @Result (INT OUTPUT): Number of rows affected (number of comments removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE CUP_DeleteCommentByUser
    @Author UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user existence */
    IF DBO.UF_UserIdExists(@Author) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all comments for the user */
    DELETE FROM [Comment_User] WHERE author = @Author;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: CUP_GetAllCommentUser
    Description: Retrieves all comment-author associations from the Comment_User table.
    Parameters: None
    Returns: Result set containing all comment-author pairs.
*/
CREATE OR ALTER PROCEDURE CUP_GetAllCommentUser
AS
BEGIN
    SET NOCOUNT ON;

    /* Select all comment-author pairs */
    SELECT * FROM [Comment_User];
END;
GO

/* 
    Procedure: CUP_GetCommentsOfUser
    Description: Retrieves all comment IDs authored by a specified user from the Comment_User table.
    Parameters:
        @Author (UNIQUEIDENTIFIER): ID of the user to query.
    Returns: Result set containing comment IDs for the specified user, or NULL if user does not exist.
*/
CREATE OR ALTER PROCEDURE CUP_GetCommentsOfUser
    @Author UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@Author) = 0
    BEGIN
        SELECT NULL AS CommentId;
        RETURN;
    END;

    /* Select comment IDs for the user */
    SELECT commentId FROM [Comment_User] WHERE author = @Author;
END;
GO

/* 
    Procedure: CUP_GetUsersOfComment
    Description: Retrieves all user IDs associated with a specified comment from the Comment_User table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to query.
    Returns: Result set containing user IDs for the specified comment, or NULL if comment does not exist.
*/
CREATE OR ALTER PROCEDURE CUP_GetUsersOfComment
    @CommentId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate comment ID */
    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        SELECT NULL AS Author;
        RETURN;
    END;

    /* Select user IDs for the comment */
    SELECT author FROM [Comment_User] WHERE commentId = @CommentId;
END;
GO

/* 
    Procedure: CRP_AddCommentReaction
    Description: Adds a comment-reaction association to the Comment_Reaction table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment.
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE CRP_AddCommentReaction
    @CommentId UNIQUEIDENTIFIER,
    @ReactionId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify comment and reaction existence */
    IF DBO.CF_CommentIdExists(@CommentId) = 0 OR DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Check if comment-reaction pair already exists */
    IF DBO.CRF_CommentReactionExists(@CommentId, @ReactionId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert comment-reaction pair */
    INSERT INTO [Comment_Reaction] (commentId, reactionId)
    VALUES (@CommentId, @ReactionId);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.CRF_CommentReactionExists(@CommentId, @ReactionId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: CRP_DeleteCommentReaction
    Description: Removes a comment-reaction association from the Comment_Reaction table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment.
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE CRP_DeleteCommentReaction
    @CommentId UNIQUEIDENTIFIER,
    @ReactionId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if comment-reaction pair exists */
    IF DBO.CRF_CommentReactionExists(@CommentId, @ReactionId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete comment-reaction pair */
    DELETE FROM [Comment_Reaction] WHERE commentId = @CommentId AND reactionId = @ReactionId;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.CRF_CommentReactionExists(@CommentId, @ReactionId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: CRP_DeleteReactionByComment
    Description: Removes all reaction associations for a specified comment from the Comment_Reaction table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to remove reactions for.
        @Result (INT OUTPUT): Number of rows affected (number of reactions removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE CRP_DeleteReactionByComment
    @CommentId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify comment existence */
    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all reactions for the comment */
    DELETE FROM [Comment_Reaction] WHERE commentId = @CommentId;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: CRP_GetAllCommentReaction
    Description: Retrieves all comment-reaction associations from the Comment_Reaction table.
    Parameters: None
    Returns: Result set containing all comment-reaction pairs.
*/
CREATE OR ALTER PROCEDURE CRP_GetAllCommentReaction
AS
BEGIN
    SET NOCOUNT ON;

    /* Select all comment-reaction pairs */
    SELECT * FROM [Comment_Reaction];
END;
GO

/* 
    Procedure: CRP_GetReactionsOfComment
    Description: Retrieves all reaction IDs associated with a specified comment from the Comment_Reaction table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to query.
    Returns: Result set containing reaction IDs for the specified comment, or NULL if comment does not exist.
*/
CREATE OR ALTER PROCEDURE CRP_GetReactionsOfComment
    @CommentId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate comment ID */
    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        SELECT NULL AS ReactionId;
        RETURN;
    END;

    /* Select reaction IDs for the comment */
    SELECT reactionId FROM [Comment_Reaction] WHERE commentId = @CommentId;
END;
GO

/* 
    Procedure: CRP_GetCommentsOfReaction
    Description: Retrieves all comment IDs associated with a specified reaction from the Comment_Reaction table.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction to query.
    Returns: Result set containing comment IDs for the specified reaction, or NULL if reaction does not exist.
*/
CREATE OR ALTER PROCEDURE CRP_GetCommentsOfReaction
    @ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate reaction ID */
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SELECT NULL AS CommentId;
        RETURN;
    END;

    /* Select comment IDs for the reaction */
    SELECT commentId FROM [Comment_Reaction] WHERE reactionId = @ReactionId;
END;
GO

/* 
    Procedure: CRP_AddCommentReview
    Description: Adds a comment-review association to the Comment_Review table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment.
        @ReviewId (UNIQUEIDENTIFIER): ID of the review.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE CRP_AddCommentReview
    @CommentId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify comment and review existence */
    IF DBO.CF_CommentIdExists(@CommentId) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Check if comment-review pair already exists */
    IF DBO.CRF_CommentReviewExists(@CommentId, @ReviewId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Insert comment-review pair */
    INSERT INTO [Comment_Review] (commentId, reviewId)
    VALUES (@CommentId, @ReviewId);
    SET @Result = @@ROWCOUNT;

    /* Verify insertion */
    IF DBO.CRF_CommentReviewExists(@CommentId, @ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: CRP_DeleteCommentReview
    Description: Removes a comment-review association from the Comment_Review table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment.
        @ReviewId (UNIQUEIDENTIFIER): ID of the review.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns: None (sets @Result to indicate success or failure).
*/
CREATE OR ALTER PROCEDURE CRP_DeleteCommentReview
    @CommentId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Check if comment-review pair exists */
    IF DBO.CRF_CommentReviewExists(@CommentId, @ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete comment-review pair */
    DELETE FROM [Comment_Review] WHERE commentId = @CommentId AND reviewId = @ReviewId;
    SET @Result = @@ROWCOUNT;

    /* Verify deletion */
    IF DBO.CRF_CommentReviewExists(@CommentId, @ReviewId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END;
END;
GO

/* 
    Procedure: CRP_DeleteCommentByReview
    Description: Removes all comment associations for a specified review from the Comment_Review table.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to remove comments for.
        @Result (INT OUTPUT): Number of rows affected (number of comments removed, 0 for failure).
    Returns: None (sets @Result to indicate number of rows affected).
*/
CREATE OR ALTER PROCEDURE CRP_DeleteCommentByReview
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify review existence */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END;

    /* Delete all comments for the review */
    DELETE FROM [Comment_Review] WHERE reviewId = @ReviewId;
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: CRP_GetAllCommentReview
    Description: Retrieves all comment-review associations from the Comment_Review table.
    Parameters: None
    Returns: Result set containing all comment-review pairs.
*/
CREATE OR ALTER PROCEDURE CRP_GetAllCommentReview
AS
BEGIN
    SET NOCOUNT ON;

    /* Select all comment-review pairs */
    SELECT * FROM [Comment_Review];
END;
GO

/* 
    Procedure: CRP_GetReviewsByComment
    Description: Retrieves all review IDs associated with a specified comment from the Comment_Review table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to query.
    Returns: Result set containing review IDs for the specified comment, or NULL if comment does not exist.
*/
CREATE OR ALTER PROCEDURE CRP_GetReviewsByComment
    @CommentId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate comment ID */
    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        SELECT NULL AS ReviewId;
        RETURN;
    END;

    /* Select review IDs for the comment */
    SELECT reviewId FROM [Comment_Review] WHERE commentId = @CommentId;
END;
GO

/* 
    Procedure: CRP_GetCommentsByReview
    Description: Retrieves all comment IDs associated with a specified review from the Comment_Review table.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to query.
    Returns: Result set containing comment IDs for the specified review, or NULL if review does not exist.
*/
CREATE OR ALTER PROCEDURE CRP_GetCommentsByReview
    @ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate review ID */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SELECT NULL AS CommentId;
        RETURN;
    END;

    /* Select comment IDs for the review */
    SELECT commentId FROM [Comment_Review] WHERE reviewId = @ReviewId;
END;
GO