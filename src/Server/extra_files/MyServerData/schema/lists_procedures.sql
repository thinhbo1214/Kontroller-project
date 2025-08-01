-- #List table procedures

-- 1. Procedure to create a new list
CREATE OR ALTER PROCEDURE LP_CreateList
@Name NVARCHAR(100),
@Descriptions NVARCHAR(MAX) = NULL
AS
BEGIN
    IF DBO.LF_IsNameLegal(@Name) = 0 OR
        DBO.LF_IsDescriptionLegal(@Descriptions) = 0
    BEGIN
        SELECT NULL AS ListId;
        RETURN;
    END;

    DECLARE @ListId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Lists (listId, _name, descriptions)
    VALUES (@ListId, @Name, @Descriptions);

    IF DBO.LF_ListExists(@ListId) = 0
    BEGIN
        SELECT NULL AS ListId;
        RETURN;
    END;

    SELECT @ListId AS ListId;
END;
GO

-- 2. Procedure to update list name
CREATE OR ALTER PROCEDURE LP_UpdateListName
@ListId UNIQUEIDENTIFIER,
@Name NVARCHAR(100)
AS
BEGIN
    IF DBO.LF_IsNameLegal(@Name) = 0
    BEGIN
        SELECT 0 AS NameUpdated;
        RETURN;
    END;

    UPDATE Lists SET _name = @Name WHERE listId = @ListId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS NameUpdated;
END;
GO

-- 3. Procedure to update list descriptions
CREATE OR ALTER PROCEDURE LP_UpdateListDescriptions
@ListId UNIQUEIDENTIFIER,
@Descriptions NVARCHAR(MAX)
AS
BEGIN
    IF DBO.LF_IsDescriptionLegal(@Descriptions) = 0
    BEGIN
        SELECT 0 AS DescriptionsUpdated;
        RETURN;
    END;

    UPDATE Lists SET descriptions = @Descriptions WHERE listId = @ListId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DescriptionsUpdated;
END;
GO

-- 4. Procedure to update list name and descriptions
CREATE OR ALTER PROCEDURE LP_UpdateListDetails
@ListId UNIQUEIDENTIFIER,
@Name NVARCHAR(100),
@Descriptions NVARCHAR(MAX)
AS
BEGIN
    IF DBO.LF_ListExists(@ListId) = 0
    BEGIN
        SELECT 0 AS DetailsUpdated;
        RETURN;
    END;

    EXEC LP_UpdateListName @ListId, @Name;
    EXEC LP_UpdateListDescriptions @ListId, @Descriptions;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DetailsUpdated;
END;
GO

-- 5. Procedure to delete a list
CREATE OR ALTER PROCEDURE LP_DeleteList
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.LF_ListExists(@ListId) = 0
    BEGIN
        SELECT 0 AS ListDeleted;
        RETURN;
    END;

    DELETE FROM Lists WHERE listId = @ListId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ListDeleted;
END;
GO

-- 6. Procedure to get list details
CREATE OR ALTER PROCEDURE LP_GetListDetails
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.LF_GetList(@ListId);
END;
GO

-- 7. Procedure to get list name
CREATE OR ALTER PROCEDURE LP_GetListName
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.LF_GetName(@ListId) AS Name;
END;
GO

-- 8. Procedure to get list descriptions
CREATE OR ALTER PROCEDURE LP_GetListDescriptions
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.LF_GetDescriptions(@ListId) AS Descriptions;
END;
GO

-- 9. Procedure to get list created date
CREATE OR ALTER PROCEDURE LP_GetListCreatedDate
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.LF_GetCreatedAt(@ListId) AS CreatedAt;
END;
GO
