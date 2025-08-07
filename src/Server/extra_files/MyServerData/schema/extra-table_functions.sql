/*
    Database: KontrollerDB
    Description: Database for a game management system, storing information about users, games, reviews, comments, ratings, lists, activities, diaries, and their relationships.
*/
USE KontrollerDB;
GO

/* 
    Function: GSF_GameServiceExists
    Description: Checks if a specified game ID and service name pair exists in the Game_Service table.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to check.
        @ServiceName (NVARCHAR(30)): Name of the service to check.
    Returns:
        BIT: 1 if the game ID and service name pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION GSF_GameServiceExists (
    @GameId UNIQUEIDENTIFIER,
    @ServiceName NVARCHAR(30)
)
RETURNS BIT
AS
BEGIN
    /* Validate input parameters */
    IF @GameId IS NULL OR @ServiceName IS NULL
    BEGIN
        RETURN 0; -- Return 0 if either parameter is NULL
    END;

    /* Check for existence of game-service pair */
    IF EXISTS (
        SELECT 1 
        FROM [Game_Service] 
        WHERE gameId = @GameId AND serviceName = @ServiceName
    )
    BEGIN
        RETURN 1; -- Return 1 if GameId and ServiceName pair exists
    END;

    RETURN 0; -- Return 0 if GameId and ServiceName pair does not exist
END;
GO

/* 
    Function: GSF_GetGameServicesByGameId
    Description: Retrieves all service names associated with a specified game ID.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to query.
    Returns:
        TABLE: A table containing service names for the specified game.
*/
CREATE OR ALTER FUNCTION GSF_GetGameServicesByGameId (
    @GameId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
(
    /* Select service names for the game */
    SELECT serviceName AS ServiceName
    FROM [Game_Service]
    WHERE gameId = @GameId
);
GO

/* 
    Function: GSF_GetGamesByServiceName
    Description: Retrieves all game IDs associated with a specified service name.
    Parameters:
        @ServiceName (NVARCHAR(30)): Name of the service to query.
    Returns:
        TABLE: A table containing game IDs for the specified service.
*/
CREATE OR ALTER FUNCTION GSF_GetGamesByServiceName (
    @ServiceName NVARCHAR(30)
)
RETURNS TABLE
AS
RETURN
(
    /* Select game IDs for the service */
    SELECT gameId AS GameId
    FROM [Game_Service]
    WHERE serviceName = @ServiceName
);
GO

/* 
    Function: GSF_IsServiceNameLegal
    Description: Checks if a service name is valid based on length and character constraints.
    Parameters:
        @ServiceName (NVARCHAR(30)): Service name to validate.
    Returns:
        BIT: 1 if the service name is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION GSF_IsServiceNameLegal (
    @ServiceName NVARCHAR(30)
)
RETURNS BIT
AS
BEGIN
    /* Check for NULL service name */
    IF @ServiceName IS NULL
    BEGIN
        RETURN 0; -- Return 0 if ServiceName is NULL
    END;

    DECLARE @IsLegal BIT;

    /* Validate service name length and characters */
    SELECT @IsLegal = CASE 
        WHEN LEN(@ServiceName) < 1 OR LEN(@ServiceName) > 30 THEN 0
        WHEN @ServiceName LIKE '%[^a-zA-Z0-9._-]%' THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;
END;
GO

/* 
    Function: GSF_IsGameServiceUsable
    Description: Checks if a game ID and service name pair can be used (valid and not already existing).
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to check.
        @ServiceName (NVARCHAR(30)): Name of the service to check.
    Returns:
        BIT: 1 if the game ID and service name can be used, 0 otherwise.
*/
CREATE OR ALTER FUNCTION GSF_IsGameServiceUsable (
    @GameId UNIQUEIDENTIFIER,
    @ServiceName NVARCHAR(30)
)
RETURNS BIT
AS
BEGIN
    /* Validate game ID, service name legality, and non-existence of pair */
    IF DBO.GF_GameIdExists(@GameId) = 0 OR 
       DBO.GSF_IsServiceNameLegal(@ServiceName) = 0 OR 
       DBO.GSF_GameServiceExists(@GameId, @ServiceName) = 1
    BEGIN
        RETURN 0; -- Return 0 if any condition is not met
    END;

    RETURN 1; -- Return 1 if GameId and ServiceName can be used
END;
GO

/* 
    Function: UDF_UserDiaryExists
    Description: Checks if a specified user ID and diary ID pair exists in the User_Diary table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to check.
        @DiaryId (UNIQUEIDENTIFIER): ID of the diary to check.
    Returns:
        BIT: 1 if the user-diary pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UDF_UserDiaryExists (
    @UserId UNIQUEIDENTIFIER,
    @DiaryId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate user and diary existence */
    IF DBO.UF_UserIdExists(@UserId) = 0 OR DBO.DF_DiaryIdExists(@DiaryId) = 0
        RETURN 0;

    /* Check for existence of user-diary pair */
    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM [User_Diary] 
                WHERE userId = @UserId AND diaryId = @DiaryId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

/* 
    Function: ULF_UserListExists
    Description: Checks if a specified user ID and list ID pair exists in the User_List table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to check.
        @ListId (UNIQUEIDENTIFIER): ID of the list to check.
    Returns:
        BIT: 1 if the user-list pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION ULF_UserListExists (
    @UserId UNIQUEIDENTIFIER,
    @ListId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate user and list existence */
    IF DBO.UF_UserIdExists(@UserId) = 0 OR DBO.LF_ListIdExists(@ListId) = 0
        RETURN 0;

    /* Check for existence of user-list pair */
    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM [User_List] 
                WHERE userId = @UserId AND listId = @ListId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

/* 
    Function: UUF_UserUserExists
    Description: Checks if a follower-following user pair exists in the User_User table.
    Parameters:
        @UserFollower (UNIQUEIDENTIFIER): ID of the follower user.
        @UserFollowing (UNIQUEIDENTIFIER): ID of the user being followed.
    Returns:
        BIT: 1 if the follower-following pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION DBO.UUF_UserUserExists (
    @UserFollower UNIQUEIDENTIFIER,
    @UserFollowing UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate both user IDs */
    IF DBO.UF_UserIdExists(@UserFollower) = 0 OR DBO.UF_UserIdExists(@UserFollowing) = 0
        RETURN 0;

    /* Check for existence of follower-following pair */
    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM [User_User]
                WHERE userFollower = @UserFollower AND userFollowing = @UserFollowing
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

/* 
    Function: UAF_UserActivityExists
    Description: Checks if a specified user ID and activity ID pair exists in the User_Activity table.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to check.
        @ActivityId (UNIQUEIDENTIFIER): ID of the activity to check.
    Returns:
        BIT: 1 if the user-activity pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UAF_UserActivityExists (
    @UserId UNIQUEIDENTIFIER,
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate user and activity existence */
    IF DBO.UF_UserIdExists(@UserId) = 0 OR DBO.AF_ActivityIdExists(@ActivityId) = 0
        RETURN 0;

    /* Check for existence of user-activity pair */
    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM [User_Activity]
                WHERE userId = @UserId AND activityId = @ActivityId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

/* 
    Function: RUF_ReviewUserExists
    Description: Checks if a specified author ID and review ID pair exists in the Review_User table.
    Parameters:
        @Author (UNIQUEIDENTIFIER): ID of the user who authored the review.
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to check.
    Returns:
        BIT: 1 if the author-review pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION RUF_ReviewUserExists (
    @Author UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate author and review existence */
    IF DBO.UF_UserIdExists(@Author) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN 0;

    /* Check for existence of author-review pair */
    RETURN (
        SELECT CASE
            WHEN EXISTS (
                SELECT 1 FROM [Review_User] 
                WHERE author = @Author AND reviewId = @ReviewId
            ) THEN 1 ELSE 0
        END
    );
END;
GO

/* 
    Function: RRF_ReviewReactionExists
    Description: Checks if a specified reaction ID and review ID pair exists in the Review_Reaction table.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction to check.
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to check.
    Returns:
        BIT: 1 if the reaction-review pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION RRF_ReviewReactionExists (
    @ReactionId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate reaction and review existence */
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN 0;

    /* Check for existence of reaction-review pair */
    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM [Review_Reaction]
                WHERE reactionId = @ReactionId AND reviewId = @ReviewId
            ) THEN 1 ELSE 0
        END
    );
END;
GO

/* 
    Function: GRF_GameReviewExists
    Description: Checks if a specified game ID and review ID pair exists in the Game_Review table.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to check.
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to check.
    Returns:
        BIT: 1 if the game-review pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION GRF_GameReviewExists (
    @GameId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate game and review existence */
    IF DBO.GF_GameIdExists(@GameId) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN 0;

    /* Check for existence of game-review pair */
    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM [Game_Review] 
                WHERE gameId = @GameId AND reviewId = @ReviewId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

/* 
    Function: RUF_ReactionUserExists
    Description: Checks if a specified reaction ID and author ID pair exists in the Reaction_User table.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction to check.
        @Author (UNIQUEIDENTIFIER): ID of the user who authored the reaction.
    Returns:
        BIT: 1 if the reaction-author pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION RUF_ReactionUserExists (
    @ReactionId UNIQUEIDENTIFIER,
    @Author UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate reaction and author existence */
    IF DBO.UF_UserIdExists(@Author) = 0 OR DBO.RF_ReactionIdExists(@ReactionId) = 0
        RETURN 0;

    /* Check for existence of reaction-author pair */
    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM [Reaction_User] 
                WHERE reactionId = @ReactionId AND author = @Author
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

/* 
    Function: LLF_ListListItemExists
    Description: Checks if a specified list ID and list item ID pair exists in the List_ListItem table.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to check.
        @ListItemId (UNIQUEIDENTIFIER): ID of the list item to check.
    Returns:
        BIT: 1 if the list-list item pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION LLF_ListListItemExists (
    @ListId UNIQUEIDENTIFIER,
    @ListItemId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate list and list item existence */
    IF DBO.LF_ListIdExists(@ListId) = 0 OR DBO.LIF_ListItemIdExists(@ListItemId) = 0
        RETURN 0;

    /* Check for existence of list-list item pair */
    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM [List_ListItem] 
                WHERE listId = @ListId AND listItemId = @ListItemId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

/* 
    Function: LIGF_ListItemGameExists
    Description: Checks if a specified list item ID and game ID pair exists in the ListItem_Game table.
    Parameters:
        @ListItemId (UNIQUEIDENTIFIER): ID of the list item to check.
        @TargetGame (UNIQUEIDENTIFIER): ID of the game to check.
    Returns:
        BIT: 1 if the list item-game pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION LIGF_ListItemGameExists (
    @ListItemId UNIQUEIDENTIFIER,
    @TargetGame UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate list item and game existence */
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0 OR DBO.GF_GameIdExists(@TargetGame) = 0
        RETURN 0;

    /* Check for existence of list item-game pair */
    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM [ListItem_Game] 
                WHERE listItemId = @ListItemId AND targetGame = @TargetGame
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

/* 
    Function: CUF_CommentUserExists
    Description: Checks if a specified comment ID and author ID pair exists in the Comment_User table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to check.
        @Author (UNIQUEIDENTIFIER): ID of the user who authored the comment.
    Returns:
        BIT: 1 if the comment-author pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION CUF_CommentUserExists (
    @CommentId UNIQUEIDENTIFIER,
    @Author UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate comment and author existence */
    IF DBO.CF_CommentIdExists(@CommentId) = 0 OR DBO.UF_UserIdExists(@Author) = 0
        RETURN 0;

    /* Check for existence of comment-author pair */
    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM [Comment_User] 
                WHERE commentId = @CommentId AND author = @Author
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

/* 
    Function: CRF_CommentReactionExists
    Description: Checks if a specified comment ID and reaction ID pair exists in the Comment_Reaction table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to check.
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction to check.
    Returns:
        BIT: 1 if the comment-reaction pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION CRF_CommentReactionExists (
    @CommentId UNIQUEIDENTIFIER,
    @ReactionId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate comment and reaction existence */
    IF DBO.CF_CommentIdExists(@CommentId) = 0 OR DBO.RF_ReactionIdExists(@ReactionId) = 0
        RETURN 0;

    /* Check for existence of comment-reaction pair */
    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM [Comment_Reaction] 
                WHERE commentId = @CommentId AND reactionId = @ReactionId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

/* 
    Function: CRF_CommentReviewExists
    Description: Checks if a specified comment ID and review ID pair exists in the Comment_Review table.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to check.
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to check.
    Returns:
        BIT: 1 if the comment-review pair exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION CRF_CommentReviewExists (
    @CommentId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    /* Validate comment and review existence */
    IF DBO.CF_CommentIdExists(@CommentId) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN 0;

    /* Check for existence of comment-review pair */
    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM [Comment_Review] 
                WHERE commentId = @CommentId AND reviewId = @ReviewId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO