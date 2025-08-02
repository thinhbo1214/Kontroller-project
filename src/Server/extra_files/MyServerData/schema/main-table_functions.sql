-- Function helpers
-- 1. Check URL legality
CREATE OR ALTER FUNCTION F_IsUrlLegal (
    @Url VARCHAR(255)
)
RETURNS BIT
AS
BEGIN
    IF @Url IS NULL
    BEGIN
        RETURN 0; -- Return 0 if URL is NULL
    END;

    IF CHARINDEX(' ', @Url) > 0
        RETURN 0; -- Return 0 if URL contains spaces

    IF LEN(@Url) > 255
        RETURN 0; -- Return 0 if URL exceeds maximum length

    IF @Url LIKE 'http://%' OR @Url LIKE 'https://%'
        RETURN 1; -- Return 1 if URL is legal

    RETURN 0; -- Return 0 if URL is not legal
END;
GO

-- #User table functions
-- 1. Function to check if userId exists
CREATE OR ALTER FUNCTION UF_UserIdExists (
    @UserId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @UserId IS NULL
    BEGIN
        RETURN 0; -- Return 0 if UserId is NULL
    END;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM Users WHERE userId = @UserId
                ) THEN 1 ELSE 0 END);
END;
GO

-- 2. Function to get user details by userId
CREATE OR ALTER FUNCTION UF_GetUserDetails (
    @UserId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN 
(
    SELECT userId AS UserId, username AS Username, email AS Email, avatar AS Avatar, isLoggedIn AS IsLoggedIn
    FROM [Users]
    WHERE userId = @UserId
);
GO

-- 3. Function to get username by userId
CREATE OR ALTER FUNCTION UF_GetUsername (
    @UserId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(100)
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if UserId does not exist
    END;

    DECLARE @Username VARCHAR(100);
    SELECT @Username = username FROM [Users] WHERE userId = @UserId;
        RETURN @Username;
END;
GO

-- 4. Function to get user email by userId
CREATE OR ALTER FUNCTION UF_GetEmail (
    @UserId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(100)
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if UserId does not exist
    END;

    DECLARE @Email VARCHAR(100);

    SELECT @Email = email
    FROM [Users]
    WHERE userId = @UserId;

    RETURN @Email;
END;
GO

-- 5. Function to get user avatar by userId
CREATE OR ALTER FUNCTION UF_GetUserAvatar (
    @UserId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(255)
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if UserId does not exist
    END;

    DECLARE @Avatar VARCHAR(255);

    SELECT @Avatar = avatar
    FROM [Users]
    WHERE userId = @UserId;

    RETURN @Avatar;
END;
GO

-- 6. Function to check if user is logged in
CREATE OR ALTER FUNCTION UF_IsUserLoggedIn (
    @UserId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RETURN 0; -- Return 0 if UserId does not exist
    END;

    DECLARE @LoggedIn BIT;
    SELECT @LoggedIn = isLoggedIn
    FROM [Users]
    WHERE userId = @UserId;

        RETURN @LoggedIn;
    END;
GO

-- 7 Function to check password legality
CREATE OR ALTER FUNCTION UF_IsPasswordLegal (
    @Password VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Password IS NULL
        RETURN 0;
        
    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Password) < 8 OR LEN(@Password) > 50 THEN 0
        WHEN @Password NOT LIKE '%[A-Z]%' THEN 0 -- At least one uppercase
        WHEN @Password NOT LIKE '%[a-z]%' THEN 0 -- At least one lowercase
        WHEN @Password NOT LIKE '%[0-9]%' THEN 0 -- At least one digit
        WHEN @Password NOT LIKE '%[!@#$%^&*()_+{}:<>?]%' THEN 0 -- At least one special char
        ELSE 1
    END;
    RETURN @IsLegal;
END;
GO

-- 8. Function to check username legality
CREATE OR ALTER FUNCTION UF_IsUsernameLegal (
    @Username VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Username IS NULL
    BEGIN
        RETURN 0; -- Return 0 if Username is NULL
    END;

    DECLARE @IsLegal BIT;

    SELECT @IsLegal = CASE 
        WHEN LEN(@Username) < 3 OR LEN(@Username) > 50 THEN 0
        WHEN @Username LIKE '%[^a-zA-Z0-9_-]%' THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;
END;
GO

-- 9. Function to check email legality
CREATE OR ALTER FUNCTION UF_IsEmailLegal (
    @Email VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Email IS NULL
    BEGIN
        RETURN 0; -- Return 0 if Email is NULL
    END;

    DECLARE @IsLegal BIT;

    SELECT @IsLegal = CASE 
        WHEN LEN(@Email) < 5 OR LEN(@Email) > 100 THEN 0
        WHEN @Email NOT LIKE '%_@__%.__%' THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;
END;
GO

-- 10. Function to check avatar legality
CREATE OR ALTER FUNCTION UF_IsAvatarLegal (
    @Avatar VARCHAR(255)
)
RETURNS BIT
AS
BEGIN
    RETURN DBO.F_IsUrlLegal(@Avatar);
END;
GO

-- 11. Function to check if a username exists
CREATE OR ALTER FUNCTION UF_UsernameExists (
    @Username VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Exists BIT;

    SELECT @Exists = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM [Users]
    WHERE username = @Username;

    RETURN @Exists;
END;
GO

-- 12. Function to check if an email exists
CREATE OR ALTER FUNCTION UF_EmailExists (
    @Email VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Exists BIT;

    SELECT @Exists = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM [Users]
    WHERE email = @Email;

    RETURN @Exists;
END;
GO

-- 13. Function to check password match
CREATE OR ALTER FUNCTION UF_IsPasswordMatch (
    @UserId UNIQUEIDENTIFIER,
    @Password VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RETURN 0; -- Return 0 if UserId does not exist
    END;

    DECLARE @Match BIT;

    SELECT @Match = CASE WHEN password_hash = HASHBYTES('SHA2_256', @Password) THEN 1 ELSE 0 END
    FROM [Users]
    WHERE userId = @UserId;

    RETURN @Match;
END;
GO

-- 14. Function to check if a username can be used
CREATE OR ALTER FUNCTION UF_IsUsernameUsable (
    @Username VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_IsUsernameLegal(@Username) = 0 OR DBO.UF_UsernameExists(@Username) = 1
    BEGIN
        RETURN 0; -- Return 0 if Username is not legal or if it already exists
    END;

    RETURN 1; -- Return 1 if Username is usable
END;
GO

-- 15. Function to check if an email can be used
CREATE OR ALTER FUNCTION UF_IsEmailUsable (
    @Email VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_IsEmailLegal(@Email) = 0 OR DBO.UF_EmailExists(@Email) = 1
    BEGIN
        RETURN 0; -- Return 0 if Email is not legal or if it already exists
    END;

    RETURN 1; -- Return 1 if Email is usable
END;
GO

-- 16. Function to check if user input is valid
CREATE OR ALTER FUNCTION UF_IsUserInputValid (
    @Username VARCHAR(100),
    @Password VARCHAR(100),
    @Email VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_IsUsernameUsable(@Username) = 0 OR 
       DBO.UF_IsPasswordLegal(@Password) = 0 OR 
       DBO.UF_IsEmailUsable(@Email) = 0
    BEGIN
        RETURN 0; -- Return 0 if any input is invalid
    END;

    RETURN 1; -- Return 1 if all inputs are valid
END;
GO

-- #Games table functions
-- 1. Function to check if gameId exists
CREATE OR ALTER FUNCTION GF_GameIdExists (
    @GameId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @GameId IS NULL
    BEGIN
        RETURN 0; -- Return 0 if GameId is NULL
    END;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM Games WHERE gameId = @GameId
                ) THEN 1 ELSE 0 END);

END;
GO

CREATE OR ALTER FUNCTION GF_GetGameAllInfo (
    @GameId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
(
    SELECT gameId AS GameId, title AS Title, descriptions AS Descriptions, genre AS Genre, 
           avgRating AS AvgRating, poster AS Poster, backdrop AS Backdrop, details AS Details
    FROM [Games]
    WHERE gameId = @GameId
);
GO
-- 2. Function to get game title by gameId
CREATE OR ALTER FUNCTION GF_GetGameTitle (
    @GameId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN
DECLARE @Title NVARCHAR(100);
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if GameId does not exist
    END;

    SELECT @Title = title FROM [Games] WHERE gameId = @GameId;

    RETURN @Title;
END;
GO

-- 3. Function to get game genre by gameId
CREATE OR ALTER FUNCTION GF_GetGameGenre (
    @GameId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN
DECLARE @Genre NVARCHAR(100);
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if GameId does not exist
    END;

    SELECT @Genre = genre FROM [Games] WHERE gameId = @GameId;

    RETURN @Genre;
END;
GO

-- 4. Function to get game average rating by gameId
CREATE OR ALTER FUNCTION GF_GetGameAvgRating (
    @GameId UNIQUEIDENTIFIER
)
RETURNS DECIMAL(4,2)
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if GameId does not exist
    END;

    DECLARE @AvgRating DECIMAL(4,2);
    SELECT @AvgRating = avgRating FROM [Games] WHERE gameId = @GameId;
    RETURN @AvgRating;
END;
GO

-- 5. Function to get game poster by gameId
CREATE OR ALTER FUNCTION GF_GetGamePoster (
    @GameId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(255)
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if GameId does not exist
    END;

    DECLARE @Poster VARCHAR(255);
    SELECT @Poster = poster FROM [Games] WHERE gameId = @GameId;

    RETURN @Poster;
END;
GO

-- 6. Function to get game backdrop by gameId
CREATE OR ALTER FUNCTION GF_GetGameBackdrop (
    @GameId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(255)
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if GameId does not exist
    END;

    DECLARE @Backdrop VARCHAR(255);
    SELECT @Backdrop = backdrop FROM [Games] WHERE gameId = @GameId;

    RETURN @Backdrop;
END;
GO

-- 7. Function to get game details by gameId
CREATE OR ALTER FUNCTION GF_GetGameDetails (
    @GameId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if GameId does not exist
    END;

    DECLARE @Details NVARCHAR(MAX);
    SELECT @Details = details FROM [Games] WHERE gameId = @GameId;

    RETURN @Details;
END;
GO

-- 8. Function to get description by gameId
CREATE OR ALTER FUNCTION GF_GetGameDescription (
    @GameId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if GameId does not exist
    END;

    DECLARE @Description NVARCHAR(MAX);
    SELECT @Description = descriptions FROM [Games] WHERE gameId = @GameId;

    RETURN @Description;
END;
GO

-- 9. Function to get all services for a game
CREATE OR ALTER FUNCTION GF_GetGameServices (
    @GameId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
(
    SELECT serviceName AS ServiceName
    FROM Game_Service
    WHERE gameId = @GameId
);
GO

-- 10. Function to check title legality
CREATE OR ALTER FUNCTION GF_IsGameTitleLegal (
    @Title NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Title IS NULL
    BEGIN
        RETURN 0; -- Return 0 if Title is NULL
    END;

    DECLARE @IsLegal BIT;

    SELECT @IsLegal = CASE 
        WHEN LEN(@Title) < 1 OR LEN(@Title) > 100 THEN 0
        WHEN @Title LIKE '%[^a-zA-Z0-9._-]%' THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;
END;
GO

-- 11. Function to check genre legality
CREATE OR ALTER FUNCTION GF_IsGameGenreLegal (
    @Genre NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Genre IS NULL
    BEGIN
        RETURN 0; -- Return 0 if Genre is NULL
    END;

    DECLARE @IsLegal BIT;

    SELECT @IsLegal = CASE 
        WHEN LEN(@Genre) < 1 OR LEN(@Genre) > 100 THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;
END;
GO

-- 12. Function to check description legality
CREATE OR ALTER FUNCTION GF_IsGameDescriptionLegal (
    @Description NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    IF @Description IS NULL
    BEGIN
        RETURN 0; -- Return 0 if Description is NULL
    END;

    DECLARE @IsLegal BIT;

    SELECT @IsLegal = CASE 
        WHEN LEN(@Description) < 1 OR LEN(@Description) > 4000 THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;
END;
GO

-- 13. Function to check details legality
CREATE OR ALTER FUNCTION GF_IsGameDetailsLegal (
    @Details NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    IF @Details IS NULL
    BEGIN
        RETURN 0; -- Return 0 if Details is NULL
    END;

    DECLARE @IsLegal BIT;

    SELECT @IsLegal = CASE 
        WHEN LEN(@Details) < 1 OR LEN(@Details) > 4000 THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;
END;
GO

-- 14. Function to check poster legality
CREATE OR ALTER FUNCTION GF_IsGamePosterLegal (
    @Poster VARCHAR(255)
)
RETURNS BIT
AS
BEGIN
    RETURN DBO.F_IsUrlLegal(@Poster);
END;
GO

-- 15. Function to check backdrop legality
CREATE OR ALTER FUNCTION GF_IsGameBackdropLegal (
    @Backdrop VARCHAR(255)
)
RETURNS BIT
AS
BEGIN
    RETURN DBO.F_IsUrlLegal(@Backdrop);
END;
GO

-- 16. Function to check if game input is valid
CREATE OR ALTER FUNCTION GF_IsGameInputValid (
    @Title NVARCHAR(100),
    @Genre NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @Details NVARCHAR(MAX),
    @Poster VARCHAR(255),
    @Backdrop VARCHAR(255)
)
RETURNS BIT
AS
BEGIN
    IF DBO.GF_IsGameTitleLegal(@Title) = 0 OR 
       DBO.GF_IsGameGenreLegal(@Genre) = 0 OR 
       DBO.GF_IsGameDescriptionLegal(@Description) = 0 OR 
       DBO.GF_IsGameDetailsLegal(@Details) = 0 OR 
       DBO.GF_IsGamePosterLegal(@Poster) = 0 OR 
       DBO.GF_IsGameBackdropLegal(@Backdrop) = 0
    BEGIN
        RETURN 0; -- Return 0 if any input is invalid
    END;

    RETURN 1; -- Return 1 if all inputs are valid
END;
GO

-- #Review table function
-- 1. Function to check if review exists
CREATE OR ALTER FUNCTION RF_ReviewIdExists (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN 
    IF @ReviewId IS NULL
    BEGIN
        RETURN 0; -- Return 0 if ReviewId is NULL
    END;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM Reviews WHERE reviewId = @ReviewId
                ) THEN 1 ELSE 0 END);
END;
GO

-- 2. Function to get review by reviewId
CREATE OR ALTER FUNCTION RF_GetReview (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN(
    SELECT * FROM [Reviews] WHERE ReviewId = @ReviewId
)
GO

-- 3. Function to get content by reviewId
CREATE OR ALTER FUNCTION RF_GetContent (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if ReviewId does not exist
    END;

    DECLARE @Content NVARCHAR(MAX);
    SELECT @Content = Content FROM [Reviews] WHERE ReviewId = @ReviewId;
    RETURN @Content;
END;
GO

-- 4. Function to get rating by reviewId
CREATE OR ALTER FUNCTION RF_GetRating (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS DECIMAL(4,2)
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if ReviewId does not exist
    END;

    DECLARE @Rating DECIMAL(4,2);
    SELECT @Rating = Rating FROM [Reviews] WHERE ReviewId = @ReviewId;
    RETURN @Rating;
END;
GO

-- 5. Function to get dateCreated by reviewId
CREATE OR ALTER FUNCTION RF_GetDateCreated (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if ReviewId does not exist
    END;

    DECLARE @DateCreated DATETIME;
    SELECT @DateCreated = DateCreated FROM [Reviews] WHERE ReviewId = @ReviewId;
    RETURN @DateCreated;
END;
GO

-- 6. Function to check content legality
CREATE OR ALTER FUNCTION RF_IsContentLegality (
    @Content NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    IF @Content IS NULL OR @Content = ''
    BEGIN
        RETURN 0; -- Return 0 if content is empty or null
    END;

    DECLARE @IsLegal BIT;
        SELECT @IsLegal = CASE 
        WHEN LEN(@Content) < 1 OR LEN(@Content) > 4000 THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;  
END;
GO

-- 7. Function to check rating legality
CREATE OR ALTER FUNCTION RF_IsRatingLegality (
    @Rating DECIMAL(4,2)
)
RETURNS BIT
AS
BEGIN
    IF @Rating IS NULL OR @Rating < 0 OR @Rating > 10
    BEGIN
        RETURN 0; -- Return 0 if rating is invalid
    END;

    RETURN 1;
END;
GO

-- #Comment table functions

-- 1. Function to check if comment exists
CREATE OR ALTER FUNCTION CF_CommentIdExists (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN 
    IF @CommentId IS NULL
        RETURN 0;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM Comments WHERE commentId = @CommentId
                ) THEN 1 ELSE 0 END);
END;
GO

-- 2. Function to get comment by commentId
CREATE OR ALTER FUNCTION CF_GetComment (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM Comments WHERE commentId = @CommentId
);
GO

-- 3. Function to get content by commentId
CREATE OR ALTER FUNCTION CF_GetContent (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0
        RETURN NULL;

    DECLARE @Content NVARCHAR(MAX);
    SELECT @Content = content FROM Comments WHERE commentId = @CommentId;
    RETURN @Content;
END;
GO

-- 4. Function to get created_at by commentId
CREATE OR ALTER FUNCTION CF_GetCreatedAt (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0
        RETURN NULL;

    DECLARE @CreatedAt DATETIME;
    SELECT @CreatedAt = created_at FROM Comments WHERE commentId = @CommentId;
    RETURN @CreatedAt;
END;
GO

-- 5. Function to check content legality
CREATE OR ALTER FUNCTION CF_IsContentLegality (
    @Content NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    IF @Content IS NULL OR @Content = ''
    BEGIN
        RETURN 0;
    END;

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Content) < 1 OR LEN(@Content) > 4000 THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;
END;
GO

-- #Rate table functions

-- 1. Function to check if rate exists
CREATE OR ALTER FUNCTION RF_RateIdExists (
    @RateId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN 
    IF @RateId IS NULL
        RETURN 0;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM Rates WHERE rateId = @RateId
                ) THEN 1 ELSE 0 END);
END;
GO

-- 2. Function to get rate by rateId
CREATE OR ALTER FUNCTION RF_GetRate (
    @RateId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM Rates WHERE rateId = @RateId
);
GO

-- 3. Function to get rate value
CREATE OR ALTER FUNCTION RF_GetValue (
    @RateId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.RF_RateIdExists(@RateId) = 0
        RETURN NULL;

    DECLARE @Value INT;
    SELECT @Value = rateValue FROM Rates WHERE rateId = @RateId;
    RETURN @Value;
END;
GO

-- 4. Function to check rate legality
CREATE OR ALTER FUNCTION RF_IsRateLegal (
    @RateValue INT
)
RETURNS BIT
AS
BEGIN
    IF @RateValue IS NULL OR @RateValue < 0 OR @RateValue > 10
        RETURN 0;

    RETURN 1;
END;
GO

-- #List table functions

-- 1. Function to check if list exists
CREATE OR ALTER FUNCTION LF_ListIdExists (
    @ListId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN 
    IF @ListId IS NULL
        RETURN 0;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM Lists WHERE listId = @ListId
                ) THEN 1 ELSE 0 END);
END;
GO

-- 2. Function to get list by listId
CREATE OR ALTER FUNCTION LF_GetList (
    @ListId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM Lists WHERE listId = @ListId
);
GO

-- 3. Function to get name by listId
CREATE OR ALTER FUNCTION LF_GetName (
    @ListId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0
        RETURN NULL;

    DECLARE @_Name NVARCHAR(100);
    SELECT @_Name = _name FROM Lists WHERE listId = @ListId;
    RETURN @_Name;
END;
GO

-- 4. Function to get descriptions by listId
CREATE OR ALTER FUNCTION LF_GetDescriptions (
    @ListId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0
        RETURN NULL;

    DECLARE @Descriptions NVARCHAR(MAX);
    SELECT @Descriptions = descriptions FROM Lists WHERE listId = @ListId;
    RETURN @Descriptions;
END;
GO

-- 5. Function to get created date
CREATE OR ALTER FUNCTION LF_GetCreatedAt (
    @ListId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0
        RETURN NULL;

    DECLARE @CreatedAt DATETIME;
    SELECT @CreatedAt = created_at FROM Lists WHERE listId = @ListId;
    RETURN @CreatedAt;
END;
GO

-- 6. Function to check name legality
CREATE OR ALTER FUNCTION LF_IsNameLegal (
    @Name NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Name IS NULL OR @Name = ''
        RETURN 0;

    RETURN 1;
END;
GO

-- 7. Function to check description legality
CREATE OR ALTER FUNCTION LF_IsDescriptionLegal (
    @Description NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    IF @Description IS NULL OR @Description = ''
    BEGIN
        RETURN 0;
    END;

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Description) < 1 OR LEN(@Description) > 4000 THEN 0
    ELSE 1
    END;

    RETURN @IsLegal;  


    RETURN 1;
END;
GO

-- 1. Function to check if listItemId exists
CREATE OR ALTER FUNCTION LIF_ListItemIdExists (
    @ListItemId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @ListItemId IS NULL RETURN 0;

    DECLARE @Exists BIT;
    SELECT @Exists = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM List_items
    WHERE listItemId = @ListItemId;

    RETURN @Exists;
END;
GO

-- 2. Function to get full row by ID
CREATE OR ALTER FUNCTION LIF_GetListItem (
    @ListItemId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM List_items
    WHERE listItemId = @ListItemId
);
GO

-- 3. Function to get title by ID
CREATE OR ALTER FUNCTION LIF_GetTitle (
    @ListItemId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0
        RETURN NULL;

    DECLARE @Result NVARCHAR(100) = NULL;

    SELECT @Result = title
    FROM List_items
    WHERE listItemId = @ListItemId;

    RETURN @Result;
END;
GO

-- 4. Function to check if title is legal
CREATE OR ALTER FUNCTION LIF_IsTitleLegal (
    @Title NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Title IS NULL OR LEN(@Title) = 0 RETURN 0;
    RETURN 1;
END;
GO

-- 1. Function to check if activityId exists
CREATE OR ALTER FUNCTION AF_ActivityIdExists (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @ActivityId IS NULL RETURN 0;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM Activities WHERE activityId = @ActivityId
                ) THEN 1 ELSE 0 END);
END;
GO

-- 2. Function to get full row
CREATE OR ALTER FUNCTION AF_GetActivity (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
    SELECT *
    FROM Activities
    WHERE activityId = @ActivityId;
GO

-- 3. Function to get content
CREATE OR ALTER FUNCTION AF_GetContent (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0 RETURN NULL;

    DECLARE @Content NVARCHAR(MAX);
    SELECT @Content = content
    FROM Activities
    WHERE activityId = @ActivityId;

    RETURN @Content;
END;
GO

-- 4. Function to get dateDo
CREATE OR ALTER FUNCTION AF_GetDateDo (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0 RETURN NULL;

    DECLARE @Date DATETIME;
    SELECT @Date = dateDo
    FROM Activities
    WHERE activityId = @ActivityId;

    RETURN @Date;
END;
GO

-- 5. Function to check if content is legal
CREATE OR ALTER FUNCTION AF_IsContentLegal (
    @Content NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    IF @Content IS NULL OR @Content = ''
        RETURN 0;

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Content) < 1 OR LEN(@Content) > 4000 THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;
END;
GO

-- 1. Function to check if diaryId exists
CREATE OR ALTER FUNCTION DF_DiaryIdExists (
    @DiaryId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @DiaryId IS NULL
        RETURN 0;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM Diaries WHERE diaryId = @DiaryId
                ) THEN 1 ELSE 0 END);
END;
GO

-- 2. Function to get full diary row
CREATE OR ALTER FUNCTION DF_GetDiary (
    @DiaryId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
    SELECT * FROM Diaries WHERE diaryId = @DiaryId;
GO

-- 3. Function to get dateLogged
CREATE OR ALTER FUNCTION DF_GetDateLogged (
    @DiaryId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
        RETURN NULL;

    DECLARE @Date DATETIME;
    SELECT @Date = dateLogged FROM Diaries WHERE diaryId = @DiaryId;
    RETURN @Date;
END;
GO

-- 1. Function to check if reactionId exists
CREATE OR ALTER FUNCTION RF_ReactionIdExists (
    @ReactionId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @ReactionId IS NULL RETURN 0;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM Reactions WHERE reactionId = @ReactionId
                ) THEN 1 ELSE 0 END);
END;
GO

-- 2. Function to check if reactionType is legal
CREATE OR ALTER FUNCTION RF_IsReactionTypeLegal (
    @ReactionType INT
)
RETURNS BIT
AS
BEGIN
    IF @ReactionType IS NULL RETURN 0;

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN @ReactionType >= 0 AND @ReactionType <= 3 THEN 1
        ELSE 0
    END;

    RETURN @IsLegal;
END;
GO

-- 3. Function to get full row
CREATE OR ALTER FUNCTION RF_GetReaction (
    @ReactionId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM Reactions
    WHERE reactionId = @ReactionId
);
GO

-- 4. Function to get reactionType
CREATE OR ALTER FUNCTION RF_GetReactionType (
    @ReactionId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0 RETURN NULL;

    DECLARE @ReactionType INT;
    SELECT @ReactionType = reactionType FROM Reactions WHERE reactionId = @ReactionId;

    RETURN @ReactionType;
END;
GO

-- 5. Function to get dateDo
CREATE OR ALTER FUNCTION RF_GetDateDo (
    @ReactionId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0 RETURN NULL;

    DECLARE @DateDo DATETIME;
    SELECT @DateDo = dateDo FROM Reactions WHERE reactionId = @ReactionId;

    RETURN @DateDo;
END;
GO