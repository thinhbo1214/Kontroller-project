-- #User table procedures

-- 1. Procedure to create a new user
CREATE OR ALTER PROCEDURE UP_CreateUser
@Username VARCHAR(100) = NULL,
@Password VARCHAR(100) = NULL,
@Email VARCHAR(100) = NULL
AS
BEGIN
    IF DBO.UF_IsUserInputValid(@Username, @Password, @Email) = 0
    BEGIN
        RAISERROR('User input is not valid', 16, 1);
        RETURN;
    END;

    INSERT INTO Users (username, password_hash, email)
    VALUES (@username, HASHBYTES('SHA2_256', @password), @email);
END;
GO

-- 2. Procedure to update username
CREATE OR ALTER PROCEDURE UP_UpdateUsername
@UserId UNIQUEIDENTIFIER,
@NewUsername VARCHAR(100)
AS
BEGIN
    IF DBO.UF_IsUsernameUsable(@NewUsername) = 0
    BEGIN
        RAISERROR('Username is not usable', 16, 1);
        RETURN;
    END;

    UPDATE Users SET username = @NewUsername WHERE UserId = @UserId;
END;
GO

-- 3. Procedure to update user email
CREATE OR ALTER PROCEDURE UP_UpdateUserEmail
@UserId UNIQUEIDENTIFIER,
@NewEmail VARCHAR(100)
AS
BEGIN
    IF DBO.UF_IsEmailUsable(@NewEmail) = 0
    BEGIN
        RAISERROR('Email is not usable', 16, 1);
        RETURN;
    END;

    UPDATE Users SET email = @NewEmail WHERE UserId = @UserId;
END;
GO

-- 4. Procedure to update user avatar
CREATE OR ALTER PROCEDURE UP_UpdateUserAvatar
@UserId UNIQUEIDENTIFIER,
@NewAvatar VARCHAR(255)
AS
BEGIN
    IF DBO.UF_IsAvatarLegal(@NewAvatar) = 0
    BEGIN
        RAISERROR('Avatar is not legal', 16, 1);
        RETURN;
    END;

    UPDATE Users SET avatar = @NewAvatar WHERE UserId = @UserId;
END;
GO

-- 5. Procedure to update user login status
CREATE OR ALTER PROCEDURE UP_UpdateUserLoginStatus
@UserId UNIQUEIDENTIFIER,
@IsLoggedIn BIT
AS
BEGIN
    IF @IsLoggedIn IS NULL
    BEGIN
        RAISERROR('IsLoggedIn cannot be NULL', 16, 1);
        RETURN;
    END;

    UPDATE Users SET isLoggedIn = @IsLoggedIn WHERE UserId = @UserId;
END;
GO

-- 6. Procedure to update password
CREATE OR ALTER PROCEDURE UP_UpdatePassword
@UserId UNIQUEIDENTIFIER,
@NewPassword VARCHAR(100)
AS
BEGIN
    IF DBO.UF_IsPasswordLegal(@NewPassword) = 0
    BEGIN
        RAISERROR('Password is not legal', 16, 1);
        RETURN;
    END;
    UPDATE Users SET password_hash = HASHBYTES('SHA2_256', @NewPassword) WHERE UserId = @UserId;
END;
GO

-- 7. Procedure to update user details
CREATE OR ALTER PROCEDURE UP_UpdateUserDetails
@UserId UNIQUEIDENTIFIER,
@Username VARCHAR(100) = NULL,
@Password VARCHAR(100) = NULL,
@Email VARCHAR(100) = NULL,
@Avatar VARCHAR(255) = NULL,
@IsUserLoggedIn BIT = NULL
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RAISERROR('UserId does not exist', 16, 1);
        RETURN;
    END;

    EXEC DBO.UP_UpdateUsername @UserId, @Username;
    
    EXEC DBO.UP_UpdatePassword @UserId, @Password;

    EXEC DBO.UP_UpdateUserEmail @UserId, @Email;

    EXEC DBO.UP_UpdateUserAvatar @UserId, @Avatar;

    EXEC DBO.UP_UpdateUserLoginStatus @UserId, @IsUserLoggedIn;

END;
GO

-- 8. Procedure to delete a user
CREATE OR ALTER PROCEDURE UP_DeleteUser
@UserId UNIQUEIDENTIFIER,
@Password VARCHAR(100) = NULL
AS
BEGIN

    IF DBO.UF_IsPasswordMatch(@UserId, @Password) = 0
    BEGIN
        RAISERROR('Password does not match', 16, 1);
        RETURN;
    END;

    DELETE FROM Users WHERE UserId = @UserId;
END;
GO

-- 9. Procedure to check if a user is logged in
CREATE OR ALTER PROCEDURE UP_CheckUserLoggedIn
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RAISERROR('UserId does not exist', 16, 1);
        RETURN;
    END;

    SELECT DBO.UF_IsUserLoggedIn(@UserId);
END;
GO

-- 10. Procedure to get user details
CREATE OR ALTER PROCEDURE UP_GetUserDetails
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
    RAISERROR('UserId does not exist', 16, 1);
    RETURN;
    END;
    SELECT * FROM UF_GetUserDetails(@UserId);
END;
GO

-- 11. Procedure to get user avatar and username
CREATE OR ALTER PROCEDURE UP_GetUserDisplayInfo
@UserId UNIQUEIDENTIFIER
AS
BEGIN

    SELECT DBO.UF_GetUserAvatar(@UserId) AS Avatar, DBO.UF_GetUsername(@UserId) AS Username;
END;   
GO

-- 12. Procedure to get user email
CREATE OR ALTER PROCEDURE UP_GetUserEmail
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.UF_GetEmail(@UserId) AS Email;
END;
GO

-- 13. Procedure to get user username
CREATE OR ALTER PROCEDURE UP_GetUserUsername
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.UF_GetUsername(@UserId) AS Username;
END;
GO

-- 14. Procedure to get user avatar
CREATE OR ALTER PROCEDURE UP_GetUserAvatar
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.UF_GetUserAvatar(@UserId) AS Avatar;
END;
GO

-- 15. Procedure to get user login status
CREATE OR ALTER PROCEDURE UP_GetUserLoginStatus
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.UF_IsUserLoggedIn(@UserId) AS IsLoggedIn;
END;
GO

