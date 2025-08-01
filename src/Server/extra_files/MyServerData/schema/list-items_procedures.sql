-- 1. Procedure to create a new list item
CREATE OR ALTER PROCEDURE LIP_CreateListItem
@Title NVARCHAR(100)
AS
BEGIN
    IF DBO.LIF_IsTitleLegal(@Title) = 0
    BEGIN
        SELECT NULL AS ListItemId;
        RETURN;
    END

    DECLARE @ListItemId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO List_items (listItemId, title)
    VALUES (@ListItemId, @Title);

    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0
    BEGIN
        SELECT NULL AS ListItemId;
        RETURN;
    END

    SELECT @ListItemId AS ListItemId;
END;
GO

-- 2. Procedure to update title
CREATE OR ALTER PROCEDURE LIP_UpdateTitle
@ListItemId UNIQUEIDENTIFIER,
@Title NVARCHAR(100)
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0 OR
       DBO.LIF_IsTitleLegal(@Title) = 0
    BEGIN
        SELECT 0 AS TitleUpdated;
        RETURN;
    END

    UPDATE List_items SET title = @Title WHERE listItemId = @ListItemId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS TitleUpdated;
END;
GO

-- 3. Procedure to update all columns
CREATE OR ALTER PROCEDURE LIP_UpdateListItem
@ListItemId UNIQUEIDENTIFIER,
@Title NVARCHAR(100)
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0
    BEGIN
        SELECT 0 AS ListItemUpdated;
        RETURN;
    END

    EXEC LIP_UpdateTitle @ListItemId, @Title;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ListItemUpdated;
END;
GO

-- 4. Procedure to delete a list item
CREATE OR ALTER PROCEDURE LIP_DeleteListItem
@ListItemId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0
    BEGIN
        SELECT 0 AS ListItemDeleted;
        RETURN;
    END

    DELETE FROM List_items WHERE listItemId = @ListItemId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ListItemDeleted;
END;
GO

-- 5. Procedure to get full row
CREATE OR ALTER PROCEDURE LIP_GetListItem
@ListItemId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.LIF_GetListItem(@ListItemId);
END;
GO

-- 6. Procedure to get title only
CREATE OR ALTER PROCEDURE LIP_GetTitle
@ListItemId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.LIF_GetTitle(@ListItemId) AS Title;
END;
GO


