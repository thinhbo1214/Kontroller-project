-- #User table functions
-- 1. Function to check if userId exists
CREATE OR ALTER FUNCTION UF_UserIdExists (
    @UserId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF @UserId IS NULL
    BEGIN
        RETURN 0; -- Return 0 if UserId is NULL
    END;

    DECLARE @Exists BIT;

    SELECT @Exists = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM [Users]
    WHERE userId = @UserId;

    RETURN @Exists;
END;
GO

-- 2. Function to get user details by userId
CREATE OR ALTER FUNCTION UF_GetUserDetails (
    @UserId UNIQUEIDENTIFIER
)
RETURNS TABLE
AS
RETURN 
(
    SELECT userId AS UserId, username AS Username, email AS Email, avatar AS Avatar, isLoggedIn AS IsLoggedIn
    FROM [Users]
    WHERE userId = @UserId
);
GO

-- 3. Function to get username by userId
CREATE OR ALTER FUNCTION UF_GetUsername (
    @UserId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(100)
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if UserId does not exist
    END;

    DECLARE @Username VARCHAR(100);
    SELECT @Username = username FROM [Users] WHERE userId = @UserId;
        RETURN @Username;
END;
GO

-- 4. Function to get user email by userId
CREATE OR ALTER FUNCTION UF_GetEmail (
    @UserId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(100)
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if UserId does not exist
    END;

    DECLARE @Email VARCHAR(100);

    SELECT @Email = email
    FROM [Users]
    WHERE userId = @UserId;

    RETURN @Email;
END;
GO

-- 5. Function to get user avatar by userId
CREATE OR ALTER FUNCTION UF_GetUserAvatar (
    @UserId UNIQUEIDENTIFIER
)
RETURNS VARCHAR(255)
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RETURN NULL; -- Return NULL if UserId does not exist
    END;

    DECLARE @Avatar VARCHAR(255);

    SELECT @Avatar = avatar
    FROM [Users]
    WHERE userId = @UserId;

    RETURN @Avatar;
END;
GO

-- 6. Function to check if user is logged in
CREATE OR ALTER FUNCTION UF_IsUserLoggedIn (
    @UserId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RETURN 0; -- Return 0 if UserId does not exist
    END;

    DECLARE @LoggedIn BIT;
    SELECT @LoggedIn = isLoggedIn
    FROM [Users]
    WHERE userId = @UserId;

        RETURN @LoggedIn;
    END;
GO

-- 7 Function to check password legality
CREATE OR ALTER FUNCTION UF_IsPasswordLegal (
    @Password VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Password IS NULL
    BEGIN
        RETURN 0; -- Return 0 if Password is NULL
    END;
    DECLARE @IsLegal BIT;

    SELECT @IsLegal = CASE 
        WHEN LEN(@Password) < 6 OR LEN(@Password) > 50 THEN 0
        WHEN @Password NOT LIKE '%[^a-zA-Z0-9!@#$%^&*()_+{}:<>?]%' THEN 1
        ELSE 0
    END;

    RETURN @IsLegal;
END;
GO

-- 8. Function to check username legality
CREATE OR ALTER FUNCTION UF_IsUsernameLegal (
    @Username VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Username IS NULL
    BEGIN
        RETURN 0; -- Return 0 if Username is NULL
    END;

    DECLARE @IsLegal BIT;

    SELECT @IsLegal = CASE 
        WHEN LEN(@Username) < 3 OR LEN(@Username) > 50 THEN 0
        WHEN @Username LIKE '%[^a-zA-Z0-9_ ]%' THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;
END;
GO

-- 9. Function to check email legality
CREATE OR ALTER FUNCTION UF_IsEmailLegal (
    @Email VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF @Email IS NULL
    BEGIN
        RETURN 0; -- Return 0 if Email is NULL
    END;

    DECLARE @IsLegal BIT;

    SELECT @IsLegal = CASE 
        WHEN LEN(@Email) < 5 OR LEN(@Email) > 100 THEN 0
        WHEN @Email NOT LIKE '%_@__%.__%' THEN 0
        ELSE 1
    END;

    RETURN @IsLegal;
END;
GO

-- 10. Function to check avatar legality
CREATE OR ALTER FUNCTION UF_IsAvatarLegal (
    @Avatar VARCHAR(255)
)
RETURNS BIT
AS
BEGIN
    RETURN DBO.F_IsUrlLegal(@Avatar);
END;
GO

-- 11. Function to check if a username exists
CREATE OR ALTER FUNCTION UF_UsernameExists (
    @Username VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Exists BIT;

    SELECT @Exists = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM [Users]
    WHERE username = @Username;

    RETURN @Exists;
END;
GO

-- 12. Function to check if an email exists
CREATE OR ALTER FUNCTION UF_EmailExists (
    @Email VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @Exists BIT;

    SELECT @Exists = CASE WHEN COUNT(*) > 0 THEN 1 ELSE 0 END
    FROM [Users]
    WHERE email = @Email;

    RETURN @Exists;
END;
GO

-- 13. Function to check password match
CREATE OR ALTER FUNCTION UF_IsPasswordMatch (
    @UserId UNIQUEIDENTIFIER,
    @Password VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RETURN 0; -- Return 0 if UserId does not exist
    END;

    DECLARE @Match BIT;

    SELECT @Match = CASE WHEN password_hash = HASHBYTES('SHA2_256', @Password) THEN 1 ELSE 0 END
    FROM [Users]
    WHERE userId = @UserId;

    RETURN @Match;
END;
GO

-- 14. Function to check if a username can be used
CREATE OR ALTER FUNCTION UF_IsUsernameUsable (
    @Username VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_IsUsernameLegal(@Username) = 0 OR DBO.UF_UsernameExists(@Username) = 1
    BEGIN
        RETURN 0; -- Return 0 if Username is not legal or if it already exists
    END;

    RETURN 1; -- Return 1 if Username is usable
END;
GO

-- 15. Function to check if an email can be used
CREATE OR ALTER FUNCTION UF_IsEmailUsable (
    @Email VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_IsEmailLegal(@Email) = 0 OR DBO.UF_EmailExists(@Email) = 1
    BEGIN
        RETURN 0; -- Return 0 if Email is not legal or if it already exists
    END;

    RETURN 1; -- Return 1 if Email is usable
END;
GO

-- 16. Function to check if user input is valid
CREATE OR ALTER FUNCTION UF_IsUserInputValid (
    @Username VARCHAR(100),
    @Password VARCHAR(100),
    @Email VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_IsUsernameUsable(@Username) = 0 OR 
       DBO.UF_IsPasswordLegal(@Password) = 0 OR 
       DBO.UF_IsEmailUsable(@Email) = 0
    BEGIN
        RETURN 0; -- Return 0 if any input is invalid
    END;

    RETURN 1; -- Return 1 if all inputs are valid
END;
GO


