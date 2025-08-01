-- #Rate table procedures

-- 1. Procedure to create a new rate
CREATE OR ALTER PROCEDURE RP_CreateRate
@RateValue INT
AS
BEGIN
    IF DBO.RF_IsRateLegal(@RateValue) = 0
    BEGIN
        SELECT NULL AS RateId;
        RETURN;
    END;

    DECLARE @RateId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Rates (rateId, rateValue)
    VALUES (@RateId, @RateValue);

    IF DBO.RF_RateExists(@RateId) = 0
    BEGIN
        SELECT NULL AS RateId;
        RETURN;
    END;

    SELECT @RateId AS RateId;
END;
GO

-- 2. Procedure to update rate value
CREATE OR ALTER PROCEDURE RP_UpdateRateValue
@RateId UNIQUEIDENTIFIER,
@RateValue INT
AS
BEGIN
    IF DBO.RF_IsRateLegal(@RateValue) = 0
    BEGIN
        SELECT 0 AS RateUpdated;
        RETURN;
    END;

    UPDATE Rates SET rateValue = @RateValue WHERE rateId = @RateId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS RateUpdated;
END;
GO

-- 3. Procedure to delete a rate
CREATE OR ALTER PROCEDURE RP_DeleteRate
@RateId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_RateExists(@RateId) = 0
    BEGIN
        SELECT 0 AS RateDeleted;
        RETURN;
    END;

    DELETE FROM Rates WHERE rateId = @RateId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS RateDeleted;
END;
GO

-- 4. Procedure to get rate details
CREATE OR ALTER PROCEDURE RP_GetRateDetails
@RateId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.RF_GetRate(@RateId);
END;
GO

-- 5. Procedure to get rate value
CREATE OR ALTER PROCEDURE RP_GetRateValue
@RateId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.RF_GetValue(@RateId) AS RateValue;
END;
GO
