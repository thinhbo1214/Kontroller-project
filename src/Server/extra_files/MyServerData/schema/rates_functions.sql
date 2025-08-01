-- #Rate table functions

-- 1. Function to check if rate exists
CREATE OR ALTER FUNCTION RF_RateExists (
    @RateId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN 
    IF @RateId IS NULL
        RETURN 0;

    IF NOT EXISTS (SELECT 1 FROM Rates WHERE rateId = @RateId)
        RETURN 0;

    RETURN 1;
END;
GO

-- 2. Function to get rate by rateId
CREATE OR ALTER FUNCTION RF_GetRate (
    @RateId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN (
    SELECT * FROM Rates WHERE rateId = @RateId
);
GO

-- 3. Function to get rate value
CREATE OR ALTER FUNCTION RF_GetValue (
    @RateId UNIQUEIDENTIFIER
)
RETURNS INT
AS
BEGIN
    IF DBO.RF_RateExists(@RateId) = 0
        RETURN NULL;

    DECLARE @Value INT;
    SELECT @Value = rateValue FROM Rates WHERE rateId = @RateId;
    RETURN @Value;
END;
GO

-- 4. Function to check rate legality
CREATE OR ALTER FUNCTION RF_IsRateLegal (
    @RateValue INT
)
RETURNS BIT
AS
BEGIN
    IF @RateValue IS NULL OR @RateValue < 0 OR @RateValue > 10
        RETURN 0;

    RETURN 1;
END;
GO
