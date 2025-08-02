-- DECLARE @Username varchar(100) = 'admin1'
-- DECLARE @Password varchar(100) = '!ZF$j#89YOV2'

BEGIN TRY
       EXEC DBO.UP_CheckLoginAccount @Username, @Password; -- Check if the account exists and return UsedId if success
END TRY
BEGIN CATCH
    SELECT NULL AS UserID;
END CATCH