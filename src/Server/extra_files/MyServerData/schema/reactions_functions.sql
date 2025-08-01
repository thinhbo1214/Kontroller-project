-- 1. Function to check if reactionId exists
CREATE OR ALTER FUNCTION RF_ReactionIdExists (
    @ReactionId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @ReactionId IS NULL RETURN 0;

    DECLARE @Exists BIT;
    SELECT @Exists = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM Reactions
    WHERE reactionId = @ReactionId;

    RETURN @Exists;
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
        WHEN @ReactionType >= 0 AND @ReactionType <= 10 THEN 1
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
