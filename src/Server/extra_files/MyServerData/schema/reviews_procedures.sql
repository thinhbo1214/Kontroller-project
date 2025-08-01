-- #Review table procedures
-- 1. Procedure to create a new review
CREATE OR ALTER PROCEDURE RP_CreateReview
@Content NVARCHAR(MAX)
AS
BEGIN
    IF DBO.RF_IsContentLegality(@Content) = 0
    BEGIN
        SELECT NULL AS ReviewId;
        RETURN;
    END;

    DECLARE @ReviewId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO [Reviews] (reviewId, content)
    VALUES (@ReviewId,@Content);

    IF DBO.RF_ReviewExists(@ReviewId) = 0
    BEGIN
        SELECT NULL AS ReviewId;
        RETURN;
    END;

    SELECT @ReviewId AS ReviewId;
END;
GO

-- 2. Procedure to update review content
CREATE OR ALTER PROCEDURE RP_UpdateReviewContent
@ReviewId UNIQUEIDENTIFIER,
@Content NVARCHAR(MAX)
AS
BEGIN
    IF DBO.RF_IsContentLegality(@Content) = 0
    BEGIN
        SELECT 0 AS ContentUpdated;
        RETURN;
    END;

    UPDATE [Reviews] SET content = @Content WHERE reviewId = @ReviewId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ContentUpdated;
END;
GO

-- 3. Procedure to update review rating
CREATE OR ALTER PROCEDURE RP_UpdateReviewRating
@ReviewId UNIQUEIDENTIFIER,
@Rating DECIMAL(4,2)
AS
BEGIN
    IF DBO.RF_IsRatingLegality(@Rating) = 0
    BEGIN
        SELECT 0 AS RatingUpdated;
        RETURN;
    END;

    UPDATE [Reviews] SET rating = @Rating WHERE reviewId = @ReviewId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS RatingUpdated;
END;
GO

-- 4. Procedure to uodate review details
CREATE OR ALTER PROCEDURE RP_UpdateReviewDetails
@ReviewId UNIQUEIDENTIFIER,
@Content NVARCHAR(MAX),
@Rating DECIMAL(4,2)
AS
BEGIN
    IF DBO.RF_ReviewExists(@ReviewId) = 0
    BEGIN
        SELECT 0 AS DetailsUpdated;
        RETURN;
    END;

    EXEC RP_UpdateReviewContent @ReviewId, @Content;
    EXEC RP_UpdateReviewRating @ReviewId, @Rating;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ReviewUpdated;
END;
GO

-- 5. Procedure to delete a review
CREATE OR ALTER PROCEDURE RP_DeleteReview
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_ReviewExists(@ReviewId) = 0
    BEGIN
        SELECT 0 AS ReviewDeleted;
        RETURN;
    END;

    DELETE [Reviews] WHERE reviewId = @ReviewId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ReviewDeleted;
END;
GO

-- 6. Procedure to get review details
CREATE OR ALTER PROCEDURE RP_GetReviewDetails
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.RF_GetReview(@ReviewId);
END;
GO

-- 7. Procedure to get review content
CREATE OR ALTER PROCEDURE RP_GetReviewContent
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.RF_GetContent(@ReviewId) AS Content;
END;
GO

-- 8. Procedure to get review rating
CREATE OR ALTER PROCEDURE RP_GetReviewRating
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.RF_GetRating(@ReviewId) AS Rating;
END;
GO

-- 9. Procedure to get review date
CREATE OR ALTER PROCEDURE RP_GetReviewDate
@ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.RF_GetDateCreated(@ReviewId) AS Date;
END;
GO







    

