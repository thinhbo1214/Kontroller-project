/*
    Database: KontrollerDB
    Description: Database for a game management system, storing information about users, games, reviews, comments, reactions, lists, activities, diaries, and their relationships.
*/
USE KontrollerDB;
GO

/* 
    Procedure: HP_GenerateStrongPassword
    Description: Generates a strong random password with specified length, ensuring at least one uppercase, lowercase, digit, and special character.
    Parameters:
        @Length (INT): Desired password length (default 12, must be 8-50).
        @Password (VARCHAR(100) OUTPUT): The generated password.
    Returns:
        @Password: A random strong password or NULL if length is invalid.
*/
CREATE OR ALTER PROCEDURE HP_GenerateStrongPassword
    @Length INT = 12,
    @Password VARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate password length */
    IF @Length < 8 OR @Length > 50
    BEGIN
        SET @Password = NULL;
        RETURN;
    END

    /* Define character sets for password generation */
    DECLARE @UpperChars VARCHAR(26) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    DECLARE @LowerChars VARCHAR(26) = 'abcdefghijklmnopqrstuvwxyz';
    DECLARE @Digits VARCHAR(10)     = '0123456789';
    DECLARE @SpecialChars VARCHAR(20) = '!@#$%^&*()_+{}:<>?';
    DECLARE @AllChars VARCHAR(100) = @UpperChars + @LowerChars + @Digits + @SpecialChars;

    DECLARE @Result VARCHAR(100) = '';

    /* Ensure at least one character from each set */
    SET @Result = 
        SUBSTRING(@UpperChars, CAST(RAND(CHECKSUM(NEWID())) * LEN(@UpperChars) + 1 AS INT), 1) +
        SUBSTRING(@LowerChars, CAST(RAND(CHECKSUM(NEWID())) * LEN(@LowerChars) + 1 AS INT), 1) +
        SUBSTRING(@Digits,     CAST(RAND(CHECKSUM(NEWID())) * LEN(@Digits)     + 1 AS INT), 1) +
        SUBSTRING(@SpecialChars, CAST(RAND(CHECKSUM(NEWID())) * LEN(@SpecialChars) + 1 AS INT), 1);

    /* Generate remaining characters */
    DECLARE @i INT = LEN(@Result) + 1;
    WHILE @i <= @Length
    BEGIN
        SET @Result = @Result + SUBSTRING(@AllChars, CAST(RAND(CHECKSUM(NEWID())) * LEN(@AllChars) + 1 AS INT), 1);
        SET @i = @i + 1;
    END

    /* Shuffle the password for randomness */
    DECLARE @Shuffled VARCHAR(100) = '';
    DECLARE @len INT = LEN(@Result);
    DECLARE @pos INT;

    WHILE LEN(@Result) > 0
    BEGIN
        SET @pos = CAST(RAND(CHECKSUM(NEWID())) * LEN(@Result) + 1 AS INT);
        SET @Shuffled = @Shuffled + SUBSTRING(@Result, @pos, 1);
        SET @Result = STUFF(@Result, @pos, 1, '');
    END

    SET @Password = @Shuffled;
END
GO

/*
Example usage:
    EXEC HP_PaginateQuery
        @fromClause = 'Games',
        @orderColumn = 'gameId',
        @page = 1,
        @limit = 10,
        @columns = '*';

Example Full usage:
    EXEC HP_PaginateQuery
    @fromClause = 'Review_Comment rc JOIN Comments c ON rc.commentId = c.commentId',
    @orderColumn = 'c.commentId',
    @page = 1,
    @limit = 10,
    @columns = 'c.commentId AS CommentID, c.content AS Content, c.dateCreated' AS DateCreated,
    @filterColumn = 'rc.reviewId',
    @filterValue = '5509ae55-bdee-46bf-8e8a-0efac4fbd524';
*/
CREATE OR ALTER PROCEDURE HP_PaginateQuery
    @fromClause NVARCHAR(MAX),
    @orderColumn NVARCHAR(MAX),
    @page INT,
    @limit INT,
    @columns NVARCHAR(MAX),
    @filterColumn NVARCHAR(MAX) = NULL,
    @filterValue NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @offset INT = (@page - 1) * @limit;

    SET @sql = N'
        SELECT ' + @columns + '
        FROM ' + @fromClause + '
        ' + CASE 
                WHEN @filterColumn IS NOT NULL AND @filterValue IS NOT NULL
                THEN 'WHERE ' + @filterColumn + ' = @filterValue'
                ELSE ''
            END + '
        ORDER BY ' + @orderColumn + '
        OFFSET ' + CAST(@offset AS NVARCHAR) + ' ROWS
        FETCH NEXT ' + CAST(@limit AS NVARCHAR) + ' ROWS ONLY;
    ';

    EXEC sp_executesql @sql, N'@filterValue NVARCHAR(MAX)', @filterValue=@filterValue;
END
GO


/* 
    Procedure: UP_CreateUser
    Description: Creates a new user with a unique ID, username, hashed password, and email.
    Parameters:
        @Username (VARCHAR(100)): Username for the new user.
        @Password (VARCHAR(100)): Password to be hashed.
        @Email (VARCHAR(100)): User's email address.
        @NewUserId (UNIQUEIDENTIFIER OUTPUT): Generated ID for the new user.
    Returns:
        @NewUserId: The ID of the created user or NULL if creation fails.
*/
CREATE OR ALTER PROCEDURE UP_CreateUser
    @Username VARCHAR(100) = NULL,
    @Password VARCHAR(100) = NULL,
    @Email VARCHAR(100) = NULL,
    @NewUserId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate input parameters */
    IF DBO.UF_IsUserInputValid(@Username, @Password, @Email) = 0
    BEGIN
        SET @NewUserId = NULL;
        RETURN;
    END

    /* Generate new user ID */
    SET @NewUserId = NEWID();

    /* Insert user with hashed password */
    INSERT INTO [Users] (userId, username, password_hash, email)
    VALUES (@NewUserId, @Username, HASHBYTES('SHA2_256', @Password), @Email);

    /* Verify insertion success */
    IF DBO.UF_UserIdExists(@NewUserId) = 0
    BEGIN
        SET @NewUserId = NULL;
        RETURN;
    END
END
GO

/* 
    Procedure: UP_UpdateUserUsername
    Description: Updates the username of an existing user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @NewUsername (VARCHAR(100)): New username.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_UpdateUserUsername
    @UserId UNIQUEIDENTIFIER,
    @NewUsername VARCHAR(100),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new username */
    IF DBO.UF_IsUsernameUsable(@NewUsername) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update username */
    UPDATE [Users] SET username = @NewUsername WHERE UserId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: UP_UpdateUserEmail
    Description: Updates the email address of an existing user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @NewEmail (VARCHAR(100)): New email address.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_UpdateUserEmail
    @UserId UNIQUEIDENTIFIER,
    @NewEmail VARCHAR(100),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new email */
    IF DBO.UF_IsEmailUsable(@NewEmail) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update email */
    UPDATE [Users] SET email = @NewEmail WHERE UserId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: UP_UpdateUserAvatar
    Description: Updates the avatar of an existing user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @NewAvatar (VARCHAR(255)): New avatar URL or path.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_UpdateUserAvatar
    @UserId UNIQUEIDENTIFIER,
    @NewAvatar VARCHAR(255),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new avatar */
    IF DBO.UF_IsAvatarLegal(@NewAvatar) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update avatar */
    UPDATE [Users] SET avatar = @NewAvatar WHERE UserId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: UP_UpdateUserLoginStatus
    Description: Updates the login status of an existing user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @IsLoggedIn (BIT): New login status (1 for logged in, 0 for logged out).
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_UpdateUserLoginStatus
    @UserId UNIQUEIDENTIFIER,
    @IsLoggedIn BIT,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate login status */
    IF @IsLoggedIn IS NULL
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update login status */
    UPDATE [Users] SET isLoggedIn = @IsLoggedIn WHERE UserId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: UP_UpdateUserPassword
    Description: Updates the password of an existing user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @NewPassword (VARCHAR(100)): New password to be hashed.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_UpdateUserPassword
    @UserId UNIQUEIDENTIFIER,
    @NewPassword VARCHAR(100),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new password */
    IF DBO.UF_IsPasswordLegal(@NewPassword) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update password with hashed value */
    UPDATE [Users] SET password_hash = HASHBYTES('SHA2_256', @NewPassword) WHERE UserId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: UP_UpdateUserIncreaseFollowing
    Description: Increments the number of users the specified user is following.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_UpdateUserIncreaseFollowing
    @UserId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Increment numberFollowing */
    UPDATE [Users] SET numberFollowing += 1 WHERE userId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: UP_UpdateUserDecreaseFollowing
    Description: Decrements the number of users the specified user is following.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_UpdateUserDecreaseFollowing
    @UserId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Decrement numberFollowing */
    UPDATE [Users] SET numberFollowing -= 1 WHERE userId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: UP_UpdateUserIncreaseFollower
    Description: Increments the number of followers for the specified user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_UpdateUserIncreaseFollower
    @UserId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Increment numberFollower */
    UPDATE [Users] SET numberFollower += 1 WHERE userId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: UP_UpdateUserDecreaseFollower
    Description: Decrements the number of followers for the specified user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_UpdateUserDecreaseFollower
    @UserId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Decrement numberFollower */
    UPDATE [Users] SET numberFollower -= 1 WHERE userId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: UP_UpdateUserIncreaseList
    Description: Increments the number of lists owned by the specified user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_UpdateUserIncreaseList
    @UserId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Increment numberList */
    UPDATE [Users] SET numberList += 1 WHERE userId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: UP_UpdateUserDecreaseList
    Description: Decrements the number of lists owned by the specified user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_UpdateUserDecreaseList
    @UserId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Decrement numberList */
    UPDATE [Users] SET numberList -= 1 WHERE userId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: UP_UpdateUserAll
    Description: Updates multiple user details (username, password, email, avatar, login status) in a single call.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @Username (VARCHAR(100)): New username (optional).
        @Password (VARCHAR(100)): New password (optional).
        @Email (VARCHAR(100)): New email (optional).
        @Avatar (VARCHAR(255)): New avatar (optional).
        @IsUserLoggedIn (BIT): New login status (optional).
        @Result (INT OUTPUT): Total number of rows affected by all updates.
    Returns:
        @Result: Sum of rows affected by individual update procedures.
*/
CREATE OR ALTER PROCEDURE UP_UpdateUserAll
    @UserId UNIQUEIDENTIFIER,
    @Username VARCHAR(100) = NULL,
    @Password VARCHAR(100) = NULL,
    @Email VARCHAR(100) = NULL,
    @Avatar VARCHAR(255) = NULL,
    @IsUserLoggedIn BIT = NULL,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Initialize result */
    SET @Result = 0;

    /* Validate user ID */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    DECLARE @Temp INT = 0;

    /* Update username if provided */
    IF @Username IS NOT NULL
    BEGIN
        EXEC DBO.UP_UpdateUserUsername @UserId, @Username, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END

    /* Update password if provided */
    IF @Password IS NOT NULL
    BEGIN
        EXEC DBO.UP_UpdateUserPassword @UserId, @Password, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END

    /* Update email if provided */
    IF @Email IS NOT NULL
    BEGIN
        EXEC DBO.UP_UpdateUserEmail @UserId, @Email, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END

    /* Update avatar if provided */
    IF @Avatar IS NOT NULL
    BEGIN
        EXEC DBO.UP_UpdateUserAvatar @UserId, @Avatar, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END

    /* Update login status if provided */
    IF @IsUserLoggedIn IS NOT NULL
    BEGIN
        EXEC DBO.UP_UpdateUserLoginStatus @UserId, @IsUserLoggedIn, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END
END
GO

/* 
    Procedure: UP_DeleteUser
    Description: Deletes a user after verifying their password.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to delete.
        @Password (VARCHAR(100)): Password to verify user identity.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_DeleteUser
    @UserId UNIQUEIDENTIFIER,
    @Password VARCHAR(100) = NULL,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify password */
    IF DBO.UF_IsPasswordMatch(@UserId, @Password) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Delete user */
    DELETE FROM [Users] WHERE UserId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;

    /* Verify deletion success */
    IF DBO.UF_UserIdExists(@UserId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END
END
GO

/* 
    Procedure: UP_CheckUserLoggedIn
    Description: Checks if a user is logged in.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to check.
    Returns:
        BIT: 1 if user is logged in, 0 otherwise (via UF_IsUserLoggedIn function).
*/
CREATE OR ALTER PROCEDURE UP_CheckUserLoggedIn
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Return login status */
    SELECT DBO.UF_IsUserLoggedIn(@UserId) AS IsUserLoggedIn;
END
GO

/* 
    Procedure: UP_GetUserAll
    Description: Retrieves all details for a specified user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to query.
    Returns:
        TABLE: All columns from UF_GetUserAll function.
*/
CREATE OR ALTER PROCEDURE UP_GetUserAll
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Return user details */
    SELECT * FROM DBO.UF_GetUserAll(@UserId);
END
GO

/* 
    Procedure: UP_GetUserDisplayInfo
    Description: Retrieves the avatar and username for a specified user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to query.
    Returns:
        TABLE: Avatar and Username from UF_GetUserAvatar and UF_GetUsername functions.
*/
CREATE OR ALTER PROCEDURE UP_GetUserDisplayInfo
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Return avatar and username */
    SELECT DBO.UF_GetUserAvatar(@UserId) AS Avatar, DBO.UF_GetUserUsername(@UserId) AS Username;
END
GO

/* 
    Procedure: UP_GetUserEmail
    Description: Retrieves the email address for a specified user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to query.
    Returns:
        VARCHAR(100): User's email address or NULL if not found.
*/
CREATE OR ALTER PROCEDURE UP_GetUserEmail
    @UserId UNIQUEIDENTIFIER,
    @Email VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return email */
    SET @Email = DBO.UF_GetUserEmail(@UserId);
END
GO

/* 
    Procedure: UP_GetUserUsername
    Description: Retrieves the username for a specified user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to query.
    Returns:
        VARCHAR(100): User's username or NULL if not found.
*/
CREATE OR ALTER PROCEDURE UP_GetUserUsername
    @UserId UNIQUEIDENTIFIER,
    @Username VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return username */
    SET @Username = DBO.UF_GetUserUsername(@UserId);
END
GO

/* 
    Procedure: UP_GetUserAvatar
    Description: Retrieves the avatar for a specified user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to query.
    Returns:
        VARCHAR(255): User's avatar URL or NULL if not found.
*/
CREATE OR ALTER PROCEDURE UP_GetUserAvatar
    @UserId UNIQUEIDENTIFIER,
    @Avatar VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return avatar */
    SET @Avatar = DBO.UF_GetUserAvatar(@UserId);
END
GO

/* 
    Procedure: UP_GetUserLoginStatus
    Description: Retrieves the login status for a specified user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to query.
    Returns:
        BIT: 1 if user is logged in, 0 otherwise.
*/
CREATE OR ALTER PROCEDURE UP_GetUserLoginStatus
    @UserId UNIQUEIDENTIFIER,
    @IsLoggedIn BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return login status */
    SET @IsLoggedIn = DBO.UF_IsUserLoggedIn(@UserId);
END
GO

/* 
    Procedure: UP_GetUserNumberFollower
    Description: Retrieves the number of followers for a specified user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to query.
    Returns:
        INT: Number of followers or NULL if not found.
*/
CREATE OR ALTER PROCEDURE UP_GetUserNumberFollower
    @UserId UNIQUEIDENTIFIER,
    @NumberFollower INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return number of followers */
    SET @NumberFollower =  DBO.UF_GetUserNumberFollower(@UserId);
END
GO

/* 
    Procedure: UP_GetUserNumberFollowing
    Description: Retrieves the number of users the specified user is following.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to query.
    Returns:
        INT: Number of users being followed or NULL if not found.
*/
CREATE OR ALTER PROCEDURE UP_GetUserNumberFollowing
    @UserId UNIQUEIDENTIFIER,
    @NumberFollowing INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return number of users being followed */
    SET @NumberFollowing = DBO.UF_GetUserNumberFollowing(@UserId);
END
GO

/* 
    Procedure: UP_GetUserNumberList
    Description: Retrieves the number of lists owned by the specified user.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to query.
    Returns:
        INT: Number of lists or NULL if not found.
*/
CREATE OR ALTER PROCEDURE UP_GetUserNumberList
    @UserId UNIQUEIDENTIFIER,
    @NumberList INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return number of lists */
    SET @NumberList = DBO.UF_GetUserNumberList(@UserId);
END
GO

/* 
    Procedure: UP_CheckUserExists
    Description: Checks if a user exists by their ID.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to check.
    Returns:
        BIT: 1 if user exists, 0 otherwise.
*/
CREATE OR ALTER PROCEDURE UP_CheckUserExists
    @UserId UNIQUEIDENTIFIER,
    @UserIdExists BIT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return existence status */
    SET @UserIdExists = DBO.UF_UserIdExists(@UserId);
END
GO

/* 
    Procedure: UP_CheckLoginAccount
    Description: Verifies user login credentials and retrieves user ID.
    Parameters:
        @Username (VARCHAR(100)): Username to verify.
        @Password (VARCHAR(100)): Password to verify.
        @UserId (UNIQUEIDENTIFIER OUTPUT): ID of the verified user.
    Returns:
        @UserId: User ID if credentials are valid, NULL otherwise.
*/
CREATE OR ALTER PROCEDURE UP_CheckLoginAccount
    @Username VARCHAR(100),
    @Password VARCHAR(100),
    @UserId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate username and password */
    IF DBO.UF_IsUsernameLegal(@Username) = 0 
        OR DBO.UF_IsPasswordLegal(@Password) = 0
        OR DBO.UF_UsernameExists(@Username) = 0
    BEGIN
        SET @UserId = NULL;
        RETURN;
    END

    /* Retrieve user ID */
    SELECT @UserId = userId FROM [Users] WHERE username = @Username;

    /* Verify password match */
    IF DBO.UF_IsPasswordMatch(@UserId, @Password) = 0
    BEGIN
        SET @UserId = NULL;
        RETURN;
    END
END
GO

/* 
    Procedure: UP_ForgetPassword
    Description: Generates and updates a new password for a user based on their email.
    Parameters:
        @Email (VARCHAR(100)): User's email address.
        @NewPassword (VARCHAR(100) OUTPUT): Generated new password.
    Returns:
        @NewPassword: New password or NULL if email is invalid or update fails.
*/
CREATE OR ALTER PROCEDURE UP_ForgetPassword
    @Email VARCHAR(100),
    @NewPassword VARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @UserId UNIQUEIDENTIFIER;

    /* Check if email exists and get UserId */
    SELECT @UserId = userId FROM [Users] WHERE email = @Email;

    IF @UserId IS NULL
    BEGIN
        SET @NewPassword = NULL;
        RETURN;
    END

    /* Generate new password */
    EXEC HP_GenerateStrongPassword @Length = 12, @Password = @NewPassword OUTPUT;

    /* Update password */
    UPDATE [Users] SET password_hash = HASHBYTES('SHA2_256', @NewPassword)
    WHERE userId = @UserId;

    /* Verify update success */
    IF @@ROWCOUNT = 0
    BEGIN
        SET @NewPassword = NULL;
        RETURN;
    END
END
GO

/* 
    Procedure: UP_ChangePassword
    Description: Changes a user's password after verifying the old password.
    Parameters:
        @UserId (UNIQUEIDENTIFIER): ID of the user to update.
        @OldPassword (VARCHAR(100)): Current password for verification.
        @NewPassword (VARCHAR(100)): New password to set.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE UP_ChangePassword
    @UserId UNIQUEIDENTIFIER,
    @OldPassword VARCHAR(100),
    @NewPassword VARCHAR(100),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify user existence */
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Verify old password */
    IF DBO.UF_IsPasswordMatch(@UserId, @OldPassword) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Validate new password */
    IF DBO.UF_IsPasswordLegal(@NewPassword) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update password */
    UPDATE [Users] SET password_hash = HASHBYTES('SHA2_256', @NewPassword)
    WHERE userId = @UserId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: GP_CreateGame
    Description: Creates a new game with title, genre, description, and details.
    Parameters:
        @Title (NVARCHAR(100)): Game title.
        @Genre (NVARCHAR(100)): Game genre.
        @Description (NVARCHAR(MAX)): Game description.
        @Details (NVARCHAR(MAX)): Additional game details.
        @GameId (UNIQUEIDENTIFIER OUTPUT): Generated ID for the new game.
    Returns:
        @GameId: The ID of the created game or NULL if creation fails.
*/
CREATE OR ALTER PROCEDURE GP_CreateGame
    @Title NVARCHAR(100),
    @Genre NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @Details NVARCHAR(MAX),
    @GameId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate input parameters */
    IF DBO.GF_IsGameTitleLegal(@Title) = 0 
        OR DBO.GF_IsGameGenreLegal(@Genre) = 0 
        OR DBO.GF_IsGameDescriptionLegal(@Description) = 0
        OR DBO.GF_IsGameDetailsLegal(@Details) = 0
    BEGIN
        SET @GameId = NULL;
        RETURN;
    END

    /* Generate new game ID */
    SET @GameId = NEWID();

    /* Insert game data */
    INSERT INTO [Games] (gameId, title, genre, descriptions, details)
    VALUES (@GameId, @Title, @Genre, @Description, @Details);

    /* Verify insertion success */
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        SET @GameId = NULL;
        RETURN;
    END
END
GO

/* 
    Procedure: GP_UpdateGameTitle
    Description: Updates the title of an existing game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to update.
        @NewTitle (NVARCHAR(100)): New game title.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE GP_UpdateGameTitle
    @GameId UNIQUEIDENTIFIER,
    @NewTitle NVARCHAR(100),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new title */
    IF DBO.GF_IsGameTitleLegal(@NewTitle) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update game title */
    UPDATE [Games] SET title = @NewTitle WHERE gameId = @GameId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: GP_UpdateGameGenre
    Description: Updates the genre of an existing game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to update.
        @NewGenre (NVARCHAR(100)): New game genre.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE GP_UpdateGameGenre
    @GameId UNIQUEIDENTIFIER,
    @NewGenre NVARCHAR(100),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new genre */
    IF DBO.GF_IsGameGenreLegal(@NewGenre) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update game genre */
    UPDATE [Games] SET genre = @NewGenre WHERE gameId = @GameId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: GP_UpdateGameDescription
    Description: Updates the description of an existing game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to update.
        @NewDescription (NVARCHAR(MAX)): New game description.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE GP_UpdateGameDescription
    @GameId UNIQUEIDENTIFIER,
    @NewDescription NVARCHAR(MAX),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new description */
    IF DBO.GF_IsGameDescriptionLegal(@NewDescription) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update game description */
    UPDATE [Games] SET descriptions = @NewDescription WHERE gameId = @GameId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: GP_UpdateGameDetails
    Description: Updates the details of an existing game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to update.
        @NewDetails (NVARCHAR(MAX)): New game details.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE GP_UpdateGameDetails
    @GameId UNIQUEIDENTIFIER,
    @NewDetails NVARCHAR(MAX),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new details */
    IF DBO.GF_IsGameDetailsLegal(@NewDetails) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update game details */
    UPDATE [Games] SET details = @NewDetails WHERE gameId = @GameId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: GP_UpdateGamePoster
    Description: Updates the poster URL of an existing game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to update.
        @NewPoster (VARCHAR(255)): New poster URL.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE GP_UpdateGamePoster
    @GameId UNIQUEIDENTIFIER,
    @NewPoster VARCHAR(255),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new poster */
    IF DBO.GF_IsGamePosterLegal(@NewPoster) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update game poster */
    UPDATE [Games] SET poster = @NewPoster WHERE gameId = @GameId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: GP_UpdateGameBackdrop
    Description: Updates the backdrop URL of an existing game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to update.
        @NewBackdrop (VARCHAR(255)): New backdrop URL.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE GP_UpdateGameBackdrop
    @GameId UNIQUEIDENTIFIER,
    @NewBackdrop VARCHAR(255),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new backdrop */
    IF DBO.GF_IsGameBackdropLegal(@NewBackdrop) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update game backdrop */
    UPDATE [Games] SET backdrop = @NewBackdrop WHERE gameId = @GameId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

CREATE OR ALTER PROCEDURE GP_UpdateGameAvgRating
    @GameId UNIQUEIDENTIFIER,
    @NewAvgRating DECIMAL(4,2),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Update game backdrop */
    UPDATE [Games] SET avgRating = @NewAvgRating WHERE gameId = @GameId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: GP_UpdateGameAll
    Description: Updates multiple game attributes (title, genre, description, details, poster, backdrop) in a single call.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to update.
        @Title (NVARCHAR(100)): New game title (optional).
        @Genre (NVARCHAR(100)): New game genre (optional).
        @Descriptions (NVARCHAR(MAX)): New game description (optional).
        @Details (NVARCHAR(MAX)): New game details (optional).
        @Poster (VARCHAR(255)): New poster URL (optional).
        @Backdrop (VARCHAR(255)): New backdrop URL (optional).
        @Result (INT OUTPUT): Total number of rows affected by all updates.
    Returns:
        @Result: Sum of rows affected by individual update procedures.
*/
CREATE OR ALTER PROCEDURE GP_UpdateGameAll
    @GameId UNIQUEIDENTIFIER,
    @Title NVARCHAR(100) = NULL,
    @Genre NVARCHAR(100) = NULL,
    @Descriptions NVARCHAR(MAX) = NULL,
    @Details NVARCHAR(MAX) = NULL,
    @Poster VARCHAR(255) = NULL,
    @Backdrop VARCHAR(255) = NULL,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Initialize result */
    SET @Result = 0;

    /* Validate game ID */
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    DECLARE @Temp INT;

    /* Update title if provided */
    IF @Title IS NOT NULL
    BEGIN
        EXEC DBO.GP_UpdateGameTitle @GameId, @Title, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END

    /* Update genre if provided */
    IF @Genre IS NOT NULL
    BEGIN
        EXEC DBO.GP_UpdateGameGenre @GameId, @Genre, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END

    /* Update description if provided */
    IF @Descriptions IS NOT NULL
    BEGIN
        EXEC DBO.GP_UpdateGameDescription @GameId, @Descriptions, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END

    /* Update details if provided */
    IF @Details IS NOT NULL
    BEGIN
        EXEC DBO.GP_UpdateGameDetails @GameId, @Details, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END

    /* Update poster if provided */
    IF @Poster IS NOT NULL
    BEGIN
        EXEC DBO.GP_UpdateGamePoster @GameId, @Poster, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END

    /* Update backdrop if provided */
    IF @Backdrop IS NOT NULL
    BEGIN
        EXEC DBO.GP_UpdateGameBackdrop @GameId, @Backdrop, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END
END
GO

/* 
    Procedure: GP_UpdateGameIncreaseReview
    Description: Increments the number of reviews for the specified game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE GP_UpdateGameIncreaseReview
    @GameId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate game ID */
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Increment numberReview */
    UPDATE [Games] SET numberReview += 1 WHERE gameId = @GameId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: GP_UpdateGameDecreaseReview
    Description: Decrements the number of reviews for the specified game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE GP_UpdateGameDecreaseReview
    @GameId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate game ID */
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Decrement numberReview */
    UPDATE [Games] SET numberReview -= 1 WHERE gameId = @GameId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: GP_DeleteGame
    Description: Deletes a game by its ID.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to delete.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE GP_DeleteGame
    @GameId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify game existence */
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Delete game */
    DELETE FROM [Games] WHERE gameId = @GameId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;

    /* Verify deletion success */
    IF DBO.GF_GameIdExists(@GameId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END
END
GO

/* 
    Procedure: GP_GetGameAll
    Description: Retrieves all information for a specified game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to query.
    Returns:
        TABLE: All columns from GF_GetGameAll function.
*/
CREATE OR ALTER PROCEDURE GP_GetGameAll
    @GameId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Return game details */
    SELECT * FROM DBO.GF_GetGameAll(@GameId);
END
GO

/* 
    Procedure: GP_GetGameTitle
    Description: Retrieves the title of a specified game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to query.
    Returns:
        NVARCHAR(100): Game title or NULL if not found.
*/
CREATE OR ALTER PROCEDURE GP_GetGameTitle
    @GameId UNIQUEIDENTIFIER,
    @Title NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return game title */
    SET @Title =  DBO.GF_GetGameTitle(@GameId);
END
GO

/* 
    Procedure: GP_GetGameGenre
    Description: Retrieves the genre of a specified game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to query.
    Returns:
        NVARCHAR(100): Game genre or NULL if not found.
*/
CREATE OR ALTER PROCEDURE GP_GetGameGenre
    @GameId UNIQUEIDENTIFIER,
    @Genre NVARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return game genre */
    SET @Genre =  DBO.GF_GetGameGenre(@GameId);
END
GO

/* 
    Procedure: GP_GetGameDescription
    Description: Retrieves the description of a specified game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to query.
    Returns:
        NVARCHAR(MAX): Game description or NULL if not found.
*/
CREATE OR ALTER PROCEDURE GP_GetGameDescription
    @GameId UNIQUEIDENTIFIER,
    @Description NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return game description */
    SET @Description = DBO.GF_GetGameDescription(@GameId);
END
GO

/* 
    Procedure: GP_GetGameDetails
    Description: Retrieves the details of a specified game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to query.
    Returns:
        NVARCHAR(MAX): Game details or NULL if not found.
*/
CREATE OR ALTER PROCEDURE GP_GetGameDetails
    @GameId UNIQUEIDENTIFIER,
    @Details NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return game details */
    SET @Details =  DBO.GF_GetGameDetails(@GameId);
END
GO

/* 
    Procedure: GP_GetGamePoster
    Description: Retrieves the poster URL of a specified game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to query.
    Returns:
        VARCHAR(255): Game poster URL or NULL if not found.
*/
CREATE OR ALTER PROCEDURE GP_GetGamePoster
    @GameId UNIQUEIDENTIFIER,
    @Poster VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return game poster */
    SET @Poster = DBO.GF_GetGamePoster(@GameId);
END
GO

/* 
    Procedure: GP_GetGameBackdrop
    Description: Retrieves the backdrop URL of a specified game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to query.
    Returns:
        VARCHAR(255): Game backdrop URL or NULL if not found.
*/
CREATE OR ALTER PROCEDURE GP_GetGameBackdrop
    @GameId UNIQUEIDENTIFIER,
    @Backdrop VARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return game backdrop */
    SET @Backdrop = DBO.GF_GetGameBackdrop(@GameId);
END
GO

CREATE OR ALTER PROCEDURE GP_GetGameAvgRating
    @GameId UNIQUEIDENTIFIER,
    @AvgRating DECIMAL(4,2) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return game backdrop */
    SET @AvgRating =  DBO.GF_GetGameAvgRating(@GameId);
END
GO



/* 
    Procedure: GP_GetGameNumberReview
    Description: Retrieves the number of reviews for a specified game.
    Parameters:
        @GameId (UNIQUEIDENTIFIER): ID of the game to query.
    Returns:
        INT: Number of reviews or NULL if not found.
*/
CREATE OR ALTER PROCEDURE GP_GetGameNumberReview
    @GameId UNIQUEIDENTIFIER,
    @NumberReview INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return number of reviews */
    SET @NumberReview = DBO.GF_GetGameNumberReview(@GameId);
END
GO

CREATE OR ALTER PROCEDURE GP_GetGamePaginate
    @Page INT = 1,
    @Limit INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    IF @Page < 1 SET @Page = 1;
    IF @Limit < 1 SET @Limit = 10;

    EXEC DBO.HP_PaginateQuery 
    @fromClause = 'Games', 
    @orderColumn = 'gameId',
    @page = @Page, 
    @limit = @Limit, 
    @columns = 'gameId AS GameId,title AS Title,
    descriptions AS Descriptions,
    genre AS Genre, 
    avgRating AS AvgRating,
    poster AS Poster,
    backdrop AS Backdrop,
    details AS Details,
    numberReview AS NumberReview';
    
END
GO

/* 
    Procedure: RP_CreateReview
    Description: Creates a new review with specified content.
    Parameters:
        @Content (NVARCHAR(MAX)): Review content.
        @ReviewId (UNIQUEIDENTIFIER OUTPUT): Generated ID for the new review.
    Returns:
        @ReviewId: The ID of the created review or NULL if creation fails.
*/
CREATE OR ALTER PROCEDURE RP_CreateReview
    @Content NVARCHAR(MAX),
	@Rating DECIMAL(4,2),
    @ReviewId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate review content */
    IF DBO.RF_IsContentLegal(@Content) = 0
    BEGIN
        SET @ReviewId = NULL;
        RETURN;
    END

    /* Generate new review ID */
    SET @ReviewId = NEWID();

    /* Insert review data */
    INSERT INTO [Reviews] (reviewId, content, rating)
    VALUES (@ReviewId, @Content, @Rating);

    /* Verify insertion success */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @ReviewId = NULL;
        RETURN;
    END
END
GO

/* 
    Procedure: RP_UpdateReviewContent
    Description: Updates the content of an existing review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to update.
        @Content (NVARCHAR(MAX)): New review content.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE RP_UpdateReviewContent
    @ReviewId UNIQUEIDENTIFIER,
    @Content NVARCHAR(MAX),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new content */
    IF DBO.RF_IsContentLegal(@Content) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update review content */
    UPDATE [Reviews] SET content = @Content WHERE reviewId = @ReviewId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: RP_UpdateReviewRating
    Description: Updates the rating of an existing review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to update.
        @Rating (DECIMAL(4,2)): New rating value.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE RP_UpdateReviewRating
    @ReviewId UNIQUEIDENTIFIER,
    @Rating DECIMAL(4,2),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new rating */
    IF DBO.RF_IsRatingLegal(@Rating) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update review rating */
    UPDATE [Reviews] SET rating = @Rating WHERE reviewId = @ReviewId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: RP_UpdateReviewAll
    Description: Updates both content and rating of an existing review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to update.
        @Content (NVARCHAR(MAX)): New review content.
        @Rating (DECIMAL(4,2)): New rating value.
        @Result (INT OUTPUT): Total number of rows affected by updates.
    Returns:
        @Result: Sum of rows affected by content and rating updates.
*/
CREATE OR ALTER PROCEDURE RP_UpdateReviewAll
    @ReviewId UNIQUEIDENTIFIER,
    @Content NVARCHAR(MAX),
    @Rating DECIMAL(4,2),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Initialize result */
    SET @Result = 0;

    /* Validate review ID */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    DECLARE @Temp INT;

    /* Update content if provided */
    IF @Content IS NOT NULL
    BEGIN
        EXEC RP_UpdateReviewContent @ReviewId, @Content, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END

    /* Update rating if provided */
    IF @Rating IS NOT NULL
    BEGIN
        EXEC RP_UpdateReviewRating @ReviewId, @Rating, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END
END
GO

/* 
    Procedure: RP_UpdateReviewIncreaseReaction
    Description: Increments the number of reactions for the specified review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE RP_UpdateReviewIncreaseReaction
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate review ID */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Increment numberReaction */
    UPDATE [Reviews] SET numberReaction += 1 WHERE reviewId = @ReviewId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: RP_UpdateReviewDecreaseReaction
    Description: Decrements the number of reactions for the specified review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE RP_UpdateReviewDecreaseReaction
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate review ID */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Decrement numberReaction */
    UPDATE [Reviews] SET numberReaction -= 1 WHERE reviewId = @ReviewId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: RP_UpdateReviewIncreaseComment
    Description: Increments the number of comments for the specified review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE RP_UpdateReviewIncreaseComment
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate review ID */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Increment numberComment */
    UPDATE [Reviews] SET numberComment += 1 WHERE reviewId = @ReviewId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: RP_UpdateReviewDecreaseComment
    Description: Decrements the number of comments for the specified review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE RP_UpdateReviewDecreaseComment
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate review ID */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Decrement numberComment */
    UPDATE [Reviews] SET numberComment -= 1 WHERE reviewId = @ReviewId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: RP_DeleteReview
    Description: Deletes a review by its ID.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to delete.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE RP_DeleteReview
    @ReviewId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify review existence */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        SET @Result = 1;
        RETURN;
    END

    /* Delete review */
    DELETE FROM [Reviews] WHERE reviewId = @ReviewId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;

    /* Verify deletion success */
    IF DBO.RF_ReviewIdExists(@ReviewId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END
END
GO

CREATE OR ALTER PROCEDURE RP_DeleteReviews
    @ReviewIds IdList READONLY,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DeletedCount INT = 0;

    /* Xóa các review tồn tại */
    DELETE FROM [Reviews]
    WHERE reviewId IN (
        SELECT Id 
        FROM @ReviewIds
        WHERE DBO.RF_ReviewIdExists(Id) = 1
    );

    SET @DeletedCount = @@ROWCOUNT;

    /* Kiểm tra còn tồn tại review nào trong danh sách không */
    IF EXISTS (
        SELECT 1
        FROM @ReviewIds r
        WHERE DBO.RF_ReviewIdExists(r.Id) = 1
    )
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Trả về số lượng xóa thành công */
    SET @Result = @DeletedCount;
END
GO


/* 
    Procedure: RP_GetReviewAll
    Description: Retrieves all details for a specified review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to query.
    Returns:
        TABLE: All columns from RF_GetReviewAll function.
*/
CREATE OR ALTER PROCEDURE RP_GetReviewAll
    @ReviewId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Return review details */
    SELECT * FROM DBO.RF_GetReviewAll(@ReviewId);
END
GO

/* 
    Procedure: RP_GetReviewContent
    Description: Retrieves the content of a specified review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to query.
    Returns:
        NVARCHAR(MAX): Review content or NULL if not found.
*/
CREATE OR ALTER PROCEDURE RP_GetReviewContent
    @ReviewId UNIQUEIDENTIFIER,
    @Content NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return review content */
    SET @Content = DBO.RF_GetReviewContent(@ReviewId);
END
GO

/* 
    Procedure: RP_GetReviewRating
    Description: Retrieves the rating of a specified review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to query.
    Returns:
        DECIMAL(4,2): Review rating or NULL if not found.
*/
CREATE OR ALTER PROCEDURE RP_GetReviewRating
    @ReviewId UNIQUEIDENTIFIER,
    @Rating INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return review rating */
    SET @Rating = DBO.RF_GetReviewRating(@ReviewId);
END
GO

/* 
    Procedure: RP_GetReviewDateCreated
    Description: Retrieves the creation date of a specified review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to query.
    Returns:
        DATETIME: Review creation date or NULL if not found.
*/
CREATE OR ALTER PROCEDURE RP_GetReviewDateCreated
    @ReviewId UNIQUEIDENTIFIER,
    @DateCreated DATETIME OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return review creation date */
    SET @DateCreated = DBO.RF_GetReviewDateCreated(@ReviewId);
END
GO

/* 
    Procedure: RP_GetReviewNumberReaction
    Description: Retrieves the number of reactions for a specified review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to query.
    Returns:
        INT: Number of reactions or NULL if not found.
*/
CREATE OR ALTER PROCEDURE RP_GetReviewNumberReaction
    @ReviewId UNIQUEIDENTIFIER,
    @NumberReaction INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return number of reactions */
    SET @NumberReaction = DBO.RF_GetReviewNumberReaction(@ReviewId);
END
GO

/* 
    Procedure: RP_GetReviewNumberComment
    Description: Retrieves the number of comments for a specified review.
    Parameters:
        @ReviewId (UNIQUEIDENTIFIER): ID of the review to query.
    Returns:
        INT: Number of comments or NULL if not found.
*/
CREATE OR ALTER PROCEDURE RP_GetReviewNumberComment
    @ReviewId UNIQUEIDENTIFIER,
    @NumberComment INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return number of comments */
    SET @NumberComment = DBO.RF_GetReviewNumberComment(@ReviewId);
END
GO

/* 
    Procedure: CP_CreateComment
    Description: Creates a new comment with specified content.
    Parameters:
        @Content (NVARCHAR(MAX)): Comment content.
        @CommentId (UNIQUEIDENTIFIER OUTPUT): Generated ID for the new comment.
    Returns:
        @CommentId: The ID of the created comment or NULL if creation fails.
*/
CREATE OR ALTER PROCEDURE CP_CreateComment
    @Content NVARCHAR(MAX),
    @CommentId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate comment content */
    IF DBO.CF_IsContentLegal(@Content) = 0
    BEGIN
        SET @CommentId = NULL;
        RETURN;
    END

    /* Generate new comment ID */
    SET @CommentId = NEWID();

    /* Insert comment data */
    INSERT INTO [Comments] (commentId, content)
    VALUES (@CommentId, @Content);

    /* Verify insertion success */
    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        SET @CommentId = NULL;
        RETURN;
    END
END
GO

/* 
    Procedure: CP_UpdateCommentContent
    Description: Updates the content of an existing comment.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to update.
        @Content (NVARCHAR(MAX)): New comment content.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE CP_UpdateCommentContent
    @CommentId UNIQUEIDENTIFIER,
    @Content NVARCHAR(MAX),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new content */
    IF DBO.CF_IsContentLegal(@Content) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update comment content */
    UPDATE [Comments] SET content = @Content WHERE commentId = @CommentId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: CP_UpdateCommentIncreaseReaction
    Description: Increments the number of reactions for the specified comment.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE CP_UpdateCommentIncreaseReaction
    @CommentId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate comment ID */
    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Increment numberReaction */
    UPDATE [Comments] SET numberReaction += 1 WHERE commentId = @CommentId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: CP_UpdateCommentDecreaseReaction
    Description: Decrements the number of reactions for the specified comment.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE CP_UpdateCommentDecreaseReaction
    @CommentId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate comment ID */
    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Decrement numberReaction */
    UPDATE [Comments] SET numberReaction -= 1 WHERE commentId = @CommentId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: CP_DeleteComment
    Description: Deletes a comment by its ID.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to delete.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE CP_DeleteComment
    @CommentId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify comment existence */
    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        SET @Result = 1;
        RETURN;
    END

    /* Delete comment */
    DELETE FROM [Comments] WHERE commentId = @CommentId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;

    /* Verify deletion success */
    IF DBO.CF_CommentIdExists(@CommentId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END
END
GO

CREATE OR ALTER PROCEDURE CP_DeleteComments
    @CommentIds IdList READONLY,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra danh sách có rỗng không
    IF NOT EXISTS (SELECT 1 FROM @CommentIds)
    BEGIN
        SET @Result = 1;
        RETURN;
    END

    DECLARE @DeletedCount INT = 0;

    -- Xoá từng comment nếu tồn tại
    DELETE FROM [Comments]
    WHERE commentId IN (
        SELECT Id FROM @CommentIds
        WHERE DBO.CF_CommentIdExists(Id) = 1
    );

    SET @DeletedCount = @@ROWCOUNT;

    -- Kiểm tra còn tồn tại không
    IF EXISTS (
        SELECT 1
        FROM @CommentIds c
        WHERE DBO.CF_CommentIdExists(c.Id) = 1
    )
    BEGIN
        -- Còn ít nhất 1 comment chưa bị xoá
        SET @Result = 0;
        RETURN;
    END

    -- Tất cả đã xoá thành công
    SET @Result = @DeletedCount;
END
GO


/* 
    Procedure: CP_GetCommentAll
    Description: Retrieves all details for a specified comment.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to query.
    Returns:
        TABLE: All columns from CF_GetCommentAll function.
*/
CREATE OR ALTER PROCEDURE CP_GetCommentAll
    @CommentId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Return comment details */
    SELECT * FROM DBO.CF_GetCommentAll(@CommentId);
END
GO

/* 
    Procedure: CP_GetCommentContent
    Description: Retrieves the content of a specified comment.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to query.
    Returns:
        NVARCHAR(MAX): Comment content or NULL if not found.
*/
CREATE OR ALTER PROCEDURE CP_GetCommentContent
    @CommentId UNIQUEIDENTIFIER,
    @Content NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return comment content */
    SET @Content = DBO.CF_GetCommentContent(@CommentId);
END
GO

/* 
    Procedure: CP_GetCommentCreatedAt
    Description: Retrieves the creation date of a specified comment.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to query.
    Returns:
        DATETIME: Comment creation date or NULL if not found.
*/
CREATE OR ALTER PROCEDURE CP_GetCommentCreatedAt
    @CommentId UNIQUEIDENTIFIER,
    @CreatedAt DATETIME OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return comment creation date */
    SET @CreatedAt =  DBO.CF_GetCommentCreatedAt(@CommentId);
END
GO

/* 
    Procedure: CP_GetCommentNumberReaction
    Description: Retrieves the number of reactions for a specified comment.
    Parameters:
        @CommentId (UNIQUEIDENTIFIER): ID of the comment to query.
    Returns:
        INT: Number of reactions or NULL if not found.
*/
CREATE OR ALTER PROCEDURE CP_GetCommentNumberReaction
    @CommentId UNIQUEIDENTIFIER,
    @NumberReaction INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return number of reactions */
    SET @NumberReaction = DBO.CF_GetCommentNumberReaction(@CommentId);
END
GO

/* 
    Procedure: LP_CreateList
    Description: Creates a new list with specified title and optional description.
    Parameters:
        @Title (NVARCHAR(100)): List title.
        @Descriptions (NVARCHAR(MAX)): List description (optional).
        @ListId (UNIQUEIDENTIFIER OUTPUT): Generated ID for the new list.
    Returns:
        @ListId: The ID of the created list or NULL if creation fails.
*/
CREATE OR ALTER PROCEDURE LP_CreateList
    @Title NVARCHAR(100),
    @Descriptions NVARCHAR(MAX) = NULL,
    @ListId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate list title and description */
    IF DBO.LF_IsListTitleLegal(@Title) = 0 OR
        DBO.LF_IsListDescriptionLegal(@Descriptions) = 0
    BEGIN
        SET @ListId = NULL;
        RETURN;
    END

    /* Generate new list ID */
    SET @ListId = NEWID();

    /* Insert list data */
    INSERT INTO [Lists] (listId, title, descriptions)
    VALUES (@ListId, @Title, @Descriptions);

    /* Verify insertion success */
    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        SET @ListId = NULL;
        RETURN;
    END
END
GO

/* 
    Procedure: LP_UpdateListTitle
    Description: Updates the title of an existing list.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to update.
        @Title (NVARCHAR(100)): New list title.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE LP_UpdateListTitle
    @ListId UNIQUEIDENTIFIER,
    @Title NVARCHAR(100),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new list title */
    IF DBO.LF_IsListTitleLegal(@Title) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update list title */
    UPDATE [Lists] SET title = @Title WHERE listId = @ListId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: LP_UpdateListDescriptions
    Description: Updates the description of an existing list.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to update.
        @Descriptions (NVARCHAR(MAX)): New list description.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE LP_UpdateListDescriptions
    @ListId UNIQUEIDENTIFIER,
    @Descriptions NVARCHAR(MAX),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate new description */
    IF DBO.LF_IsListDescriptionLegal(@Descriptions) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update list description */
    UPDATE [Lists] SET descriptions = @Descriptions WHERE listId = @ListId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: LP_UpdateListAll
    Description: Updates both title and description of an existing list.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to update.
        @Title (NVARCHAR(100)): New list title.
        @Descriptions (NVARCHAR(MAX)): New list description.
        @Result (INT OUTPUT): Total number of rows affected by updates.
    Returns:
        @Result: Sum of rows affected by title and description updates.
*/
CREATE OR ALTER PROCEDURE LP_UpdateListAll
    @ListId UNIQUEIDENTIFIER,
    @Title NVARCHAR(100),
    @Descriptions NVARCHAR(MAX),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Initialize result */
    SET @Result = 0;

    /* Validate list ID */
    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    DECLARE @Temp INT;

    /* Update list title if provided */
    IF @Title IS NOT NULL
    BEGIN
        EXEC LP_UpdateListTitle @ListId, @Title, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END

    /* Update list description if provided */
    IF @Descriptions IS NOT NULL
    BEGIN
        EXEC LP_UpdateListDescriptions @ListId, @Descriptions, @Result = @Temp OUTPUT;
        SET @Result += @Temp;
    END
END
GO

/* 
    Procedure: LP_UpdateListIncreaseGame
    Description: Increments the number of games in the specified list.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE LP_UpdateListIncreaseGame
    @ListId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate list ID */
    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Increment numberGame */
    UPDATE [Lists] SET numberGame += 1 WHERE listId = @ListId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: LP_UpdateListDecreaseGame
    Description: Decrements the number of games in the specified list.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE LP_UpdateListDecreaseGame
    @ListId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate list ID */
    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Decrement numberGame */
    UPDATE [Lists] SET numberGame -= 1 WHERE listId = @ListId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END
GO

/* 
    Procedure: LP_DeleteList
    Description: Deletes a list by its ID.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to delete.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE LP_DeleteList
    @ListId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify list existence */
    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Delete list */
    DELETE FROM [Lists] WHERE listId = @ListId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;

    /* Verify deletion success */
    IF DBO.LF_ListIdExists(@ListId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END
END
GO

/* 
    Procedure: LP_GetListAll
    Description: Retrieves all details for a specified list.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to query.
    Returns:
        TABLE: All columns from LF_GetListAll function.
*/
CREATE OR ALTER PROCEDURE LP_GetListAll
    @ListId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Return list details */
    SELECT * FROM DBO.LF_GetListAll(@ListId);
END;
GO

/* 
    Procedure: LP_GetListTitle
    Description: Retrieves the title of a specified list.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to query.
    Returns:
        NVARCHAR(100): List title or NULL if not found.
*/
CREATE OR ALTER PROCEDURE LP_GetListTitle
    @ListId UNIQUEIDENTIFIER,
    @Title NVARCHAR(255) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return list title */
    SET @Title = DBO.LF_GetListTitle(@ListId);
END;
GO

/* 
    Procedure: LP_GetListDescriptions
    Description: Retrieves the description of a specified list.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to query.
    Returns:
        NVARCHAR(MAX): List description or NULL if not found.
*/
CREATE OR ALTER PROCEDURE LP_GetListDescriptions
    @ListId UNIQUEIDENTIFIER,
    @Description NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return list description */
    SET @Description = DBO.LF_GetListDescriptions(@ListId);
END;
GO

/* 
    Procedure: LP_GetListCreatedAt
    Description: Retrieves the creation date of a specified list.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to query.
    Returns:
        DATETIME: List creation date or NULL if not found.
*/
CREATE OR ALTER PROCEDURE LP_GetListCreatedAt
    @ListId UNIQUEIDENTIFIER,
    @CreatedAt DATETIME OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return list creation date */
    SET @CreatedAt = DBO.LF_GetListCreatedAt(@ListId);
END;
GO

/* 
    Procedure: LP_GetListNumberGame
    Description: Retrieves the number of games in a specified list.
    Parameters:
        @ListId (UNIQUEIDENTIFIER): ID of the list to query.
    Returns:
        INT: Number of games or NULL if not found.
*/
CREATE OR ALTER PROCEDURE LP_GetListNumberGame
    @ListId UNIQUEIDENTIFIER,
    @NumberGame INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return number of games */
    SET @NumberGame = DBO.LF_GetListNumberGame(@ListId);
END;
GO

/* 
    Procedure: AP_CreateActivity
    Description: Creates a new activity with specified content.
    Parameters:
        @Content (NVARCHAR(MAX)): Activity content.
        @ActivityId (UNIQUEIDENTIFIER OUTPUT): Generated ID for the new activity.
    Returns:
        @ActivityId: The ID of the created activity or NULL if creation fails.
*/
CREATE OR ALTER PROCEDURE AP_CreateActivity
    @Content NVARCHAR(MAX),
    @ActivityId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate activity content */
    IF DBO.AF_IsContentLegal(@Content) = 0
    BEGIN
        SET @ActivityId = NULL;
        RETURN;
    END

    /* Generate new activity ID */
    SET @ActivityId = NEWID();

    /* Insert activity data */
    INSERT INTO [Activities] (activityId, content)
    VALUES (@ActivityId, @Content);

    /* Verify insertion success */
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
    BEGIN
        SET @ActivityId = NULL;
        RETURN;
    END
END;
GO

/* 
    Procedure: AP_UpdateActivityContent
    Description: Updates the content of an existing activity.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): ID of the activity to update.
        @Content (NVARCHAR(MAX)): New activity content.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE AP_UpdateActivityContent
    @ActivityId UNIQUEIDENTIFIER,
    @Content NVARCHAR(MAX),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate activity ID and content */
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0 OR
       DBO.AF_IsContentLegal(@Content) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update activity content */
    UPDATE [Activities]
    SET content = @Content
    WHERE activityId = @ActivityId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: AP_UpdateActivityAll
    Description: Updates all attributes of an existing activity.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): ID of the activity to update.
        @Content (NVARCHAR(MAX)): New activity content.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE AP_UpdateActivityAll
    @ActivityId UNIQUEIDENTIFIER,
    @Content NVARCHAR(MAX),
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate activity ID */
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    DECLARE @Temp INT;

    /* Update activity content */
    EXEC AP_UpdateActivityContent @ActivityId, @Content, @Result = @Temp OUTPUT;
    SET @Result = @Temp;
END;
GO

/* 
    Procedure: AP_DeleteActivity
    Description: Deletes an activity by its ID.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): ID of the activity to delete.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE AP_DeleteActivity
    @ActivityId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify activity existence */
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Delete activity */
    DELETE FROM [Activities]
    WHERE activityId = @ActivityId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;

    /* Verify deletion success */
    IF DBO.AF_ActivityIdExists(@ActivityId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END
END;
GO

/* 
    Procedure: AP_GetActivityAll
    Description: Retrieves all details for a specified activity.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): ID of the activity to query.
    Returns:
        TABLE: All columns from AF_GetActivityAll function.
*/
CREATE OR ALTER PROCEDURE AP_GetActivityAll
    @ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Return activity details */
    SELECT * FROM DBO.AF_GetActivityAll(@ActivityId);
END;
GO

/* 
    Procedure: AP_GetActivityContent
    Description: Retrieves the content of a specified activity.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): ID of the activity to query.
    Returns:
        NVARCHAR(MAX): Activity content or NULL if not found.
*/
CREATE OR ALTER PROCEDURE AP_GetActivityContent
    @ActivityId UNIQUEIDENTIFIER,
    @Content NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return activity content */
    SET @Content = DBO.AF_GetActivityContent(@ActivityId);
END;
GO

/* 
    Procedure: AP_GetActivityDateDo
    Description: Retrieves the date performed for a specified activity.
    Parameters:
        @ActivityId (UNIQUEIDENTIFIER): ID of the activity to query.
    Returns:
        DATETIME: Activity date or NULL if not found.
*/
CREATE OR ALTER PROCEDURE AP_GetActivityDateDo
    @ActivityId UNIQUEIDENTIFIER,
    @DateDo DATETIME OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return activity date */
    SET @DateDo = DBO.AF_GetActivityDateDo(@ActivityId);
END;
GO

/* 
    Procedure: DP_CreateDiary
    Description: Creates a new diary entry with a unique ID.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER OUTPUT): Generated ID for the new diary entry.
    Returns:
        @DiaryId: The ID of the created diary entry or NULL if creation fails.
*/
CREATE OR ALTER PROCEDURE DP_CreateDiary
    @DiaryId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Generate new diary ID */
    SET @DiaryId = NEWID();

    /* Insert diary data */
    INSERT INTO [Diaries] (diaryId)
    VALUES (@DiaryId);

    /* Verify insertion success */
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        SET @DiaryId = NULL;
        RETURN;
    END
END;
GO

/* 
    Procedure: DP_UpdateDiaryDateLogged
    Description: Updates the logged date of an existing diary entry.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): ID of the diary entry to update.
        @DateLogged (DATETIME): New logged date.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE DP_UpdateDiaryDateLogged
    @DiaryId UNIQUEIDENTIFIER,
    @DateLogged DATETIME,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate diary ID and date */
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0 OR @DateLogged IS NULL
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update logged date */
    UPDATE [Diaries] SET dateLogged = @DateLogged WHERE diaryId = @DiaryId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: DP_UpdateDiary
    Description: Updates all attributes of an existing diary entry.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): ID of the diary entry to update.
        @DateLogged (DATETIME): New logged date.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE DP_UpdateDiary
    @DiaryId UNIQUEIDENTIFIER,
    @DateLogged DATETIME,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate diary ID */
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    DECLARE @Temp INT;

    /* Update logged date */
    EXEC DP_UpdateDiaryDateLogged @DiaryId, @DateLogged, @Result = @Temp OUTPUT;
    SET @Result = @Temp;
END;
GO

/* 
    Procedure: DP_UpdateDiaryIncreaseGameLogged
    Description: Increments the number of games logged in the specified diary entry.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): ID of the diary entry to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE DP_UpdateDiaryIncreaseGameLogged
    @DiaryId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate diary ID */
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Increment numberGameLogged */
    UPDATE [Diaries] SET numberGameLogged += 1 WHERE diaryId = @DiaryId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: DP_UpdateDiaryDecreaseGameLogged
    Description: Decrements the number of games logged in the specified diary entry.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): ID of the diary entry to update.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE DP_UpdateDiaryDecreaseGameLogged
    @DiaryId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate diary ID */
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Decrement numberGameLogged */
    UPDATE [Diaries] SET numberGameLogged -= 1 WHERE diaryId = @DiaryId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: DP_DeleteDiary
    Description: Deletes a diary entry by its ID.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): ID of the diary entry to delete.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE DP_DeleteDiary
    @DiaryId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify diary existence */
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Delete diary entry */
    DELETE FROM [Diaries] WHERE diaryId = @DiaryId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;

    /* Verify deletion success */
    IF DBO.DF_DiaryIdExists(@DiaryId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END
END;
GO

/* 
    Procedure: DP_GetDiaryAll
    Description: Retrieves all details for a specified diary entry.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): ID of the diary entry to query.
    Returns:
        TABLE: All columns from DF_GetDiaryAll function.
*/
CREATE OR ALTER PROCEDURE DP_GetDiaryAll
    @DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Return diary details */
    SELECT * FROM DBO.DF_GetDiaryAll(@DiaryId);
END;
GO

/* 
    Procedure: DP_GetDiaryDateLogged
    Description: Retrieves the logged date of a specified diary entry.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): ID of the diary entry to query.
    Returns:
        DATETIME: Diary logged date or NULL if not found.
*/
CREATE OR ALTER PROCEDURE DP_GetDiaryDateLogged
    @DiaryId UNIQUEIDENTIFIER,
    @DateLogged DATETIME OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return logged date */
    SET @DateLogged = DBO.DF_GetDiaryDateLogged(@DiaryId);
END;
GO

/* 
    Procedure: DP_GetDiaryNumberGameLogged
    Description: Retrieves the number of games logged in a specified diary entry.
    Parameters:
        @DiaryId (UNIQUEIDENTIFIER): ID of the diary entry to query.
    Returns:
        INT: Number of games logged or NULL if not found.
*/
CREATE OR ALTER PROCEDURE DP_GetDiaryNumberGameLogged
    @DiaryId UNIQUEIDENTIFIER,
    @NumberGameLogged INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return number of games logged */
    SET @NumberGameLogged = DBO.DF_GetDiaryNumberGameLogged(@DiaryId);
END;
GO

/* 
    Procedure: RP_CreateReaction
    Description: Creates a new reaction with specified reaction type.
    Parameters:
        @ReactionType (INT): Type of reaction.
        @ReactionId (UNIQUEIDENTIFIER OUTPUT): Generated ID for the new reaction.
    Returns:
        @ReactionId: The ID of the created reaction or NULL if creation fails.
*/
CREATE OR ALTER PROCEDURE RP_CreateReaction
    @ReactionType INT,
    @ReactionId UNIQUEIDENTIFIER OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate reaction type */
    IF DBO.RF_IsReactionTypeLegal(@ReactionType) = 0
    BEGIN
        SET @ReactionId = NULL;
        RETURN;
    END

    /* Generate new reaction ID */
    SET @ReactionId = NEWID();

    /* Insert reaction data */
    INSERT INTO [Reactions] (reactionId, reactionType)
    VALUES (@ReactionId, @ReactionType);

    /* Verify insertion success */
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SET @ReactionId = NULL;
        RETURN;
    END
END;
GO

/* 
    Procedure: RP_UpdateReactionType
    Description: Updates the reaction type of an existing reaction.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction to update.
        @ReactionType (INT): New reaction type.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE RP_UpdateReactionType
    @ReactionId UNIQUEIDENTIFIER,
    @ReactionType INT,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate reaction ID and type */
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0 OR
       DBO.RF_IsReactionTypeLegal(@ReactionType) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Update reaction type */
    UPDATE [Reactions] SET reactionType = @ReactionType WHERE reactionId = @ReactionId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;
END;
GO

/* 
    Procedure: RP_UpdateReaction
    Description: Updates all attributes of an existing reaction.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction to update.
        @ReactionType (INT): New reaction type.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE RP_UpdateReaction
    @ReactionId UNIQUEIDENTIFIER,
    @ReactionType INT,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Validate reaction ID */
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    DECLARE @Temp INT;

    /* Update reaction type */
    EXEC RP_UpdateReactionType @ReactionId, @ReactionType, @Result = @Temp OUTPUT;
    SET @Result = @Temp;
END;
GO

/* 
    Procedure: RP_DeleteReaction
    Description: Deletes a reaction by its ID.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction to delete.
        @Result (INT OUTPUT): Number of rows affected (1 for success, 0 for failure).
    Returns:
        @Result: Indicates success (1) or failure (0).
*/
CREATE OR ALTER PROCEDURE RP_DeleteReaction
    @ReactionId UNIQUEIDENTIFIER,
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Verify reaction existence */
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        SET @Result = 0;
        RETURN;
    END

    /* Delete reaction */
    DELETE FROM [Reactions] WHERE reactionId = @ReactionId;

    /* Return number of rows affected */
    SET @Result = @@ROWCOUNT;

    /* Verify deletion success */
    IF DBO.RF_ReactionIdExists(@ReactionId) = 1
    BEGIN
        SET @Result = 0;
        RETURN;
    END
END;
GO

CREATE OR ALTER PROCEDURE RP_DeleteReactions
    @ReactionIds IdList READONLY, -- TVP chứa cột 'Id'
    @Result INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

        -- Kiểm tra danh sách có rỗng không
    IF NOT EXISTS (SELECT 1 FROM @ReactionIds)
    BEGIN
        SET @Result = 1;
        RETURN;
    END

    -- Khởi tạo biến đếm
    DECLARE @DeletedCount INT = 0;



    -- Xoá các reaction tồn tại
    DELETE FROM [Reactions]
    WHERE reactionId IN (
        SELECT Id FROM @ReactionIds
        WHERE DBO.RF_ReactionIdExists(Id) = 1
    );

    SET @DeletedCount = @@ROWCOUNT;

    -- Kiểm tra còn reaction nào chưa bị xoá không
    IF EXISTS (
        SELECT 1
        FROM @ReactionIds r
        WHERE DBO.RF_ReactionIdExists(r.Id) = 1
    )
    BEGIN
        -- Còn ít nhất 1 reaction chưa xoá
        SET @Result = 0;
        RETURN;
    END

    -- Tất cả đã xoá thành công
    SET @Result = @DeletedCount;
END
GO



/* 
    Procedure: RP_GetReactionAll
    Description: Retrieves all details for a specified reaction.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction to query.
    Returns:
        TABLE: All columns from RF_GetReactionAll function.
*/
CREATE OR ALTER PROCEDURE RP_GetReactionAll
    @ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    /* Return reaction details */
    SELECT * FROM DBO.RF_GetReactionAll(@ReactionId);
END;
GO

/* 
    Procedure: RP_GetReactionType
    Description: Retrieves the reaction type of a specified reaction.
    Parameters:
        @ReactionId (UNIQUEIDENTIFIER): ID of the reaction to query.
    Returns:
        INT: Reaction type or NULL if not found.
*/
CREATE OR ALTER PROCEDURE RP_GetReactionType
    @ReactionId UNIQUEIDENTIFIER,
    @ReactionType INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    /* Return reaction type */
    SET @ReactionType = DBO.RF_GetReactionType(@ReactionId);
END;
GO