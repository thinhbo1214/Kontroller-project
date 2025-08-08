USE KontrollerDB;
GO

CREATE PROCEDURE LP_AddListItemsFromJson
    @JsonData NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO List_items (userId, title)
    SELECT 
        JSON_VALUE(value, '$.userId') AS userId,
        JSON_VALUE(value, '$.title') AS title
    FROM OPENJSON(@JsonData);
END
