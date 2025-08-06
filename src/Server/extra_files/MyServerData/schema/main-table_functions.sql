/*
    Database: KontrollerDB
    Description: Database for a game management system, storing information about users, games, reviews, comments, ratings, lists, activities, diaries, and their relationships.
*/
USE KontrollerDB;
GO

/* 
    Function: HF_IsUrlLegal
    Description: Checks if a URL is valid (starts with http:// or https://, no spaces, max 255 characters).
    Parameters:
        @Url (VARCHAR(255)): The URL to validate.
    Returns:
        BIT: 1 if the URL is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION HF_IsUrlLegal (
    @Url VARCHAR(255)
)
RETURNS BIT
AS
BEGIN
    IF @Url IS NULL
        RETURN 0; -- Return 0 if URL is NULL

    IF CHARINDEX(' ', @Url) > 0
        RETURN 0; -- Return 0 if URL contains spaces

    IF LEN(@Url) > 255
        RETURN 0; -- Return 0 if URL exceeds maximum length

    IF @Url LIKE 'http://%' OR @Url LIKE 'https://%'
        RETURN 1; -- Return 1 if URL is valid

    RETURN 0; -- Return 0 if URL is invalid
END;
GO

/* 
    Section: User Table Functions
*/

/* 
    Function: UF_UserIdExists
    Description: Checks if a user exists based on their userId.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to check.
    Returns:
        BIT: 1 if the user exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_UserIdExists (
    @UserId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @UserId IS NULL
        RETURN 0; -- Return 0 if UserId is NULL

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM Users WHERE userId = @UserId
                ) THEN 1 ELSE 0 END);
END;
GO

/* 
    Function: UF_GetUserDetails
    Description: Retrieves all details for a user based on their userId.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to query.
    Returns:
        TABLE: A table containing userId, username, email, avatar, and isLoggedIn.
*/
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

/* 
    Function: UF_GetUsername
    Description: Retrieves the username for a given userId.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to query.
    Returns:
        VARCHAR(100): The username if the user exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION UF_GetUsername (
    @UserId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(100)
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
        RETURN NULL; -- Return NULL if UserId does not exist

    DECLARE @Username VARCHAR(100);
    SELECT @Username = username FROM [Users] WHERE userId = @UserId;
    RETURN @Username;
END;
GO

/* 
    Function: UF_GetEmail
    Description: Retrieves the email for a given userId.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to query.
    Returns:
        VARCHAR(100): The email if the user exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION UF_GetEmail (
    @UserId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(100)
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
        RETURN NULL; -- Return NULL if UserId does not exist

    DECLARE @Email VARCHAR(100);
    SELECT @Email = email FROM [Users] WHERE userId = @UserId;
    RETURN @Email;
END;
GO

/* 
    Function: UF_GetUserAvatar
    Description: Retrieves the avatar URL for a given userId.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to query.
    Returns:
        VARCHAR(255): The avatar URL if the user exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION UF_GetUserAvatar (
    @UserId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(255)
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
        RETURN NULL; -- Return NULL if UserId does not exist

    DECLARE @Avatar VARCHAR(255);
    SELECT @Avatar = avatar FROM [Users] WHERE userId = @UserId;
    RETURN @Avatar;
END;
GO

/* 
    Function: UF_IsUserLoggedIn
    Description: Checks if a user is currently logged in.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to check.
    Returns:
        BIT: 1 if the user is logged in, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_IsUserLoggedIn (
    @UserId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
        RETURN 0; -- Return 0 if UserId does not exist

    DECLARE @LoggedIn BIT;
    SELECT @LoggedIn = isLoggedIn FROM [Users] WHERE userId = @UserId;
    RETURN @LoggedIn;
END;
GO

/* 
    Function: UF_IsPasswordLegal
    Description: Checks if a password meets security requirements (8-50 characters, includes uppercase, lowercase, digit, and special character).
    Parameters:
        @Password (VARCHAR(100)): The password to validate.
    Returns:
        BIT: 1 if the password is valid, 0 otherwise.
*/
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

/* 
    Function: UF_IsUsernameLegal
    Description: Checks if a username is valid (3-50 characters, alphanumeric with _-).
    Parameters:
        @Username (VARCHAR(100)): The username to validate.
    Returns:
        BIT: 1 if the username is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_IsUsernameLegal (
    @Username VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Username IS NULL
        RETURN 0; -- Return 0 if Username is NULL

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Username) < 3 OR LEN(@Username) > 50 THEN 0
        WHEN @Username LIKE '%[^a-zA-Z0-9_-]%' THEN 0
        ELSE 1
    END;
    RETURN @IsLegal;
END;
GO

/* 
    Function: UF_IsEmailLegal
    Description: Checks if an email is valid (5-100 characters, basic email format).
    Parameters:
        @Email (VARCHAR(100)): The email to validate.
    Returns:
        BIT: 1 if the email is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_IsEmailLegal (
    @Email VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Email IS NULL
        RETURN 0; -- Return 0 if Email is NULL

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Email) < 5 OR LEN(@Email) > 100 THEN 0
        WHEN @Email NOT LIKE '%_@__%.__%' THEN 0
        ELSE 1
    END;
    RETURN @IsLegal;
END;
GO

/* 
    Function: UF_IsAvatarLegal
    Description: Checks if an avatar URL is valid by reusing HF_IsUrlLegal.
    Parameters:
        @Avatar (VARCHAR(255)): The avatar URL to validate.
    Returns:
        BIT: 1 if the avatar URL is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_IsAvatarLegal (
    @Avatar VARCHAR(255)
)
RETURNS BIT
AS
BEGIN
    RETURN DBO.HF_IsUrlLegal(@Avatar);
END;
GO

/* 
    Function: UF_UsernameExists
    Description: Checks if a username already exists in the Users table.
    Parameters:
        @Username (VARCHAR(100)): The username to check.
    Returns:
        BIT: 1 if the username exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_UsernameExists (
    @Username VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    RETURN CASE WHEN EXISTS (SELECT 1 FROM [Users] WHERE username = @Username) THEN 1 ELSE 0 END;
END;
GO

/* 
    Function: UF_EmailExists
    Description: Checks if an email already exists in the Users table.
    Parameters:
        @Email (VARCHAR(100)): The email to check.
    Returns:
        BIT: 1 if the email exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_EmailExists (
    @Email VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    RETURN CASE WHEN EXISTS (SELECT 1 FROM [Users] WHERE email = @Email) THEN 1 ELSE 0 END;
END;
GO

/* 
    Function: UF_IsPasswordMatch
    Description: Checks if a provided password matches the stored hash for a user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to check.
        @Password (VARCHAR(100)): The password to verify.
    Returns:
        BIT: 1 if the password matches, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_IsPasswordMatch (
    @UserId UNIQUEIDENTIFIER,
    @Password VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
        RETURN 0; -- Return 0 if UserId does not exist

    DECLARE @Match BIT;
    SELECT @Match = CASE WHEN password_hash = HASHBYTES('SHA2_256', @Password) THEN 1 ELSE 0 END
    FROM [Users]
    WHERE userId = @UserId;
    RETURN @Match;
END;
GO

/* 
    Function: UF_IsUsernameUsable
    Description: Checks if a username is valid and not already in use.
    Parameters:
        @Username (VARCHAR(100)): The username to check.
    Returns:
        BIT: 1 if the username is usable, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_IsUsernameUsable (
    @Username VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_IsUsernameLegal(@Username) = 0 OR DBO.UF_UsernameExists(@Username) = 1
        RETURN 0; -- Return 0 if Username is not legal or already exists

    RETURN 1; -- Return 1 if Username is usable
END;
GO

/* 
    Function: UF_IsEmailUsable
    Description: Checks if an email is valid and not already in use.
    Parameters:
        @Email (VARCHAR(100)): The email to check.
    Returns:
        BIT: 1 if the email is usable, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_IsEmailUsable (
    @Email VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_IsEmailLegal(@Email) = 0 OR DBO.UF_EmailExists(@Email) = 1
        RETURN 0; -- Return 0 if Email is not legal or already exists

    RETURN 1; -- Return 1 if Email is usable
END;
GO

/* 
    Function: UF_IsUserInputValid
    Description: Checks if user input (username, password, email) is valid and usable.
    Parameters:
        @Username (VARCHAR(100)): The username to validate.
        @Password (VARCHAR(100)): The password to validate.
        @Email (VARCHAR(100)): The email to validate.
    Returns:
        BIT: 1 if all inputs are valid, 0 otherwise.
*/
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
        RETURN 0; -- Return 0 if any input is invalid

    RETURN 1; -- Return 1 if all inputs are valid
END;
GO

/* 
    Section: Games Table Functions
*/

/* 
    Function: GF_GameIdExists
    Description: Checks if a game exists based on its gameId.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): The game ID to check.
    Returns:
        BIT: 1 if the game exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION GF_GameIdExists (
    @GameId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @GameId IS NULL
        RETURN 0; -- Return 0 if GameId is NULL

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM Games WHERE gameId = @GameId
                ) THEN 1 ELSE 0 END);
END;
GO

/* 
    Function: GF_GetGameAllInfo
    Description: Retrieves all details for a game based on its gameId.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): The game ID to query.
    Returns:
        TABLE: A table containing gameId, title, descriptions, genre, avgRating, poster, backdrop, and details.
*/
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

/* 
    Function: GF_GetGameTitle
    Description: Retrieves the title for a given gameId.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): The game ID to query.
    Returns:
        NVARCHAR(100): The game title if the game exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION GF_GetGameTitle (
    @GameId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
        RETURN NULL; -- Return NULL if GameId does not exist

    DECLARE @Title NVARCHAR(100);
    SELECT @Title = title FROM [Games] WHERE gameId = @GameId;
    RETURN @Title;
END;
GO

/* 
    Function: GF_GetGameGenre
    Description: Retrieves the genre for a given gameId.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): The game ID to query.
    Returns:
        NVARCHAR(100): The game genre if the game exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION GF_GetGameGenre (
    @GameId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
        RETURN NULL; -- Return NULL if GameId does not exist

    DECLARE @Genre NVARCHAR(100);
    SELECT @Genre = genre FROM [Games] WHERE gameId = @GameId;
    RETURN @Genre;
END;
GO

/* 
    Function: GF_GetGameAvgRating
    Description: Retrieves the average rating for a given gameId.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): The game ID to query.
    Returns:
        DECIMAL(4,2): The average rating if the game exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION GF_GetGameAvgRating (
    @GameId UNIQUEIDENTIFIER
)
RETURNS DECIMAL(4,2)
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
        RETURN NULL; -- Return NULL if GameId does not exist

    DECLARE @AvgRating DECIMAL(4,2);
    SELECT @AvgRating = avgRating FROM [Games] WHERE gameId = @GameId;
    RETURN @AvgRating;
END;
GO

/* 
    Function: GF_GetGamePoster
    Description: Retrieves the poster URL for a given gameId.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): The game ID to query.
    Returns:
        VARCHAR(255): The poster URL if the game exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION GF_GetGamePoster (
    @GameId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(255)
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
        RETURN NULL; -- Return NULL if GameId does not exist

    DECLARE @Poster VARCHAR(255);
    SELECT @Poster = poster FROM [Games] WHERE gameId = @GameId;
    RETURN @Poster;
END;
GO

/* 
    Function: GF_GetGameBackdrop
    Description: Retrieves the backdrop URL for a given gameId.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): The game ID to query.
    Returns:
        VARCHAR(255): The backdrop URL if the game exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION GF_GetGameBackdrop (
    @GameId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(255)
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
        RETURN NULL; -- Return NULL if GameId does not exist

    DECLARE @Backdrop VARCHAR(255);
    SELECT @Backdrop = backdrop FROM [Games] WHERE gameId = @GameId;
    RETURN @Backdrop;
END;
GO

/* 
    Function: GF_GetGameDetails
    Description: Retrieves the details for a given gameId.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): The game ID to query.
    Returns:
        NVARCHAR(MAX): The game details if the game exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION GF_GetGameDetails (
    @GameId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
        RETURN NULL; -- Return NULL if GameId does not exist

    DECLARE @Details NVARCHAR(MAX);
    SELECT @Details = details FROM [Games] WHERE gameId = @GameId;
    RETURN @Details;
END;
GO

/* 
    Function: GF_GetGameDescription
    Description: Retrieves the description for a given gameId.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): The game ID to query.
    Returns:
        NVARCHAR(MAX): The game description if the game exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION GF_GetGameDescription (
    @GameId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
        RETURN NULL; -- Return NULL if GameId does not exist

    DECLARE @Description NVARCHAR(MAX);
    SELECT @Description = descriptions FROM [Games] WHERE gameId = @GameId;
    RETURN @Description;
END;
GO

/* 
    Function: GF_GetGameServices
    Description: Retrieves all services associated with a given gameId.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): The game ID to query.
    Returns:
        TABLE: A table containing serviceName for the game.
*/
CREATE OR ALTER FUNCTION GF_GetGameServices (
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

/* 
    Function: GF_IsGameTitleLegal
    Description: Checks if a game title is valid (1-100 characters, alphanumeric with ._-).
    Parameters:
        @Title (NVARCHAR(100)): The game title to validate.
    Returns:
        BIT: 1 if the title is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION GF_IsGameTitleLegal (
    @Title NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Title IS NULL
        RETURN 0; -- Return 0 if Title is NULL

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Title) < 1 OR LEN(@Title) > 100 THEN 0
        WHEN @Title LIKE '%[^a-zA-Z0-9._-]%' THEN 0
        ELSE 1
    END;
    RETURN @IsLegal;
END;
GO

/* 
    Function: GF_IsGameGenreLegal
    Description: Checks if a game genre is valid (1-100 characters).
    Parameters:
        @Genre (NVARCHAR(100)): The game genre to validate.
    Returns:
        BIT: 1 if the genre is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION GF_IsGameGenreLegal (
    @Genre NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Genre IS NULL
        RETURN 0; -- Return 0 if Genre is NULL

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Genre) < 1 OR LEN(@Genre) > 100 THEN 0
        ELSE 1
    END;
    RETURN @IsLegal;
END;
GO

/* 
    Function: GF_IsGameDescriptionLegal
    Description: Checks if a game description is valid (1-4000 characters).
    Parameters:
        @Description (NVARCHAR(MAX)): The game description to validate.
    Returns:
        BIT: 1 if the description is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION GF_IsGameDescriptionLegal (
    @Description NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    IF @Description IS NULL
        RETURN 0; -- Return 0 if Description is NULL

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Description) < 1 OR LEN(@Description) > 4000 THEN 0
        ELSE 1
    END;
    RETURN @IsLegal;
END;
GO

/* 
    Function: GF_IsGameDetailsLegal
    Description: Checks if game details are valid (1-4000 characters).
    Parameters:
        @Details (NVARCHAR(MAX)): The game details to validate.
    Returns:
        BIT: 1 if the details are valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION GF_IsGameDetailsLegal (
    @Details NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    IF @Details IS NULL
        RETURN 0; -- Return 0 if Details is NULL

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Details) < 1 OR LEN(@Details) > 4000 THEN 0
        ELSE 1
    END;
    RETURN @IsLegal;
END;
GO

/* 
    Function: GF_IsGamePosterLegal
    Description: Checks if a game poster URL is valid by reusing HF_IsUrlLegal.
    Parameters:
        @Poster (VARCHAR(255)): The poster URL to validate.
    Returns:
        BIT: 1 if the poster URL is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION GF_IsGamePosterLegal (
    @Poster VARCHAR(255)
)
RETURNS BIT
AS
BEGIN
    RETURN DBO.HF_IsUrlLegal(@Poster);
END;
GO

/* 
    Function: GF_IsGameBackdropLegal
    Description: Checks if a game backdrop URL is valid by reusing HF_IsUrlLegal.
    Parameters:
        @Backdrop (VARCHAR(255)): The backdrop URL to validate.
    Returns:
        BIT: 1 if the backdrop URL is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION GF_IsGameBackdropLegal (
    @Backdrop VARCHAR(255)
)
RETURNS BIT
AS
BEGIN
    RETURN DBO.HF_IsUrlLegal(@Backdrop);
END;
GO

/* 
    Function: GF_IsGameInputValid
    Description: Checks if all game inputs (title, genre, description, details, poster, backdrop) are valid.
    Parameters:
        @Title (NVARCHAR(100)): The game title.
        @Genre (NVARCHAR(100)): The game genre.
        @Description (NVARCHAR(MAX)): The game description.
        @Details (NVARCHAR(MAX)): The game details.
        @Poster (VARCHAR(255)): The game poster URL.
        @Backdrop (VARCHAR(255)): The game backdrop URL.
    Returns:
        BIT: 1 if all inputs are valid, 0 otherwise.
*/
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
        RETURN 0; -- Return 0 if any input is invalid

    RETURN 1; -- Return 1 if all inputs are valid
END;
GO

/* 
    Section: Review Table Functions
*/

/* 
    Function: RF_ReviewIdExists
    Description: Checks if a review exists based on its reviewId.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): The review ID to check.
    Returns:
        BIT: 1 if the review exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION RF_ReviewIdExists (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN 
    IF @ReviewId IS NULL
        RETURN 0; -- Return 0 if ReviewId is NULL

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM [Reviews] WHERE reviewId = @ReviewId
                ) THEN 1 ELSE 0 END);
END;
GO

/* 
    Function: RF_GetReview
    Description: Retrieves all details for a review based on its reviewId.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): The review ID to query.
    Returns:
        TABLE: A table containing all columns from the Reviews table.
*/
CREATE OR ALTER FUNCTION RF_GetReview (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM [Reviews] WHERE reviewId = @ReviewId
);
GO

/* 
    Function: RF_GetContent
    Description: Retrieves the content for a given reviewId.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): The review ID to query.
    Returns:
        NVARCHAR(MAX): The review content if the review exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION RF_GetContent (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN NULL; -- Return NULL if ReviewId does not exist

    DECLARE @Content NVARCHAR(MAX);
    SELECT @Content = content FROM [Reviews] WHERE reviewId = @ReviewId;
    RETURN @Content;
END;
GO

/* 
    Function: RF_GetRating
    Description: Retrieves the rating for a given reviewId.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): The review ID to query.
    Returns:
        DECIMAL(4,2): The review rating if the review exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION RF_GetRating (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS DECIMAL(4,2)
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN NULL; -- Return NULL if ReviewId does not exist

    DECLARE @Rating DECIMAL(4,2);
    SELECT @Rating = rating FROM [Reviews] WHERE reviewId = @ReviewId;
    RETURN @Rating;
END;
GO

/* 
    Function: RF_GetDateCreated
    Description: Retrieves the creation date for a given reviewId.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): The review ID to query.
    Returns:
        DATETIME: The review creation date if the review exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION RF_GetDateCreated (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN NULL; -- Return NULL if ReviewId does not exist

    DECLARE @DateCreated DATETIME;
    SELECT @DateCreated = dateCreated FROM [Reviews] WHERE reviewId = @ReviewId;
    RETURN @DateCreated;
END;
GO

/* 
    Function: RF_IsContentLegality
    Description: Checks if review content is valid (1-4000 characters).
    Parameters:
        @Content (NVARCHAR(MAX)): The review content to validate.
    Returns:
        BIT: 1 if the content is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION RF_IsContentLegality (
    @Content NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    IF @Content IS NULL OR @Content = ''
        RETURN 0; -- Return 0 if content is empty or null

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Content) < 1 OR LEN(@Content) > 4000 THEN 0
        ELSE 1
    END;
    RETURN @IsLegal;
END;
GO

/* 
    Function: RF_IsRatingLegality
    Description: Checks if a review rating is valid (0-10).
    Parameters:
        @Rating (DECIMAL(4,2)): The rating to validate.
    Returns:
        BIT: 1 if the rating is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION RF_IsRatingLegality (
    @Rating DECIMAL(4,2)
)
RETURNS BIT
AS
BEGIN
    IF @Rating IS NULL OR @Rating < 0 OR @Rating > 10
        RETURN 0; -- Return 0 if rating is invalid

    RETURN 1;
END;
GO

/* 
    Section: Comment Table Functions
*/

/* 
    Function: CF_CommentIdExists
    Description: Checks if a comment exists based on its commentId.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): The comment ID to check.
    Returns:
        BIT: 1 if the comment exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION CF_CommentIdExists (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN 
    IF @CommentId IS NULL
        RETURN 0;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM [Comments] WHERE commentId = @CommentId
                ) THEN 1 ELSE 0 END);
END;
GO

/* 
    Function: CF_GetComment
    Description: Retrieves all details for a comment based on its commentId.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): The comment ID to query.
    Returns:
        TABLE: A table containing all columns from the Comments table.
*/
CREATE OR ALTER FUNCTION CF_GetComment (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM [Comments] WHERE commentId = @CommentId
);
GO

/* 
    Function: CF_GetContent
    Description: Retrieves the content for a given commentId.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): The comment ID to query.
    Returns:
        NVARCHAR(MAX): The comment content if the comment exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION CF_GetContent (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0
        RETURN NULL;

    DECLARE @Content NVARCHAR(MAX);
    SELECT @Content = content FROM [Comments] WHERE commentId = @CommentId;
    RETURN @Content;
END;
GO

/* 
    Function: CF_GetCreatedAt
    Description: Retrieves the creation date for a given commentId.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): The comment ID to query.
    Returns:
        DATETIME: The comment creation date if the comment exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION CF_GetCreatedAt (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0
        RETURN NULL;

    DECLARE @CreatedAt DATETIME;
    SELECT @CreatedAt = created_at FROM [Comments] WHERE commentId = @CommentId;
    RETURN @CreatedAt;
END;
GO

/* 
    Function: CF_IsContentLegality
    Description: Checks if comment content is valid (1-4000 characters).
    Parameters:
        @Content (NVARCHAR(MAX)): The comment content to validate.
    Returns:
        BIT: 1 if the content is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION CF_IsContentLegality (
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

/* 
    Section: Rate Table Functions
*/

/* 
    Function: RF_RateIdExists
    Description: Checks if a rate exists based on its rateId.
    Parameters:
        @RateId (UNIQUEIDENTIFIER): The rate ID to check.
    Returns:
        BIT: 1 if the rate exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION RF_RateIdExists (
    @RateId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN 
    IF @RateId IS NULL
        RETURN 0;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM [Rates] WHERE rateId = @RateId
                ) THEN 1 ELSE 0 END);
END;
GO

/* 
    Function: RF_GetRate
    Description: Retrieves all details for a rate based on its rateId.
    Parameters:
        @RateId (UNIQUEIDENTIFIER): The rate ID to query.
    Returns:
        TABLE: A table containing all columns from the Rates table.
*/
CREATE OR ALTER FUNCTION RF_GetRate (
    @RateId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM [Rates] WHERE rateId = @RateId
);
GO

/* 
    Function: RF_GetValue
    Description: Retrieves the rating value for a given rateId.
    Parameters:
        @RateId (UNIQUEIDENTIFIER): The rate ID to query.
    Returns:
        INT: The rating value if the rate exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION RF_GetValue (
    @RateId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.RF_RateIdExists(@RateId) = 0
        RETURN NULL;

    DECLARE @Value INT;
    SELECT @Value = rateValue FROM [Rates] WHERE rateId = @RateId;
    RETURN @Value;
END;
GO

/* 
    Function: RF_IsRateLegal
    Description: Checks if a rating value is valid (0-10).
    Parameters:
        @RateValue (INT): The rating value to validate.
    Returns:
        BIT: 1 if the rating is valid, 0 otherwise.
*/
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

/* 
    Section: List Table Functions
*/

/* 
    Function: LF_ListIdExists
    Description: Checks if a list exists based on its listId.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): The list ID to check.
    Returns:
        BIT: 1 if the list exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION LF_ListIdExists (
    @ListId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN 
    IF @ListId IS NULL
        RETURN 0;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM [Lists] WHERE listId = @ListId
                ) THEN 1 ELSE 0 END);
END;
GO

/* 
    Function: LF_GetList
    Description: Retrieves all details for a list based on its listId.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): The list ID to query.
    Returns:
        TABLE: A table containing all columns from the Lists table.
*/
CREATE OR ALTER FUNCTION LF_GetList (
    @ListId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM [Lists] WHERE listId = @ListId
);
GO

/* 
    Function: LF_GetName
    Description: Retrieves the name for a given listId.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): The list ID to query.
    Returns:
        NVARCHAR(100): The list name if the list exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION LF_GetName (
    @ListId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0
        RETURN NULL;

    DECLARE @_Name NVARCHAR(100);
    SELECT @_Name = _name FROM [Lists] WHERE listId = @ListId;
    RETURN @_Name;
END;
GO

/* 
    Function: LF_GetDescriptions
    Description: Retrieves the description for a given listId.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): The list ID to query.
    Returns:
        NVARCHAR(MAX): The list description if the list exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION LF_GetDescriptions (
    @ListId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0
        RETURN NULL;

    DECLARE @Descriptions NVARCHAR(MAX);
    SELECT @Descriptions = descriptions FROM [Lists] WHERE listId = @ListId;
    RETURN @Descriptions;
END;
GO

/* 
    Function: LF_GetCreatedAt
    Description: Retrieves the creation date for a given listId.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): The list ID to query.
    Returns:
        DATETIME: The list creation date if the list exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION LF_GetCreatedAt (
    @ListId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0
        RETURN NULL;

    DECLARE @CreatedAt DATETIME;
    SELECT @CreatedAt = created_at FROM [Lists] WHERE listId = @ListId;
    RETURN @CreatedAt;
END;
GO

/* 
    Function: LF_IsNameLegal
    Description: Checks if a list name is valid (non-empty).
    Parameters:
        @Name (NVARCHAR(100)): The list name to validate.
    Returns:
        BIT: 1 if the name is valid, 0 otherwise.
*/
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

/* 
    Function: LF_IsDescriptionLegal
    Description: Checks if a list description is valid (1-4000 characters).
    Parameters:
        @Description (NVARCHAR(MAX)): The list description to validate.
    Returns:
        BIT: 1 if the description is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION LF_IsDescriptionLegal (
    @Description NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    IF @Description IS NULL OR @Description = ''
        RETURN 0;

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Description) < 1 OR LEN(@Description) > 4000 THEN 0
        ELSE 1
    END;
    RETURN @IsLegal;
END;
GO

/* 
    Section: List Item Table Functions
*/

/* 
    Function: LIF_ListItemIdExists
    Description: Checks if a list item exists based on its listItemId.
    Parameters:
        @ListItemId (UNIQUEIDENTIFIER): The list item ID to check.
    Returns:
        BIT: 1 if the list item exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION LIF_ListItemIdExists (
    @ListItemId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    RETURN CASE 
               WHEN EXISTS (SELECT 1 FROM [List_items] WHERE listItemId = @ListItemId) 
               THEN 1 
               ELSE 0 
           END;
END;
GO

/* 
    Function: LIF_GetListItem
    Description: Retrieves all details for a list item based on its listItemId.
    Parameters:
        @ListItemId (UNIQUEIDENTIFIER): The list item ID to query.
    Returns:
        TABLE: A table containing all columns from the List_items table.
*/
CREATE OR ALTER FUNCTION LIF_GetListItem (
    @ListItemId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM [List_items] WHERE listItemId = @ListItemId
);
GO

/* 
    Function: LIF_GetTitle
    Description: Retrieves the title for a given listItemId.
    Parameters:
        @ListItemId (UNIQUEIDENTIFIER): The list item ID to query.
    Returns:
        NVARCHAR(100): The list item title if the list item exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION LIF_GetTitle (
    @ListItemId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0
        RETURN NULL;

    DECLARE @Result NVARCHAR(100);
    SELECT @Result = title FROM [List_items] WHERE listItemId = @ListItemId;
    RETURN @Result;
END;
GO

/* 
    Function: LIF_IsTitleLegal
    Description: Checks if a list item title is valid (non-empty).
    Parameters:
        @Title (NVARCHAR(100)): The list item title to validate.
    Returns:
        BIT: 1 if the title is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION LIF_IsTitleLegal (
    @Title NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Title IS NULL OR LEN(@Title) = 0
        RETURN 0;
    RETURN 1;
END;
GO

/* 
    Section: Activity Table Functions
*/

/* 
    Function: AF_ActivityIdExists
    Description: Checks if an activity exists based on its activityId.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): The activity ID to check.
    Returns:
        BIT: 1 if the activity exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION AF_ActivityIdExists (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @ActivityId IS NULL
        RETURN 0;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM [Activities] WHERE activityId = @ActivityId
                ) THEN 1 ELSE 0 END);
END;
GO

/* 
    Function: AF_GetActivity
    Description: Retrieves all details for an activity based on its activityId.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): The activity ID to query.
    Returns:
        TABLE: A table containing all columns from the Activities table.
*/
CREATE OR ALTER FUNCTION AF_GetActivity (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
    SELECT * FROM [Activities] WHERE activityId = @ActivityId;
GO

/* 
    Function: AF_GetContent
    Description: Retrieves the content for a given activityId.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): The activity ID to query.
    Returns:
        NVARCHAR(MAX): The activity content if the activity exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION AF_GetContent (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
        RETURN NULL;

    DECLARE @Content NVARCHAR(MAX);
    SELECT @Content = content FROM [Activities] WHERE activityId = @ActivityId;
    RETURN @Content;
END;
GO

/* 
    Function: AF_GetDateDo
    Description: Retrieves the date performed for a given activityId.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): The activity ID to query.
    Returns:
        DATETIME: The activity date if the activity exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION AF_GetDateDo (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
        RETURN NULL;

    DECLARE @Date DATETIME;
    SELECT @Date = dateDo FROM [Activities] WHERE activityId = @ActivityId;
    RETURN @Date;
END;
GO

/* 
    Function: AF_IsContentLegal
    Description: Checks if activity content is valid (1-4000 characters).
    Parameters:
        @Content (NVARCHAR(MAX)): The activity content to validate.
    Returns:
        BIT: 1 if the content is valid, 0 otherwise.
*/
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

/* 
    Section: Diary Table Functions
*/

/* 
    Function: DF_DiaryIdExists
    Description: Checks if a diary entry exists based on its diaryId.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): The diary ID to check.
    Returns:
        BIT: 1 if the diary entry exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION DF_DiaryIdExists (
    @DiaryId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @DiaryId IS NULL
        RETURN 0;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM [Diaries] WHERE diaryId = @DiaryId
                ) THEN 1 ELSE 0 END);
END;
GO

/* 
    Function: DF_GetDiary
    Description: Retrieves all details for a diary entry based on its diaryId.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): The diary ID to query.
    Returns:
        TABLE: A table containing all columns from the Diaries table.
*/
CREATE OR ALTER FUNCTION DF_GetDiary (
    @DiaryId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
    SELECT * FROM [Diaries] WHERE diaryId = @DiaryId;
GO

/* 
    Function: DF_GetDateLogged
    Description: Retrieves the logged date for a given diaryId.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): The diary ID to query.
    Returns:
        DATETIME: The diary logged date if the diary exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION DF_GetDateLogged (
    @DiaryId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
        RETURN NULL;

    DECLARE @Date DATETIME;
    SELECT @Date = dateLogged FROM [Diaries] WHERE diaryId = @DiaryId;
    RETURN @Date;
END;
GO

/* 
    Section: Reaction Table Functions
*/

/* 
    Function: RF_ReactionIdExists
    Description: Checks if a reaction exists based on its reactionId.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): The reaction ID to check.
    Returns:
        BIT: 1 if the reaction exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION RF_ReactionIdExists (
    @ReactionId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @ReactionId IS NULL
        RETURN 0;

    RETURN (SELECT CASE WHEN EXISTS (
                    SELECT 1 FROM [Reactions] WHERE reactionId = @ReactionId
                ) THEN 1 ELSE 0 END);
END;
GO

/* 
    Function: RF_IsReactionTypeLegal
    Description: Checks if a reaction type is valid (0-3).
    Parameters:
        @ReactionType (INT): The reaction type to validate (0: Like, 1: Dislike, 2: Love, 3: Angry).
    Returns:
        BIT: 1 if the reaction type is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION RF_IsReactionTypeLegal (
    @ReactionType INT
)
RETURNS BIT
AS
BEGIN
    IF @ReactionType IS NULL
        RETURN 0;

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN @ReactionType >= 0 AND @ReactionType <= 3 THEN 1
        ELSE 0
    END;
    RETURN @IsLegal;
END;
GO

/* 
    Function: RF_GetReaction
    Description: Retrieves all details for a reaction based on its reactionId.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): The reaction ID to query.
    Returns:
        TABLE: A table containing all columns from the Reactions table.
*/
CREATE OR ALTER FUNCTION RF_GetReaction (
    @ReactionId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM [Reactions] WHERE reactionId = @ReactionId
);
GO

/* 
    Function: RF_GetReactionType
    Description: Retrieves the reaction type for a given reactionId.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): The reaction ID to query.
    Returns:
        INT: The reaction type (0: Like, 1: Dislike, 2: Love, 3: Angry) if the reaction exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION RF_GetReactionType (
    @ReactionId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
        RETURN NULL;

    DECLARE @ReactionType INT;
    SELECT @ReactionType = reactionType FROM [Reactions] WHERE reactionId = @ReactionId;
    RETURN @ReactionType;
END;
GO

/* 
    Function: RF_GetDateDo
    Description: Retrieves the date performed for a given reactionId.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): The reaction ID to query.
    Returns:
        DATETIME: The reaction date if the reaction exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION RF_GetDateDo (
    @ReactionId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
        RETURN NULL;

    DECLARE @DateDo DATETIME;
    SELECT @DateDo = dateDo FROM [Reactions] WHERE reactionId = @ReactionId;
    RETURN @DateDo;
END;
GO