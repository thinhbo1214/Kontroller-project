-- 1. Function to check if diaryId exists
CREATE OR ALTER FUNCTION DF_DiaryIdExists (
    @DiaryId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @DiaryId IS NULL
        RETURN 0;

    RETURN (
        SELECT CASE WHEN EXISTS (
            SELECT 1 FROM Diaries WHERE diaryId = @DiaryId
        ) THEN 1 ELSE 0 END
    );
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
