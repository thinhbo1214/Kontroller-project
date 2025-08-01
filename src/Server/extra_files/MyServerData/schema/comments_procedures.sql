-- #Comment table procedures

-- 1. Procedure to create a new comment
CREATE OR ALTER PROCEDURE CP_CreateComment
@Content NVARCHAR(MAX)
AS
BEGIN
    IF DBO.CF_IsContentLegality(@Content) = 0
    BEGIN
        SELECT NULL AS CommentId;
        RETURN;
    END;

    DECLARE @CommentId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Comments (commentId, content)
    VALUES (@CommentId, @Content);

    IF DBO.CF_CommentExists(@CommentId) = 0
    BEGIN
        SELECT NULL AS CommentId;
        RETURN;
    END;

    SELECT @CommentId AS CommentId;
END;
GO

-- 2. Procedure to update comment content
CREATE OR ALTER PROCEDURE CP_UpdateCommentContent
@CommentId UNIQUEIDENTIFIER,
@Content NVARCHAR(MAX)
AS
BEGIN
    IF DBO.CF_IsContentLegality(@Content) = 0
    BEGIN
        SELECT 0 AS ContentUpdated;
        RETURN;
    END;

    UPDATE Comments SET content = @Content WHERE commentId = @CommentId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ContentUpdated;
END;
GO

-- 3. Procedure to delete a comment
CREATE OR ALTER PROCEDURE CP_DeleteComment
@CommentId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.CF_CommentExists(@CommentId) = 0
    BEGIN
        SELECT 0 AS CommentDeleted;
        RETURN;
    END;

    DELETE FROM Comments WHERE commentId = @CommentId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS CommentDeleted;
END;
GO

-- 4. Procedure to get comment details
CREATE OR ALTER PROCEDURE CP_GetCommentDetails
@CommentId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.CF_GetComment(@CommentId);
END;
GO

-- 5. Procedure to get comment content
CREATE OR ALTER PROCEDURE CP_GetCommentContent
@CommentId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.CF_GetContent(@CommentId) AS Content;
END;
GO

-- 6. Procedure to get comment created date
CREATE OR ALTER PROCEDURE CP_GetCommentCreatedDate
@CommentId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.CF_GetCreatedAt(@CommentId) AS CreatedAt;
END;
GO
