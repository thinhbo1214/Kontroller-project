-- 1. Procedure to create new activity
CREATE OR ALTER PROCEDURE AP_CreateActivity
@Content NVARCHAR(MAX)
AS
BEGIN
    IF DBO.AF_IsContentLegal(@Content) = 0
    BEGIN
        SELECT NULL AS ActivityId;
        RETURN;
    END

    DECLARE @ActivityId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Activities (activityId, content)
    VALUES (@ActivityId, @Content);

    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
    BEGIN
        SELECT NULL AS ActivityId;
        RETURN;
    END

    SELECT @ActivityId AS ActivityId;
END;
GO

-- 2. Procedure to update content
CREATE OR ALTER PROCEDURE AP_UpdateContent
@ActivityId UNIQUEIDENTIFIER,
@Content NVARCHAR(MAX)
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0 OR
       DBO.AF_IsContentLegal(@Content) = 0
    BEGIN
        SELECT 0 AS ContentUpdated;
        RETURN;
    END

    UPDATE Activities
    SET content = @Content
    WHERE activityId = @ActivityId;

    SELECT @@ROWCOUNT AS ContentUpdated;
END;
GO

-- 3. Procedure to update all columns
CREATE OR ALTER PROCEDURE AP_UpdateActivity
@ActivityId UNIQUEIDENTIFIER,
@Content NVARCHAR(MAX)
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
    BEGIN
        SELECT 0 AS ActivityUpdated;
        RETURN;
    END

    EXEC AP_UpdateContent @ActivityId, @Content;

    SELECT @@ROWCOUNT AS ActivityUpdated;
END;
GO

-- 4. Procedure to delete activity
CREATE OR ALTER PROCEDURE AP_DeleteActivity
@ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
    BEGIN
        SELECT 0 AS ActivityDeleted;
        RETURN;
    END

    DELETE FROM Activities
    WHERE activityId = @ActivityId;

    SELECT @@ROWCOUNT AS ActivityDeleted;
END;
GO

-- 5. Procedure to get full row
CREATE OR ALTER PROCEDURE AP_GetActivity
@ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.AF_GetActivity(@ActivityId);
END;
GO

-- 6. Procedure to get content
CREATE OR ALTER PROCEDURE AP_GetContent
@ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.AF_GetContent(@ActivityId) AS Content;
END;
GO

-- 7. Procedure to get dateDo
CREATE OR ALTER PROCEDURE AP_GetDateDo
@ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.AF_GetDateDo(@ActivityId) AS DateDo;
END;
GO
