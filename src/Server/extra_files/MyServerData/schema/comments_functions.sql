-- #Comment table functions

-- 1. Function to check if comment exists
CREATE OR ALTER FUNCTION CF_CommentExists (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN 
    IF @CommentId IS NULL
        RETURN 0;

    IF NOT EXISTS (SELECT 1 FROM Comments WHERE commentId = @CommentId)
        RETURN 0;

    RETURN 1;
END;
GO

-- 2. Function to get comment by commentId
CREATE OR ALTER FUNCTION CF_GetComment (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM Comments WHERE commentId = @CommentId
);
GO

-- 3. Function to get content by commentId
CREATE OR ALTER FUNCTION CF_GetContent (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.CF_CommentExists(@CommentId) = 0
        RETURN NULL;

    DECLARE @Content NVARCHAR(MAX);
    SELECT @Content = content FROM Comments WHERE commentId = @CommentId;
    RETURN @Content;
END;
GO

-- 4. Function to get created_at by commentId
CREATE OR ALTER FUNCTION CF_GetCreatedAt (
    @CommentId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.CF_CommentExists(@CommentId) = 0
        RETURN NULL;

    DECLARE @CreatedAt DATETIME;
    SELECT @CreatedAt = created_at FROM Comments WHERE commentId = @CommentId;
    RETURN @CreatedAt;
END;
GO

-- 5. Function to check content legality
CREATE OR ALTER FUNCTION CF_IsContentLegality (
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
