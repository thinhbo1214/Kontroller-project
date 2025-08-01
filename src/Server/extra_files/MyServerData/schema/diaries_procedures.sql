-- 1. Procedure to create a new diary entry
CREATE OR ALTER PROCEDURE DP_CreateDiary
AS
BEGIN
    DECLARE @DiaryId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Diaries (diaryId)
    VALUES (@DiaryId);

    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        SELECT NULL AS DiaryId;
        RETURN;
    END

    SELECT @DiaryId AS DiaryId;
END;
GO

-- 2. Procedure to update dateLogged
CREATE OR ALTER PROCEDURE DP_UpdateDateLogged
@DiaryId UNIQUEIDENTIFIER,
@DateLogged DATETIME
AS
BEGIN
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0 OR @DateLogged IS NULL
    BEGIN
        SELECT 0 AS DateLoggedUpdated;
        RETURN;
    END

    UPDATE Diaries SET dateLogged = @DateLogged WHERE diaryId = @DiaryId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DateLoggedUpdated;
END;
GO

-- 3. Procedure to update full diary row
CREATE OR ALTER PROCEDURE DP_UpdateDiary
@DiaryId UNIQUEIDENTIFIER,
@DateLogged DATETIME
AS
BEGIN
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        SELECT 0 AS DiaryUpdated;
        RETURN;
    END

    EXEC DP_UpdateDateLogged @DiaryId, @DateLogged;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DiaryUpdated;
END;
GO

-- 4. Procedure to delete a diary entry
CREATE OR ALTER PROCEDURE DP_DeleteDiary
@DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        SELECT 0 AS DiaryDeleted;
        RETURN;
    END

    DELETE FROM Diaries WHERE diaryId = @DiaryId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DiaryDeleted;
END;
GO

-- 5. Procedure to get full row
CREATE OR ALTER PROCEDURE DP_GetDiary
@DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.DF_GetDiary(@DiaryId);
END;
GO

-- 6. Procedure to get dateLogged only
CREATE OR ALTER PROCEDURE DP_GetDateLogged
@DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.DF_GetDateLogged(@DiaryId) AS DateLogged;
END;
GO
