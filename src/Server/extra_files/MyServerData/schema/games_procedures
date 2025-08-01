-- # Games table procedures
-- 1. Procedure to create a new game
CREATE OR ALTER PROCEDURE GP_CreateGame
@Title NVARCHAR(100),
@Genre NVARCHAR(100),
@Description NVARCHAR(MAX),
@Details NVARCHAR(MAX)
AS
BEGIN
    IF DBO.GF_IsGameTitleLegal(@Title) = 0 
        OR DBO.GF_IsGameGenreLegal(@Genre) = 0 
        OR DBO.GF_IsGameDescriptionLegal(@Description) = 0
        OR DBO.GF_IsGameDetailsLegal(@Details) = 0
    BEGIN
        SELECT NULL AS GameId;
        RETURN;
    END;

    DECLARE @GameId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO [Games] (gameId, title, genre, descriptions, details)
    VALUES (@GameId, @Title, @Genre, @Description, @Details);

    IF DBO.UF_GameIdExists(@GameId) = 0
    BEGIN
        SELECT NULL AS GameId;
        RETURN;
    END;

    SELECT @GameId AS GameId;
END;
GO

-- 2. Procedure to update game title
CREATE OR ALTER PROCEDURE GP_UpdateGameTitle
@GameId UNIQUEIDENTIFIER,
@NewTitle NVARCHAR(100)
AS
BEGIN
    IF DBO.GF_IsGameTitleLegal(@NewTitle) = 0
    BEGIN
        SELECT 0 AS TitleUpdated;
        RETURN;
    END;

    UPDATE [Games] SET title = @NewTitle WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS TitleUpdated;
END;
GO

-- 3. Procedure to update game genre
CREATE OR ALTER PROCEDURE GP_UpdateGameGenre
@GameId UNIQUEIDENTIFIER,
@NewGenre NVARCHAR(100)
AS
BEGIN
    IF DBO.GF_IsGameGenreLegal(@NewGenre) = 0
    BEGIN
        SELECT 0 AS GenreUpdated;
        RETURN;
    END;

    UPDATE [Games] SET genre = @NewGenre WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS GenreUpdated;
END;
GO

-- 4. Procedure to update game description
CREATE OR ALTER PROCEDURE GP_UpdateGameDescription
@GameId UNIQUEIDENTIFIER,
@NewDescription NVARCHAR(MAX)
AS
BEGIN
    IF DBO.GF_IsGameDescriptionLegal(@NewDescription) = 0
    BEGIN
        SELECT 0 AS DescriptionUpdated;
        RETURN;
    END;

    UPDATE [Games] SET descriptions = @NewDescription WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DescriptionUpdated;
END;
GO

-- 5. Procedure to update game details
CREATE OR ALTER PROCEDURE GP_UpdateGameDetails
@GameId UNIQUEIDENTIFIER,
@NewDetails NVARCHAR(MAX)
AS
BEGIN
    IF DBO.GF_IsGameDetailsLegal(@NewDetails) = 0
    BEGIN
        SELECT 0 AS DetailsUpdated;
        RETURN;
    END;

    UPDATE [Games] SET details = @NewDetails WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DetailsUpdated;
END;
GO

-- 6. Procedure to update game poster
CREATE OR ALTER PROCEDURE GP_UpdateGamePoster
@GameId UNIQUEIDENTIFIER,
@NewPoster VARCHAR(255)
AS
BEGIN
    IF DBO.GF_IsGamePosterLegal(@NewPoster) = 0
    BEGIN
        SELECT 0 AS PosterUpdated;
        RETURN;
    END;

    UPDATE [Games] SET poster = @NewPoster WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS PosterUpdated;
END;
GO

-- 7. Procedure to update game backdrop
CREATE OR ALTER PROCEDURE GP_UpdateGameBackdrop
@GameId UNIQUEIDENTIFIER,
@NewBackdrop VARCHAR(255)
AS
BEGIN
    IF DBO.GF_IsGameBackdropLegal(@NewBackdrop) = 0
    BEGIN
        SELECT 0 AS BackdropUpdated;
        RETURN;
    END;

    UPDATE [Games] SET backdrop = @NewBackdrop WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS BackdropUpdated;
END;
GO

-- 8. Procedure to update game all information
CREATE OR ALTER PROCEDURE GP_UpdateGameAllInfo
@GameId UNIQUEIDENTIFIER,
@Title NVARCHAR(100) = NULL,
@Genre NVARCHAR(100) = NULL,
@Description NVARCHAR(MAX) = NULL,
@Details NVARCHAR(MAX) = NULL,
@Poster VARCHAR(255) = NULL,
@Backdrop VARCHAR(255) = NULL
AS
BEGIN
    IF DBO.UF_GameIdExists(@GameId) = 0
    BEGIN
        RETURN;
    END;

    EXEC DBO.GP_UpdateGameTitle @GameId, @Title;

    EXEC DBO.GP_UpdateGameGenre @GameId, @Genre;

    EXEC DBO.GP_UpdateGameDescription @GameId, @Description;

    EXEC DBO.GP_UpdateGameDetails @GameId, @Details;

    EXEC DBO.GP_UpdateGamePoster @GameId, @Poster;

    EXEC DBO.GP_UpdateGameBackdrop @GameId, @Backdrop;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS GameInfoUpdated;
END;
GO

-- 9. Procedure to delete a game
CREATE OR ALTER PROCEDURE GP_DeleteGame
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        SELECT 0 AS GameDeleted;
        RETURN;
    END;

    DELETE FROM [Games] WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS GameDeleted;
END;
GO

-- 10. Procedure to get game aLl information
CREATE OR ALTER PROCEDURE GP_GetGameAllInfo
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM GF_GetGameAllInfo(@GameId);
END;
GO

-- 11. Procedure to get game title
CREATE OR ALTER PROCEDURE GP_GetGameTitle
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.GF_GetGameTitle(@GameId) AS Title;
END;
GO

-- 12. Procedure to get game genre
CREATE OR ALTER PROCEDURE GP_GetGameGenre
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.GF_GetGameGenre(@GameId) AS Genre;
END;
GO

-- 13. Procedure to get game description
CREATE OR ALTER PROCEDURE GP_GetGameDescription
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.GF_GetGameDescription(@GameId) AS Description;
END;
GO

-- 14. Procedure to get game details
CREATE OR ALTER PROCEDURE GP_GetGameDetails
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.GF_GetGameDetails(@GameId) AS Details;
END;
GO

-- 15. Procedure to get game poster
CREATE OR ALTER PROCEDURE GP_GetGamePoster
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.GF_GetGamePoster(@GameId) AS Poster;
END;
GO

-- 16. Procedure to get game backdrop
CREATE OR ALTER PROCEDURE GP_GetGameBackdrop
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.GF_GetGameBackdrop(@GameId) AS Backdrop;
END;
GO