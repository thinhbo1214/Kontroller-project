-- #Review table function
-- 1. Function to check if review exists
CREATE OR ALTER FUNCTION RF_ReviewExists (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN 
    IF @ReviewId IS NULL
    BEGIN
        RETURN 0; -- Return 0 if ReviewId is NULL
    END;

    IF NOT EXISTS (SELECT 1 FROM [Reviews] WHERE ReviewId = @ReviewId)
    BEGIN
        RETURN 0; -- Return 0 if ReviewId does not exist
    END;

    RETURN 1;
END;
GO

-- 2. Function to get review by reviewId
CREATE OR ALTER FUNCTION RF_GetReview (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN(
    SELECT * FROM [Reviews] WHERE ReviewId = @ReviewId
)
GO

-- 3. Function to get content by reviewId
CREATE OR ALTER FUNCTION RF_GetContent (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    IF DBO.RF_ReviewExists(@ReviewId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if ReviewId does not exist
    END;

    DECLARE @Content NVARCHAR(MAX);
    SELECT @Content = Content FROM [Reviews] WHERE ReviewId = @ReviewId;
    RETURN @Content;
END;
GO

-- 4. Function to get rating by reviewId
CREATE OR ALTER FUNCTION RF_GetRating (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS DECIMAL(4,2)
AS
BEGIN
    IF DBO.RF_ReviewExists(@ReviewId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if ReviewId does not exist
    END;

    DECLARE @Rating DECIMAL(4,2);
    SELECT @Rating = Rating FROM [Reviews] WHERE ReviewId = @ReviewId;
    RETURN @Rating;
END;
GO

-- 5. Function to get dateCreated by reviewId
CREATE OR ALTER FUNCTION RF_GetDateCreated (
    @ReviewId UNIQUEIDENTIFIER
)
RETURNS DATETIME
AS
BEGIN
    IF DBO.RF_ReviewExists(@ReviewId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if ReviewId does not exist
    END;

    DECLARE @DateCreated DATETIME;
    SELECT @DateCreated = DateCreated FROM [Reviews] WHERE ReviewId = @ReviewId;
    RETURN @DateCreated;
END;
GO

-- 6. Function to check content legality
CREATE OR ALTER FUNCTION RF_IsContentLegality (
    @Content NVARCHAR(MAX)
)
RETURNS BIT
AS
BEGIN
    IF @Content IS NULL OR @Content = ''
    BEGIN
        RETURN 0; -- Return 0 if content is empty or null
    END;

    DECLARE @IsLegal BIT;
        SELECT @IsLegal = CASE 
        WHEN LEN(@Content) < 1 OR LEN(@Content) > 4000 THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;  
END;
GO

-- 7. Function to check rating legality
CREATE OR ALTER FUNCTION RF_IsRatingLegality (
    @Rating DECIMAL(4,2)
)
RETURNS BIT
AS
BEGIN
    IF @Rating IS NULL OR @Rating < 0 OR @Rating > 10
    BEGIN
        RETURN 0; -- Return 0 if rating is invalid
    END;

    RETURN 1;
END;
GO











