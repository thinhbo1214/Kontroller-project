-- #Game_Service table functions
-- 1. Function to check if gameId and serviceName pair exists
CREATE OR ALTER FUNCTION GSF_GameServiceExists (
    @GameId UNIQUEIDENTIFIER,
    @ServiceName NVARCHAR(30)
)
RETURNS BIT
AS
BEGIN
    IF @GameId IS NULL OR @ServiceName IS NULL
    BEGIN
        RETURN 0; -- Return 0 if either parameter is NULL
    END;

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

-- 2. Function to get all services for a game
CREATE OR ALTER FUNCTION GSF_GetGameServicesByGameId (
    @GameId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
(
    SELECT serviceName AS ServiceName
    FROM [Game_Service]
    WHERE gameId = @GameId
);
GO

-- 3. Function to get all games for a service
CREATE OR ALTER FUNCTION GSF_GetGamesByServiceName (
    @ServiceName NVARCHAR(30)
)
RETURNS TABLE
AS
RETURN
(
    SELECT gameId AS GameId
    FROM [Game_Service]
    WHERE serviceName = @ServiceName
);
GO

-- 4. Function to check if serviceName is legal
CREATE OR ALTER FUNCTION GSF_IsServiceNameLegal (
    @ServiceName NVARCHAR(30)
)
RETURNS BIT
AS
BEGIN
    IF @ServiceName IS NULL
    BEGIN
        RETURN 0; -- Return 0 if ServiceName is NULL
    END;

    DECLARE @IsLegal BIT;

    SELECT @IsLegal = CASE 
        WHEN LEN(@ServiceName) < 1 OR LEN(@ServiceName) > 30 THEN 0
        WHEN @ServiceName LIKE '%[^a-zA-Z0-9._-]%' THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;
END;
GO

-- 5. Function to check if gameId and serviceName can be used
CREATE OR ALTER FUNCTION GSF_IsGameServiceUsable (
    @GameId UNIQUEIDENTIFIER,
    @ServiceName NVARCHAR(30)
)
RETURNS BIT
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0 OR 
       DBO.GSF_IsServiceNameLegal(@ServiceName) = 0 OR 
       DBO.GSF_GameServiceExists(@GameId, @ServiceName) = 1
    BEGIN
        RETURN 0; -- Return 0 if any condition is not met
    END;

    RETURN 1; -- Return 1 if GameId and ServiceName can be used
END;
GO
-- # User_Diary
CREATE OR ALTER FUNCTION UDF_UserDiaryExists (
    @UserId UNIQUEIDENTIFIER,
    @DiaryId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0 OR DBO.DF_DiaryIdExists(@DiaryId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM User_Diary 
                WHERE userId = @UserId AND diaryId = @DiaryId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

-- # User_List
CREATE OR ALTER FUNCTION ULF_UserListExists (
    @UserId UNIQUEIDENTIFIER,
    @ListId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0 OR DBO.LF_ListIdExists(@ListId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM User_List 
                WHERE userId = @UserId AND listId = @ListId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

-- # User_User
CREATE OR ALTER FUNCTION DBO.UUF_UserUserExists (
    @UserFollower UNIQUEIDENTIFIER,
    @UserFollowing UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @UserFollower IS NULL OR @UserFollowing IS NULL OR @UserFollower = @UserFollowing
        RETURN 0;

    RETURN (
        SELECT CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
        FROM User_User
        WHERE userFollower = @UserFollower AND userFollowing = @UserFollowing
    );
END;
GO

-- # User_Activity
CREATE OR ALTER FUNCTION UAF_UserActivityExists (
    @UserId UNIQUEIDENTIFIER,
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0 OR DBO.AF_ActivityIdExists(@ActivityId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM User_Activity
                WHERE userId = @UserId AND activityId = @ActivityId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

-- # Review_User
CREATE OR ALTER FUNCTION RUF_ReviewUserExists (
    @Author UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@Author) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE
            WHEN EXISTS (
                SELECT 1 FROM Review_User 
                WHERE author = @Author AND reviewId = @ReviewId
            ) THEN 1 ELSE 0
        END
    );
END;
GO

-- # Review_Rate
CREATE OR ALTER FUNCTION RRF_ReviewRateExists (
    @RateId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.RF_RateIdExists(@RateId) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM Review_Rate
                WHERE rateId = @RateId AND reviewId = @ReviewId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

-- # Review_Reaction
CREATE OR ALTER FUNCTION RRF_ReviewReactionExists (
    @ReactionId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM Review_Reaction
                WHERE reactionId = @ReactionId AND reviewId = @ReviewId
            ) THEN 1 ELSE 0
        END
    );
END;
GO

-- # Game_Review
CREATE OR ALTER FUNCTION GRF_GameReviewExists (
    @GameId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM Game_Review 
                WHERE gameId = @GameId AND reviewId = @ReviewId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

-- # Reaction_User
CREATE OR ALTER FUNCTION RUF_ReactionUserExists (
    @ReactionId UNIQUEIDENTIFIER,
    @Author UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@Author) = 0 OR DBO.RF_ReactionIdExists(@ReactionId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM Reaction_User 
                WHERE reactionId = @ReactionId AND author = @Author
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

-- # Rate_User
CREATE OR ALTER FUNCTION RUF_RateUserExists (
    @RateId UNIQUEIDENTIFIER,
    @Rater UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@Rater) = 0 OR DBO.RF_RateIdExists(@RateId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM Rate_User 
                WHERE rateId = @RateId AND rater = @Rater
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

-- # Rate_Game
CREATE OR ALTER FUNCTION RGF_RateGameExists (
    @RateId UNIQUEIDENTIFIER,
    @TargetGame UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.RF_RateIdExists(@RateId) = 0 OR DBO.GF_GameIdExists(@TargetGame) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM Rate_Game 
                WHERE rateId = @RateId AND targetGame = @TargetGame
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

-- # List_ListItem
CREATE OR ALTER FUNCTION LLF_ListListItemExists (
    @ListId UNIQUEIDENTIFIER,
    @ListItemId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0 OR DBO.LIF_ListItemIdExists(@ListItemId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM List_ListItem 
                WHERE listId = @ListId AND listItemId = @ListItemId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

-- #ListItem_Game
CREATE OR ALTER FUNCTION LIGF_ListItemGameExists (
    @ListItemId UNIQUEIDENTIFIER,
    @TargetGame UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0 OR DBO.GF_GameIdExists(@TargetGame) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM ListItem_Game 
                WHERE listItemId = @ListItemId AND targetGame = @TargetGame
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

-- # Commnet_User
CREATE OR ALTER FUNCTION CUF_CommentUserExists (
    @CommentId UNIQUEIDENTIFIER,
    @Author UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0 OR DBO.UF_UserIdExists(@Author) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM Comment_User 
                WHERE commentId = @CommentId AND author = @Author
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

-- # Comment_Reaction
CREATE OR ALTER FUNCTION CRF_CommentReactionExists (
    @CommentId UNIQUEIDENTIFIER,
    @ReactionId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0 OR DBO.RF_ReactionIdExists(@ReactionId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM Comment_Reaction 
                WHERE commentId = @CommentId AND reactionId = @ReactionId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO

-- # Comment_Review
CREATE OR ALTER FUNCTION CRF_CommentReviewExists (
    @CommentId UNIQUEIDENTIFIER,
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.CF_CommentExists(@CommentId) = 0 OR DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM Comment_Review 
                WHERE commentId = @CommentId AND reviewId = @ReviewId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO