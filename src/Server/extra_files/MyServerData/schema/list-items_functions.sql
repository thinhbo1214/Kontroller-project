-- 1. Function to check if listItemId exists
CREATE OR ALTER FUNCTION LIF_ListItemIdExists (
    @ListItemId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @ListItemId IS NULL RETURN 0;

    DECLARE @Exists BIT;
    SELECT @Exists = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM List_items
    WHERE listItemId = @ListItemId;

    RETURN @Exists;
END;
GO

-- 2. Function to get full row by ID
CREATE OR ALTER FUNCTION LIF_GetListItem (
    @ListItemId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM List_items
    WHERE listItemId = @ListItemId
);
GO

-- 3. Function to get title by ID
CREATE OR ALTER FUNCTION LIF_GetTitle (
    @ListItemId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(100)
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0
        RETURN NULL;

    DECLARE @Result NVARCHAR(100) = NULL;

    SELECT @Result = title
    FROM List_items
    WHERE listItemId = @ListItemId;

    RETURN @Result;
END;
GO

-- 4. Function to check if title is legal
CREATE OR ALTER FUNCTION LIF_IsTitleLegal (
    @Title NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Title IS NULL OR LEN(@Title) = 0 RETURN 0;
    RETURN 1;
END;
GO
