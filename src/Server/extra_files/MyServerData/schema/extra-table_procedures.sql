-- # Procedures for Game_Service table
-- 1. Procedure to add a game to a service
CREATE OR ALTER PROCEDURE GSP_AddGameToService
@GameId UNIQUEIDENTIFIER,
@ServiceName NVARCHAR(30)
AS
BEGIN
    IF GSF_IsGameServiceUsable(@GameId, @ServiceName) = 0
    BEGIN
        SELECT 0 AS GameServiceAdded;
        RETURN;
    END;

    INSERT INTO [Game_Service] (gameId, serviceName)
    VALUES (@GameId, @ServiceName);

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS GameServiceAdded;
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