-- #List table functions

-- 1. Function to check if list exists
CREATE OR ALTER FUNCTION LF_ListExists (
    @ListId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN 
    IF @ListId IS NULL
        RETURN 0;

    IF NOT EXISTS (SELECT 1 FROM Lists WHERE listId = @ListId)
        RETURN 0;

    RETURN 1;
END;
GO

-- 2. Function to get list by listId
CREATE OR ALTER FUNCTION LF_GetList (
    @ListId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM Lists WHERE listId = @ListId
);
GO

-- 3. Function to get name by listId
CREATE OR ALTER FUNCTION LF_GetName (
    @ListId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN
    IF DBO.LF_ListExists(@ListId) = 0
        RETURN NULL;

    DECLARE @_Name NVARCHAR(100);
    SELECT @_Name = _name FROM Lists WHERE listId = @ListId;
    RETURN @_Name;
END;
GO

-- 4. Function to get descriptions by listId
CREATE OR ALTER FUNCTION LF_GetDescriptions (
    @ListId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.LF_ListExists(@ListId) = 0
        RETURN NULL;

    DECLARE @Descriptions NVARCHAR(MAX);
    SELECT @Descriptions = descriptions FROM Lists WHERE listId = @ListId;
    RETURN @Descriptions;
END;
GO

-- 5. Function to get created date
CREATE OR ALTER FUNCTION LF_GetCreatedAt (
    @ListId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.LF_ListExists(@ListId) = 0
        RETURN NULL;

    DECLARE @CreatedAt DATETIME;
    SELECT @CreatedAt = created_at FROM Lists WHERE listId = @ListId;
    RETURN @CreatedAt;
END;
GO

-- 6. Function to check name legality
CREATE OR ALTER FUNCTION LF_IsNameLegal (
    @Name NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Name IS NULL OR @Name = ''
        RETURN 0;

    RETURN 1;
END;
GO

-- 7. Function to check description legality
CREATE OR ALTER FUNCTION LF_IsDescriptionLegal (
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


    RETURN 1;
END;
GO
