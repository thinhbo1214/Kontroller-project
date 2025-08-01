-- 1. Function to check if activityId exists
CREATE OR ALTER FUNCTION AF_ActivityIdExists (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @ActivityId IS NULL RETURN 0;

    DECLARE @Exists BIT;
    SELECT @Exists = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM Activities
    WHERE activityId = @ActivityId;

    RETURN @Exists;
END;
GO

-- 2. Function to get full row
CREATE OR ALTER FUNCTION AF_GetActivity (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN
    SELECT *
    FROM Activities
    WHERE activityId = @ActivityId;
GO

-- 3. Function to get content
CREATE OR ALTER FUNCTION AF_GetContent (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0 RETURN NULL;

    DECLARE @Content NVARCHAR(MAX);
    SELECT @Content = content
    FROM Activities
    WHERE activityId = @ActivityId;

    RETURN @Content;
END;
GO

-- 4. Function to get dateDo
CREATE OR ALTER FUNCTION AF_GetDateDo (
    @ActivityId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0 RETURN NULL;

    DECLARE @Date DATETIME;
    SELECT @Date = dateDo
    FROM Activities
    WHERE activityId = @ActivityId;

    RETURN @Date;
END;
GO

-- 5. Function to check if content is legal
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
