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

    IF EXISTS (SELECT 1 FROM [Games] WHERE GameId = @GameId)
    BEGIN
        RETURN 1; -- Return 1 if GameId exists
    END;

    RETURN 0; -- Return 0 if GameId does not exist

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