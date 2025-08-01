-- Function helpers
-- 1. check URL legality
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