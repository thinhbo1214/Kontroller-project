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
    Function: UF_GetUserAll
    Description: Retrieves all details for a user based on their userId.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to query.
    Returns:
        TABLE: A table containing userId, username, email, avatar, isLoggedIn, numberFollower, numberFollowing, numberList.
*/
CREATE OR ALTER FUNCTION UF_GetUserAll (
    @UserId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN 
(
    SELECT userId AS UserId,
           username AS Username,
           email AS Email,
           avatar AS Avatar,
           isLoggedIn AS IsLoggedIn,
           numberFollower AS NumberFollower,
           numberFollowing AS NumberFollowing,
           numberList AS NumberList
    FROM [Users]
    WHERE userId = @UserId
);
GO

/* 
    Function: UF_GetUserUsername
    Description: Retrieves the username for a given userId.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to query.
    Returns:
        VARCHAR(100): The username if the user exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION UF_GetUserUsername (
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
    Function: UF_GetUserEmail
    Description: Retrieves the email for a given userId.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to query.
    Returns:
        VARCHAR(100): The email if the user exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION UF_GetUserEmail (
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
    Function: UF_GetUserNumberFollower
    Description: Retrieves the number of followers for a given userId.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to query.
    Returns:
        INT: The number of followers if the user exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_GetUserNumberFollower (
    @UserId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
        RETURN 0; 

    DECLARE @NumberFollower INT;
    SELECT @NumberFollower = numberFollower FROM [Users] WHERE userId = @UserId; 
    RETURN @NumberFollower; 
END;
GO

/* 
    Function: UF_GetUserNumberFollowing
    Description: Retrieves the number of users followed by a given userId.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to query.
    Returns:
        INT: The number of users followed if the user exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_GetUserNumberFollowing (
    @UserId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
        RETURN 0; 

    DECLARE @NumberFollowing INT;
    SELECT @NumberFollowing = numberFollowing FROM [Users] WHERE userId = @UserId; 
    RETURN @NumberFollowing; 
END;
GO

/* 
    Function: UF_GetUserNumberList
    Description: Retrieves the number of lists created by a given userId.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): The user ID to query.
    Returns:
        INT: The number of lists if the user exists, 0 otherwise.
*/
CREATE OR ALTER FUNCTION UF_GetUserNumberList (
    @UserId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
        RETURN 0; 

    DECLARE @NumberList INT;
    SELECT @NumberList = numberList FROM [Users] WHERE userId = @UserId; 
    RETURN @NumberList; 
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
    Function: GF_GetGameAll
    Description: Retrieves all details for a game based on its gameId.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): The game ID to query.
    Returns:
        TABLE: A table containing gameId, title, descriptions, genre, avgRating, poster, backdrop, details, numberReview.
*/
CREATE OR ALTER FUNCTION GF_GetGameAll (
    @GameId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
(
    SELECT gameId AS GameId,
           title AS Title,
           descriptions AS Descriptions,
           genre AS Genre, 
           avgRating AS AvgRating,
           poster AS Poster,
           backdrop AS Backdrop,
           details AS Details,
           numberReview AS NumberReview
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
    Function: GF_GetGameNumberReview
    Description: Retrieves the number of reviews for a given gameId.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): The game ID to query.
    Returns:
        INT: The number of reviews if the game exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION GF_GetGameNumberReview (
    @GameId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
        RETURN NULL; -- Return NULL if GameId does not exist

    DECLARE @NumberReview INT;
    SELECT @NumberReview = numberReview FROM [Games] WHERE gameId = @GameId;
    RETURN @NumberReview;
END;
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
    Function: RF_GetReviewAll
    Description: Retrieves all details for a review based on its reviewId.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): The review ID to query.
    Returns:
        TABLE: A table containing reviewId, content, rating, dateCreated, numberReaction, numberComment.
*/
CREATE OR ALTER FUNCTION RF_GetReviewAll (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT reviewId AS ReviewId,
           content AS Content,
           rating AS Rating,
           dateCreated AS DateCreated,
           numberReaction AS NumberReaction,
           numberComment AS NumberComment
    FROM [Reviews] 
    WHERE reviewId = @ReviewId
);
GO

/* 
    Function: RF_GetReviewContent
    Description: Retrieves the content for a given reviewId.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): The review ID to query.
    Returns:
        NVARCHAR(MAX): The review content if the review exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION RF_GetReviewContent (
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
    Function: RF_GetReviewRating
    Description: Retrieves the rating for a given reviewId.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): The review ID to query.
    Returns:
        DECIMAL(4,2): The review rating if the review exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION RF_GetReviewRating (
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
    Function: RF_GetReviewDateCreated
    Description: Retrieves the creation date for a given reviewId.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): The review ID to query.
    Returns:
        DATETIME: The review creation date if the review exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION RF_GetReviewDateCreated (
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
    Function: RF_GetReviewNumberReaction
    Description: Retrieves the number of reactions for a given reviewId.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): The review ID to query.
    Returns:
        INT: The number of reactions if the review exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION RF_GetReviewNumberReaction (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN NULL; -- Return NULL if ReviewId does not exist

    DECLARE @NumberReaction INT;
    SELECT @NumberReaction = numberReaction FROM [Reviews] WHERE reviewId = @ReviewId;
    RETURN @NumberReaction;
END;
GO

/* 
    Function: RF_GetReviewNumberComment
    Description: Retrieves the number of comments for a given reviewId.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): The review ID to query.
    Returns:
        INT: The number of comments if the review exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION RF_GetReviewNumberComment (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
        RETURN NULL; -- Return NULL if ReviewId does not exist

    DECLARE @NumberComment INT;
    SELECT @NumberComment = numberComment FROM [Reviews] WHERE reviewId = @ReviewId;
    RETURN @NumberComment;
END;
GO

/* 
    Function: RF_IsContentLegal
    Description: Checks if review content is valid (1-4000 characters).
    Parameters:
        @Content (NVARCHAR(MAX)): The review content to validate.
    Returns:
        BIT: 1 if the content is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION RF_IsContentLegal (
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
    Function: RF_IsRatingLegal
    Description: Checks if a review rating is valid (0-10).
    Parameters:
        @Rating (DECIMAL(4,2)): The rating to validate.
    Returns:
        BIT: 1 if the rating is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION RF_IsRatingLegal (
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
    Function: CF_GetCommentAll
    Description: Retrieves all details for a comment based on its commentId.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): The comment ID to query.
    Returns:
        TABLE: A table containing commentId, content, created_at, numberReaction.
*/
CREATE OR ALTER FUNCTION CF_GetCommentAll (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT commentId AS CommentId,
           content AS Content,
           created_at AS CreatedAt,
           numberReaction AS NumberReaction
    FROM [Comments] 
    WHERE commentId = @CommentId
);
GO

/* 
    Function: CF_GetCommentContent
    Description: Retrieves the content for a given commentId.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): The comment ID to query.
    Returns:
        NVARCHAR(MAX): The comment content if the comment exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION CF_GetCommentContent (
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
    Function: CF_GetCommentCreatedAt
    Description: Retrieves the creation date for a given commentId.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): The comment ID to query.
    Returns:
        DATETIME: The comment creation date if the comment exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION CF_GetCommentCreatedAt (
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
    Function: CF_GetCommentNumberReaction
    Description: Retrieves the number of reactions for a given commentId.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): The comment ID to query.
    Returns:
        INT: The number of reactions if the comment exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION CF_GetCommentNumberReaction (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.CF_CommentIdExists(@CommentId) = 0
        RETURN NULL;

    DECLARE @NumberReaction INT;
    SELECT @NumberReaction = numberReaction FROM [Comments] WHERE commentId = @CommentId;
    RETURN @NumberReaction;
END;
GO

/* 
    Function: CF_IsContentLegal
    Description: Checks if comment content is valid (1-4000 characters).
    Parameters:
        @Content (NVARCHAR(MAX)): The comment content to validate.
    Returns:
        BIT: 1 if the content is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION CF_IsContentLegal (
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
    Function: LF_GetListAll
    Description: Retrieves all details for a list based on its listId.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): The list ID to query.
    Returns:
        TABLE: A table containing listId, title, descriptions, created_at, numberGame.
*/
CREATE OR ALTER FUNCTION LF_GetListAll (
    @ListId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT listId AS ListId,
           title AS Title,
           descriptions AS Descriptions,
           created_at AS CreatedAt,
           numberGame AS NumberGame
    FROM [Lists] 
    WHERE listId = @ListId
);
GO

/* 
    Function: LF_GetListTitle
    Description: Retrieves the title for a given listId.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): The list ID to query.
    Returns:
        NVARCHAR(100): The list title if the list exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION LF_GetListTitle (
    @ListId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0
        RETURN NULL;

    DECLARE @Title NVARCHAR(100);
    SELECT @Title = title FROM [Lists] WHERE listId = @ListId;
    RETURN @Title;
END;
GO

/* 
    Function: LF_GetListDescriptions
    Description: Retrieves the description for a given listId.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): The list ID to query.
    Returns:
        NVARCHAR(MAX): The list description if the list exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION LF_GetListDescriptions (
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
    Function: LF_GetListCreatedAt
    Description: Retrieves the creation date for a given listId.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): The list ID to query.
    Returns:
        DATETIME: The list creation date if the list exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION LF_GetListCreatedAt (
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
    Function: LF_GetListNumberGame
    Description: Retrieves the number of games in a given listId.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): The list ID to query.
    Returns:
        INT: The number of games if the list exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION LF_GetListNumberGame (
    @ListId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0
        RETURN NULL;

    DECLARE @NumberGame INT;
    SELECT @NumberGame = numberGame FROM [Lists] WHERE listId = @ListId;
    RETURN @NumberGame;
END;
GO

/* 
    Function: LF_IsListTitleLegal
    Description: Checks if a list title is valid (1-100 characters, alphanumeric with _-).
    Parameters:
        @Title (NVARCHAR(100)): The list title to validate.
    Returns:
        BIT: 1 if the title is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION LF_IsListTitleLegal (
    @Title NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Title IS NULL OR @Title = ''
        RETURN 0;

    DECLARE @IsLegal BIT;
    SELECT @IsLegal = CASE 
        WHEN LEN(@Title) < 1 OR LEN(@Title) > 100 THEN 0
        WHEN @Title LIKE '%[^a-zA-Z0-9_-]%' THEN 0
        ELSE 1
    END;
    RETURN @IsLegal;
END;
GO

/* 
    Function: LF_IsListDescriptionLegal
    Description: Checks if a list description is valid (1-4000 characters).
    Parameters:
        @Description (NVARCHAR(MAX)): The list description to validate.
    Returns:
        BIT: 1 if the description is valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION LF_IsListDescriptionLegal (
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
    Function: LF_IsListInputValid
    Description: Checks if list inputs (title, description) are valid.
    Parameters:
        @Title (NVARCHAR(100)): The list title to validate.
        @Description (NVARCHAR(MAX)): The list description to validate.
    Returns:
        BIT: 1 if all inputs are valid, 0 otherwise.
*/
CREATE OR ALTER FUNCTION LF_IsListInputValid (
    @Title NVARCHAR(100),
    @Description NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    IF DBO.LF_IsListTitleLegal(@Title) = 0 OR 
       DBO.LF_IsListDescriptionLegal(@Description) = 0
        RETURN 0; -- Return 0 if any input is invalid

    RETURN 1; -- Return 1 if all inputs are valid
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
    Function: AF_GetActivityAll
    Description: Retrieves all details for an activity based on its activityId.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): The activity ID to query.
    Returns:
        TABLE: A table containing activityId, content, dateDo.
*/
CREATE OR ALTER FUNCTION AF_GetActivityAll (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
    SELECT activityId AS ActivityId,
           content AS Content,
           dateDo AS DateDo
    FROM [Activities] 
    WHERE activityId = @ActivityId;
GO

/* 
    Function: AF_GetActivityContent
    Description: Retrieves the content for a given activityId.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): The activity ID to query.
    Returns:
        NVARCHAR(MAX): The activity content if the activity exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION AF_GetActivityContent (
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
    Function: AF_GetActivityDateDo
    Description: Retrieves the date performed for a given activityId.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): The activity ID to query.
    Returns:
        DATETIME: The activity date if the activity exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION AF_GetActivityDateDo (
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
    Function: DF_GetDiaryAll
    Description: Retrieves all details for a diary entry based on its diaryId.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): The diary ID to query.
    Returns:
        TABLE: A table containing diaryId, dateLogged, numberGameLogged.
*/
CREATE OR ALTER FUNCTION DF_GetDiaryAll (
    @DiaryId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
    SELECT diaryId AS DiaryId,
           dateLogged AS DateLogged,
           numberGameLogged AS NumberGameLogged
    FROM [Diaries] 
    WHERE diaryId = @DiaryId;
GO

/* 
    Function: DF_GetDiaryDateLogged
    Description: Retrieves the logged date for a given diaryId.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): The diary ID to query.
    Returns:
        DATETIME: The diary logged date if the diary exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION DF_GetDiaryDateLogged (
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
    Function: DF_GetDiaryNumberGameLogged
    Description: Retrieves the number of games logged for a given diaryId.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): The diary ID to query.
    Returns:
        INT: The number of games logged if the diary exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION DF_GetDiaryNumberGameLogged (
    @DiaryId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
        RETURN NULL;

    DECLARE @NumberGameLogged INT;
    SELECT @NumberGameLogged = numberGameLogged FROM [Diaries] WHERE diaryId = @DiaryId;
    RETURN @NumberGameLogged;
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
    Function: RF_GetReactionAll
    Description: Retrieves all details for a reaction based on its reactionId.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): The reaction ID to query.
    Returns:
        TABLE: A table containing reactionId, reactionType, dateDo.
*/
CREATE OR ALTER FUNCTION RF_GetReactionAll (
    @ReactionId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT reactionId AS ReactionId,
           reactionType AS ReactionType,
           dateDo AS DateDo
    FROM [Reactions] 
    WHERE reactionId = @ReactionId
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
    Function: RF_GetReactionDateDo
    Description: Retrieves the date performed for a given reactionId.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): The reaction ID to query.
    Returns:
        DATETIME: The reaction date if the reaction exists, NULL otherwise.
*/
CREATE OR ALTER FUNCTION RF_GetReactionDateDo (
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
