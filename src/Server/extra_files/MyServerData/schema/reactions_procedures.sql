-- 1. Procedure to create a new reaction
CREATE OR ALTER PROCEDURE RP_CreateReaction
@ReactionType INT
AS
BEGIN
    IF DBO.RF_IsReactionTypeLegal(@ReactionType) = 0
    BEGIN
        SELECT NULL AS ReactionId;
        RETURN;
    END

    DECLARE @ReactionId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Reactions (reactionId, reactionType)
    VALUES (@ReactionId, @ReactionType);

    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SELECT NULL AS ReactionId;
        RETURN;
    END

    SELECT @ReactionId AS ReactionId;
END;
GO

-- 2. Procedure to update reactionType
CREATE OR ALTER PROCEDURE RP_UpdateReactionType
@ReactionId UNIQUEIDENTIFIER,
@ReactionType INT
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0 OR
       DBO.RF_IsReactionTypeLegal(@ReactionType) = 0
    BEGIN
        SELECT 0 AS ReactionTypeUpdated;
        RETURN;
    END

    UPDATE Reactions SET reactionType = @ReactionType WHERE reactionId = @ReactionId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ReactionTypeUpdated;
END;
GO

-- 3. Procedure to update all columns
CREATE OR ALTER PROCEDURE RP_UpdateReaction
@ReactionId UNIQUEIDENTIFIER,
@ReactionType INT
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SELECT 0 AS ReactionUpdated;
        RETURN;
    END

    EXEC RP_UpdateReactionType @ReactionId, @ReactionType;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ReactionUpdated;
END;
GO

-- 4. Procedure to delete a reaction
CREATE OR ALTER PROCEDURE RP_DeleteReaction
@ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SELECT 0 AS ReactionDeleted;
        RETURN;
    END

    DELETE FROM Reactions WHERE reactionId = @ReactionId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ReactionDeleted;
END;
GO

-- 5. Procedure to get full row
CREATE OR ALTER PROCEDURE RP_GetReaction
@ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.RF_GetReaction(@ReactionId);
END;
GO

-- 6. Procedure to get reactionType
CREATE OR ALTER PROCEDURE RP_GetReactionType
@ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.RF_GetReactionType(@ReactionId) AS ReactionType;
END;
GO
