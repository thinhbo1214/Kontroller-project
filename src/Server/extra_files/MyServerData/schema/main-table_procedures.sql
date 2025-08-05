-- #Procedure helper
CREATE OR ALTER PROCEDURE SP_GenerateStrongPassword
    @Length INT = 12,
    @Password VARCHAR(100) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @Length < 8 OR @Length > 50
    BEGIN
        SET @Password = NULL;
        RETURN;
    END

    DECLARE @UpperChars VARCHAR(26) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    DECLARE @LowerChars VARCHAR(26) = 'abcdefghijklmnopqrstuvwxyz';
    DECLARE @Digits VARCHAR(10)     = '0123456789';
    DECLARE @SpecialChars VARCHAR(20) = '!@#$%^&*()_+{}:<>?';

    DECLARE @AllChars VARCHAR(100) = @UpperChars + @LowerChars + @Digits + @SpecialChars;

    DECLARE @Result VARCHAR(100) = '';

    -- Bắt buộc có ít nhất 1 của mỗi loại
    SET @Result = 
        SUBSTRING(@UpperChars, CAST(RAND(CHECKSUM(NEWID())) * LEN(@UpperChars) + 1 AS INT), 1) +
        SUBSTRING(@LowerChars, CAST(RAND(CHECKSUM(NEWID())) * LEN(@LowerChars) + 1 AS INT), 1) +
        SUBSTRING(@Digits,     CAST(RAND(CHECKSUM(NEWID())) * LEN(@Digits)     + 1 AS INT), 1) +
        SUBSTRING(@SpecialChars, CAST(RAND(CHECKSUM(NEWID())) * LEN(@SpecialChars) + 1 AS INT), 1);

    -- Sinh thêm các ký tự còn lại
    DECLARE @i INT = LEN(@Result) + 1;
    WHILE @i <= @Length
    BEGIN
        SET @Result = @Result + SUBSTRING(@AllChars, CAST(RAND(CHECKSUM(NEWID())) * LEN(@AllChars) + 1 AS INT), 1);
        SET @i = @i + 1;
    END

    -- Trộn chuỗi
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
        RAISERROR('Failed to create user', 16, 1);
        SELECT NULL AS UserId;
        RETURN;
    END;

    DECLARE @UserId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Users (userId, username, password_hash, email)
    VALUES (@UserId, @Username, HASHBYTES('SHA2_256', @Password), @Email);

    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RAISERROR('Failed to create user', 16, 1);
        SELECT NULL AS UserId;
        RETURN;
    END;

    SELECT @UserId AS UserId;

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
        RAISERROR('Failed to update username', 16, 1);
        SELECT 0 AS UsernameUpdated;
        RETURN;
    END;

    UPDATE Users SET username = @NewUsername WHERE UserId = @UserId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS UsernameUpdated;
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
        RAISERROR('Failed to update email', 16, 1);
        SELECT 0 AS EmailUpdated;
        RETURN;
    END;

    UPDATE Users SET email = @NewEmail WHERE UserId = @UserId;

    DECLARE @rowsAffected INT = @@ROWCOUNT;
    SELECT  @rowsAffected AS EmailUpdated;
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
        RAISERROR('Failed to update avatar.', 16, 1);
        SELECT 0 AS AvatarUpdated;
        RETURN;
    END;

    UPDATE Users SET avatar = @NewAvatar WHERE UserId = @UserId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS AvatarUpdated;
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
        RAISERROR('Failed to update login status', 16, 1);
        SELECT 0 AS LoginStatusUpdated;
        RETURN;
    END;

    UPDATE Users SET isLoggedIn = @IsLoggedIn WHERE UserId = @UserId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS LoginStatusUpdated;
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
        RAISERROR('Failed to update password.', 16, 1);
        SELECT 0 AS PasswordUpdated;
        RETURN;
    END;
    UPDATE Users SET password_hash = HASHBYTES('SHA2_256', @NewPassword) WHERE UserId = @UserId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS PasswordUpdated;
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
        RETURN;
    END;

    EXEC DBO.UP_UpdateUsername @UserId, @Username;
    
    EXEC DBO.UP_UpdatePassword @UserId, @Password;

    EXEC DBO.UP_UpdateUserEmail @UserId, @Email;

    EXEC DBO.UP_UpdateUserAvatar @UserId, @Avatar;

    EXEC DBO.UP_UpdateUserLoginStatus @UserId, @IsUserLoggedIn;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS UserDetailsUpdated;

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
        RAISERROR('Failed to delete user', 16, 1);
        SELECT 0 AS UserDeleted;
        RETURN;
    END;

    DELETE FROM Users WHERE UserId = @UserId;
    
    IF DBO.UF_UserIdExists(@UserId) = 1
    BEGIN
        RAISERROR('Failed to delete user', 16, 1);
        SELECT 0 AS UserDeleted;
        RETURN;
    END;

    SELECT 1 AS UserDeleted;
END;
GO

-- 9. Procedure to check if a user is logged in
CREATE OR ALTER PROCEDURE UP_CheckUserLoggedIn
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
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

-- 16. Procedure to check if a user exists
CREATE OR ALTER PROCEDURE UP_CheckUserExists
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RETURN;
    END;

    SELECT 1 AS UserExists;
END;
GO

-- 17. Procedure to check login account
CREATE OR ALTER PROCEDURE UP_CheckLoginAccount
@Username VARCHAR(100),
@Password VARCHAR(100)
AS
BEGIN
    DECLARE @UserId UNIQUEIDENTIFIER;

    IF DBO.UF_IsUsernameLegal(@Username) = 0 
        OR DBO.UF_IsPasswordLegal(@Password) = 0
        OR DBO.UF_UsernameExists(@Username) = 0
    BEGIN
        RAISERROR ('Failed to check login account.', 16, 1);
        SELECT NULL AS UserId;
        RETURN;
    END;

    SELECT @UserId = userId FROM [Users] WHERE username = @Username;

    IF DBO.UF_IsPasswordMatch(@UserId, @Password) = 0
    BEGIN
        RAISERROR ('Failed to check login account.', 16, 1);
        SELECT NULL AS UserId;
        RETURN;
    END;

    SELECT @UserId AS UserId;
END;
GO

-- 18. Procedure to update password if forget password
CREATE OR ALTER PROCEDURE UP_ForgetPassword
@Email VARCHAR(100)
AS
BEGIN
    DECLARE @UserId UNIQUEIDENTIFIER;
    DECLARE @NewPassword VARCHAR(100);

    -- Check if email exists and get UserId
    SELECT @UserId = userId FROM Users WHERE email = @Email;

    IF @UserId IS NULL
    BEGIN
        RAISERROR('Failed to reset password.', 16, 1);
        SELECT NULL AS NewPassword;
        RETURN;
    END

    -- Generate random 8-character password
    EXEC SP_GenerateStrongPassword @Length = 12, @Password = @NewPassword OUTPUT;

    -- Update password
    UPDATE Users SET password_hash = HASHBYTES('SHA2_256', @NewPassword)
    WHERE userId = @UserId;

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Failed to reset password.', 16, 1);
        SELECT NULL AS NewPassword;
        RETURN;
    END

    -- Return new password
    SELECT @NewPassword AS NewPassword;

END;
GO

-- 19. Procedure to change password by old password
CREATE OR ALTER PROCEDURE UP_ChangePassword
@UserId UNIQUEIDENTIFIER,
@OldPassword VARCHAR(100),
@NewPassword VARCHAR(100)
AS
BEGIN
    -- Check user exists
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        RAISERROR('Failed to change password.', 16, 1);
        SELECT 0 AS PasswordChanged;
        RETURN;
    END

    -- Check old password match
    IF DBO.UF_IsPasswordMatch(@UserId, @OldPassword) = 0
    BEGIN
        RAISERROR('Failed to change password.', 16, 1);
        SELECT 0 AS PasswordChanged;
        RETURN;
    END

    -- Check new password legality
    IF DBO.UF_IsPasswordLegal(@NewPassword) = 0
    BEGIN
        RAISERROR('New password is not legal.', 16, 1);
        SELECT 0 AS PasswordChanged;
        RETURN;
    END

    -- Update password
    UPDATE Users SET password_hash = HASHBYTES('SHA2_256', @NewPassword)
    WHERE userId = @UserId;

    IF @@ROWCOUNT = 0
    BEGIN
        RAISERROR('Failed to change password.', 16, 1);
        SELECT 0 AS PasswordChanged;
        RETURN;
    END
    
    SELECT 1 AS PasswordChanged;
END;
GO

-- # Games table procedures
-- 1. Procedure to create a new game
CREATE OR ALTER PROCEDURE GP_CreateGame
@Title NVARCHAR(100),
@Genre NVARCHAR(100),
@Description NVARCHAR(MAX),
@Details NVARCHAR(MAX)
AS
BEGIN
    IF DBO.GF_IsGameTitleLegal(@Title) = 0 
        OR DBO.GF_IsGameGenreLegal(@Genre) = 0 
        OR DBO.GF_IsGameDescriptionLegal(@Description) = 0
        OR DBO.GF_IsGameDetailsLegal(@Details) = 0
    BEGIN
        RAISERROR('Failed to create game', 16, 1);
        SELECT NULL AS GameId;
        RETURN;
    END;

    DECLARE @GameId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO [Games] (gameId, title, genre, descriptions, details)
    VALUES (@GameId, @Title, @Genre, @Description, @Details);

    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        RAISERROR('Failed to create game', 16, 1);
        SELECT NULL AS GameId;
        RETURN;
    END;

    SELECT @GameId AS GameId;
END;
GO

-- 2. Procedure to update game title
CREATE OR ALTER PROCEDURE GP_UpdateGameTitle
@GameId UNIQUEIDENTIFIER,
@NewTitle NVARCHAR(100)
AS
BEGIN
    IF DBO.GF_IsGameTitleLegal(@NewTitle) = 0
    BEGIN
        RAISERROR('Failed to update game title', 16, 1);
        SELECT 0 AS TitleUpdated;
        RETURN;
    END;

    UPDATE [Games] SET title = @NewTitle WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS TitleUpdated;
END;
GO

-- 3. Procedure to update game genre
CREATE OR ALTER PROCEDURE GP_UpdateGameGenre
@GameId UNIQUEIDENTIFIER,
@NewGenre NVARCHAR(100)
AS
BEGIN
    IF DBO.GF_IsGameGenreLegal(@NewGenre) = 0
    BEGIN
        RAISERROR('Failed to update game genre', 16, 1);
        SELECT 0 AS GenreUpdated;
        RETURN;
    END;

    UPDATE [Games] SET genre = @NewGenre WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS GenreUpdated;
END;
GO

-- 4. Procedure to update game description
CREATE OR ALTER PROCEDURE GP_UpdateGameDescription
@GameId UNIQUEIDENTIFIER,
@NewDescription NVARCHAR(MAX)
AS
BEGIN
    IF DBO.GF_IsGameDescriptionLegal(@NewDescription) = 0
    BEGIN
        RAISERROR('Failed to update description', 16, 1);
        SELECT 0 AS DescriptionUpdated;
        RETURN;
    END;

    UPDATE [Games] SET descriptions = @NewDescription WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DescriptionUpdated;
END;
GO

-- 5. Procedure to update game details
CREATE OR ALTER PROCEDURE GP_UpdateGameDetails
@GameId UNIQUEIDENTIFIER,
@NewDetails NVARCHAR(MAX)
AS
BEGIN
    IF DBO.GF_IsGameDetailsLegal(@NewDetails) = 0
    BEGIN
        RAISERROR('Failed to update game details', 16, 1);
        SELECT 0 AS DetailsUpdated;
        RETURN;
    END;

    UPDATE [Games] SET details = @NewDetails WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DetailsUpdated;
END;
GO

-- 6. Procedure to update game poster
CREATE OR ALTER PROCEDURE GP_UpdateGamePoster
@GameId UNIQUEIDENTIFIER,
@NewPoster VARCHAR(255)
AS
BEGIN
    IF DBO.GF_IsGamePosterLegal(@NewPoster) = 0
    BEGIN
        RAISERROR('Failed to update poster', 16, 1);
        SELECT 0 AS PosterUpdated;
        RETURN;
    END;

    UPDATE [Games] SET poster = @NewPoster WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS PosterUpdated;
END;
GO

-- 7. Procedure to update game backdrop
CREATE OR ALTER PROCEDURE GP_UpdateGameBackdrop
@GameId UNIQUEIDENTIFIER,
@NewBackdrop VARCHAR(255)
AS
BEGIN
    IF DBO.GF_IsGameBackdropLegal(@NewBackdrop) = 0
    BEGIN
        RAISERROR('Failed to update backdrop', 16, 1);
        SELECT 0 AS BackdropUpdated;
        RETURN;
    END;

    UPDATE [Games] SET backdrop = @NewBackdrop WHERE gameId = @GameId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS BackdropUpdated;
END;
GO

-- 8. Procedure to update game all information
CREATE OR ALTER PROCEDURE GP_UpdateGameAllInfo
@GameId UNIQUEIDENTIFIER,
@Title NVARCHAR(100) = NULL,
@Genre NVARCHAR(100) = NULL,
@Descriptions NVARCHAR(MAX) = NULL,
@Details NVARCHAR(MAX) = NULL,
@Poster VARCHAR(255) = NULL,
@Backdrop VARCHAR(255) = NULL
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        RETURN;
    END;

    EXEC DBO.GP_UpdateGameTitle @GameId, @Title;

    EXEC DBO.GP_UpdateGameGenre @GameId, @Genre;

    EXEC DBO.GP_UpdateGameDescription @GameId, @Descriptions;

    EXEC DBO.GP_UpdateGameDetails @GameId, @Details;

    EXEC DBO.GP_UpdateGamePoster @GameId, @Poster;

    EXEC DBO.GP_UpdateGameBackdrop @GameId, @Backdrop;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS GameInfoUpdated;
END;
GO

-- 9. Procedure to delete a game
CREATE OR ALTER PROCEDURE GP_DeleteGame
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.GF_GameIdExists(@GameId) = 0
    BEGIN
        RAISERROR('Failed to delete game', 16, 1);
        SELECT 0 AS GameDeleted;
        RETURN;
    END;

    DELETE FROM [Games] WHERE gameId = @GameId;

    IF DBO.GF_GameIdExists(@GameId) = 1
    BEGIN
        RAISERROR('Failed to delete game', 16, 1);
        SELECT 0 AS GameDeleted;
        RETURN;
    END;
                  
    SELECT 1 AS GameDeleted;
END;
GO

-- 10. Procedure to get game aLl information
CREATE OR ALTER PROCEDURE GP_GetGameAllInfo
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM GF_GetGameAllInfo(@GameId);
END;
GO

-- 11. Procedure to get game title
CREATE OR ALTER PROCEDURE GP_GetGameTitle
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.GF_GetGameTitle(@GameId) AS Title;
END;
GO

-- 12. Procedure to get game genre
CREATE OR ALTER PROCEDURE GP_GetGameGenre
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.GF_GetGameGenre(@GameId) AS Genre;
END;
GO

-- 13. Procedure to get game description
CREATE OR ALTER PROCEDURE GP_GetGameDescription
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.GF_GetGameDescription(@GameId) AS Description;
END;
GO

-- 14. Procedure to get game details
CREATE OR ALTER PROCEDURE GP_GetGameDetails
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.GF_GetGameDetails(@GameId) AS Details;
END;
GO

-- 15. Procedure to get game poster
CREATE OR ALTER PROCEDURE GP_GetGamePoster
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.GF_GetGamePoster(@GameId) AS Poster;
END;
GO

-- 16. Procedure to get game backdrop
CREATE OR ALTER PROCEDURE GP_GetGameBackdrop
@GameId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.GF_GetGameBackdrop(@GameId) AS Backdrop;
END;
GO

-- #Review table procedures
-- 1. Procedure to create a new review
CREATE OR ALTER PROCEDURE RP_CreateReview
@Content NVARCHAR(MAX)
AS
BEGIN
    IF DBO.RF_IsContentLegality(@Content) = 0
    BEGIN
        RAISERROR ('Failed to create review.', 16, 1);
        SELECT NULL AS ReviewId;
        RETURN;
    END;

    DECLARE @ReviewId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO [Reviews] (reviewId, content)
    VALUES (@ReviewId,@Content);

    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        RAISERROR ('Failed to create review.', 16, 1);
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
        RAISERROR ('Failed to update review content.', 16, 1);
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
        RAISERROR ('Failed to update review rating', 16, 1);
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
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        RAISERROR ('Failed to update review details.', 16, 1);
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
    IF DBO.RF_ReviewIdExists(@ReviewId) = 0
    BEGIN
        RAISERROR('Failed to delete review', 16, 1);
        SELECT 0 AS ReviewDeleted;
        RETURN;
    END;

    DELETE [Reviews] WHERE reviewId = @ReviewId;

    IF DBO.RF_ReviewIdExists(@ReviewId) = 1
    BEGIN
        RAISERROR('Failed to delete review', 16, 1);
        SELECT 0 AS ReviewDeleted;
        RETURN;
    END;

    SELECT 1 AS ReviewDeleted;
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

-- #Comment table procedures

-- 1. Procedure to create a new comment
CREATE OR ALTER PROCEDURE CP_CreateComment
@Content NVARCHAR(MAX)
AS
BEGIN
    IF DBO.CF_IsContentLegality(@Content) = 0
    BEGIN
        RAISERROR ('Failed to create comment.', 16, 1);
        SELECT NULL AS CommentId;
        RETURN;
    END;

    DECLARE @CommentId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Comments (commentId, content)
    VALUES (@CommentId, @Content);

    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        RAISERROR ('Failed to create comment.', 16, 1);
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
        RAISERROR ('Failed to update comment.', 16, 1);
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
    IF DBO.CF_CommentIdExists(@CommentId) = 0
    BEGIN
        RAISERROR ('Failed to delete comment.', 16, 1);
        SELECT 0 AS CommentDeleted;
        RETURN;
    END;

    DELETE FROM Comments WHERE commentId = @CommentId;

    IF DBO.CF_CommentIdExists(@CommentId) = 1
    BEGIN
        RAISERROR ('Failed to delete comment.', 16, 1);
        SELECT 0 AS CommentDeleted;
        RETURN;
    END;

    SELECT 1 AS CommentDeleted;
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

-- #Rate table procedures

-- 1. Procedure to create a new rate
CREATE OR ALTER PROCEDURE RP_CreateRate
@RateValue INT
AS
BEGIN
    IF DBO.RF_IsRateLegal(@RateValue) = 0
    BEGIN
        RAISERROR ('Failed to create rate.', 16, 1);
        SELECT NULL AS RateId;
        RETURN;
    END;

    DECLARE @RateId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Rates (rateId, rateValue)
    VALUES (@RateId, @RateValue);

    IF DBO.RF_RateIdExists(@RateId) = 0
    BEGIN
        RAISERROR ('Failed to create rate.', 16, 1);
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
        RAISERROR ('Failed to update rate.', 16, 1);
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
    IF DBO.RF_RateIdExists(@RateId) = 0
    BEGIN
        RAISERROR ('Failed to delete rate.', 16, 1);
        SELECT 0 AS RateDeleted;
        RETURN;
    END;

    DELETE FROM Rates WHERE rateId = @RateId;

    IF DBO.RF_RateIdExists(@RateId) = 1
    BEGIN
        RAISERROR ('Failed to delete rate.', 16, 1);
        SELECT 0 AS RateDeleted;
        RETURN;
    END;

    SELECT 1 AS RateDeleted;
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

-- #List table procedures

-- 1. Procedure to create a new list
CREATE OR ALTER PROCEDURE LP_CreateList
@Name NVARCHAR(100),
@Descriptions NVARCHAR(MAX) = NULL
AS
BEGIN
    IF DBO.LF_IsNameLegal(@Name) = 0 OR
        DBO.LF_IsDescriptionLegal(@Descriptions) = 0
    BEGIN
        RAISERROR ('Failed to create list.', 16, 1);
        SELECT NULL AS ListId;
        RETURN;
    END;

    DECLARE @ListId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Lists (listId, _name, descriptions)
    VALUES (@ListId, @Name, @Descriptions);

    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        RAISERROR ('Failed to create list.', 16, 1);
        SELECT NULL AS ListId;
        RETURN;
    END;

    SELECT @ListId AS ListId;
END;
GO

-- 2. Procedure to update list name
CREATE OR ALTER PROCEDURE LP_UpdateListName
@ListId UNIQUEIDENTIFIER,
@Name NVARCHAR(100)
AS
BEGIN
    IF DBO.LF_IsNameLegal(@Name) = 0
    BEGIN
        RAISERROR ('Failed to update list name.', 16, 1);
        SELECT 0 AS NameUpdated;
        RETURN;
    END;

    UPDATE Lists SET _name = @Name WHERE listId = @ListId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS NameUpdated;
END;
GO

-- 3. Procedure to update list descriptions
CREATE OR ALTER PROCEDURE LP_UpdateListDescriptions
@ListId UNIQUEIDENTIFIER,
@Descriptions NVARCHAR(MAX)
AS
BEGIN
    IF DBO.LF_IsDescriptionLegal(@Descriptions) = 0
    BEGIN
        RAISERROR ('Failed to update list descriptions.', 16, 1);
        SELECT 0 AS DescriptionsUpdated;
        RETURN;
    END;

    UPDATE Lists SET descriptions = @Descriptions WHERE listId = @ListId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DescriptionsUpdated;
END;
GO

-- 4. Procedure to update list name and descriptions
CREATE OR ALTER PROCEDURE LP_UpdateListDetails
@ListId UNIQUEIDENTIFIER,
@Name NVARCHAR(100),
@Descriptions NVARCHAR(MAX)
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        RAISERROR ('Failed to update list details.', 16, 1);
        SELECT 0 AS DetailsUpdated;
        RETURN;
    END;

    EXEC LP_UpdateListName @ListId, @Name;
    EXEC LP_UpdateListDescriptions @ListId, @Descriptions;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DetailsUpdated;
END;
GO

-- 5. Procedure to delete a list
CREATE OR ALTER PROCEDURE LP_DeleteList
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.LF_ListIdExists(@ListId) = 0
    BEGIN
        RAISERROR ('Failed to delete list.', 16, 1);
        SELECT 0 AS ListDeleted;
        RETURN;
    END;

    DELETE FROM Lists WHERE listId = @ListId;

    IF DBO.LF_ListIdExists(@ListId) = 1
    BEGIN
        RAISERROR ('Failed to delete list.', 16, 1);
        SELECT 0 AS ListDeleted;
        RETURN;
    END;

    SELECT 1 AS ListDeleted;
END;
GO

-- 6. Procedure to get list details
CREATE OR ALTER PROCEDURE LP_GetListDetails
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.LF_GetList(@ListId);
END;
GO

-- 7. Procedure to get list name
CREATE OR ALTER PROCEDURE LP_GetListName
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.LF_GetName(@ListId) AS Name;
END;
GO

-- 8. Procedure to get list descriptions
CREATE OR ALTER PROCEDURE LP_GetListDescriptions
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.LF_GetDescriptions(@ListId) AS Descriptions;
END;
GO

-- 9. Procedure to get list created date
CREATE OR ALTER PROCEDURE LP_GetListCreatedDate
@ListId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.LF_GetCreatedAt(@ListId) AS CreatedAt;
END;
GO

-- 1. Procedure to create a new list item
CREATE OR ALTER PROCEDURE LIP_CreateListItem
@Title NVARCHAR(100)
AS
BEGIN
    IF DBO.LIF_IsTitleLegal(@Title) = 0
    BEGIN
        RAISERROR ('Failed to create list item.', 16, 1);
        SELECT NULL AS ListItemId;
        RETURN;
    END

    DECLARE @ListItemId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO List_items (listItemId, title)
    VALUES (@ListItemId, @Title);

    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0
    BEGIN
        RAISERROR ('Failed to create list item.', 16, 1);
        SELECT NULL AS ListItemId;
        RETURN;
    END

    SELECT @ListItemId AS ListItemId;
END;
GO

-- 2. Procedure to update title
CREATE OR ALTER PROCEDURE LIP_UpdateTitle
@ListItemId UNIQUEIDENTIFIER,
@Title NVARCHAR(100)
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0 OR
       DBO.LIF_IsTitleLegal(@Title) = 0
    BEGIN
        RAISERROR ('Failed to update list item.', 16, 1);
        SELECT 0 AS TitleUpdated;
        RETURN;
    END

    UPDATE List_items SET title = @Title WHERE listItemId = @ListItemId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS TitleUpdated;
END;
GO

-- 3. Procedure to update all columns
CREATE OR ALTER PROCEDURE LIP_UpdateListItem
@ListItemId UNIQUEIDENTIFIER,
@Title NVARCHAR(100)
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0
    BEGIN
        RAISERROR ('Failed to update list item.', 16, 1);
        SELECT 0 AS ListItemUpdated;
        RETURN;
    END

    EXEC LIP_UpdateTitle @ListItemId, @Title;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ListItemUpdated;
END;
GO

-- 4. Procedure to delete a list item
CREATE OR ALTER PROCEDURE LIP_DeleteListItem
@ListItemId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.LIF_ListItemIdExists(@ListItemId) = 0
    BEGIN
        RAISERROR ('Failed to delete list item.', 16, 1);
        SELECT 0 AS ListItemDeleted;
        RETURN;
    END

    DELETE FROM List_items WHERE listItemId = @ListItemId;

    IF DBO.LIF_ListItemIdExists(@ListItemId) = 1
    BEGIN
        RAISERROR ('Failed to delete list item.', 16, 1);
        SELECT 0 AS ListItemDeleted;
        RETURN;
    END

    SELECT 1 AS ListItemDeleted;
END;
GO

-- 5. Procedure to get full row
CREATE OR ALTER PROCEDURE LIP_GetListItem
@ListItemId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.LIF_GetListItem(@ListItemId);
END;
GO

-- 6. Procedure to get title only
CREATE OR ALTER PROCEDURE LIP_GetTitle
@ListItemId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.LIF_GetTitle(@ListItemId) AS Title;
END;
GO

-- 1. Procedure to create new activity
CREATE OR ALTER PROCEDURE AP_CreateActivity
@Content NVARCHAR(MAX)
AS
BEGIN
    IF DBO.AF_IsContentLegal(@Content) = 0
    BEGIN
        RAISERROR ('Failed to create activity.', 16, 1);
        SELECT NULL AS ActivityId;
        RETURN;
    END

    DECLARE @ActivityId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Activities (activityId, content)
    VALUES (@ActivityId, @Content);

    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
    BEGIN
        RAISERROR ('Failed to create activity.', 16, 1);
        SELECT NULL AS ActivityId;
        RETURN;
    END

    SELECT @ActivityId AS ActivityId;
END;
GO

-- 2. Procedure to update content
CREATE OR ALTER PROCEDURE AP_UpdateContent
@ActivityId UNIQUEIDENTIFIER,
@Content NVARCHAR(MAX)
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0 OR
       DBO.AF_IsContentLegal(@Content) = 0
    BEGIN
        RAISERROR ('Failed to update content.', 16, 1);
        SELECT 0 AS ContentUpdated;
        RETURN;
    END

    UPDATE Activities
    SET content = @Content
    WHERE activityId = @ActivityId;

    SELECT @@ROWCOUNT AS ContentUpdated;
END;
GO

-- 3. Procedure to update all columns
CREATE OR ALTER PROCEDURE AP_UpdateActivity
@ActivityId UNIQUEIDENTIFIER,
@Content NVARCHAR(MAX)
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
    BEGIN
        RAISERROR ('Failed to update activity.', 16, 1);
        SELECT 0 AS ActivityUpdated;
        RETURN;
    END

    EXEC AP_UpdateContent @ActivityId, @Content;

    SELECT @@ROWCOUNT AS ActivityUpdated;
END;
GO

-- 4. Procedure to delete activity
CREATE OR ALTER PROCEDURE AP_DeleteActivity
@ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.AF_ActivityIdExists(@ActivityId) = 0
    BEGIN
        RAISERROR ('Failed to delete activity.', 16, 1);
        SELECT 0 AS ActivityDeleted;
        RETURN;
    END

    DELETE FROM Activities
    WHERE activityId = @ActivityId;

    IF DBO.AF_ActivityIdExists(@ActivityId) = 1
    BEGIN
        RAISERROR ('Failed to delete activity.', 16, 1);
        SELECT 0 AS ActivityDeleted;
        RETURN;
    END

    SELECT 1 AS ActivityDeleted;
END;
GO

-- 5. Procedure to get full row
CREATE OR ALTER PROCEDURE AP_GetActivity
@ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.AF_GetActivity(@ActivityId);
END;
GO

-- 6. Procedure to get content
CREATE OR ALTER PROCEDURE AP_GetContent
@ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.AF_GetContent(@ActivityId) AS Content;
END;
GO

-- 7. Procedure to get dateDo
CREATE OR ALTER PROCEDURE AP_GetDateDo
@ActivityId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.AF_GetDateDo(@ActivityId) AS DateDo;
END;
GO

-- 1. Procedure to create a new diary entry
CREATE OR ALTER PROCEDURE DP_CreateDiary
AS
BEGIN
    DECLARE @DiaryId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Diaries (diaryId)
    VALUES (@DiaryId);

    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        RAISERROR ('Failed to create diary entry.', 16, 1);
        SELECT NULL AS DiaryId;
        RETURN;
    END

    SELECT @DiaryId AS DiaryId;
END;
GO

-- 2. Procedure to update dateLogged
CREATE OR ALTER PROCEDURE DP_UpdateDateLogged
@DiaryId UNIQUEIDENTIFIER,
@DateLogged DATETIME
AS
BEGIN
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0 OR @DateLogged IS NULL
    BEGIN
        RAISERROR ('Failed to update date logged.', 16, 1);
        SELECT 0 AS DateLoggedUpdated;
        RETURN;
    END

    UPDATE Diaries SET dateLogged = @DateLogged WHERE diaryId = @DiaryId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DateLoggedUpdated;
END;
GO

-- 3. Procedure to update full diary row
CREATE OR ALTER PROCEDURE DP_UpdateDiary
@DiaryId UNIQUEIDENTIFIER,
@DateLogged DATETIME
AS
BEGIN
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        RAISERROR ('Failed to update diary entry.', 16, 1);
        SELECT 0 AS DiaryUpdated;
        RETURN;
    END

    EXEC DP_UpdateDateLogged @DiaryId, @DateLogged;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS DiaryUpdated;
END;
GO

-- 4. Procedure to delete a diary entry
CREATE OR ALTER PROCEDURE DP_DeleteDiary
@DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        RAISERROR ('Failed to delete diary entry.', 16, 1);
        SELECT 0 AS DiaryDeleted;
        RETURN;
    END

    DELETE FROM Diaries WHERE diaryId = @DiaryId;

    IF DBO.DF_DiaryIdExists(@DiaryId) = 1
    BEGIN
        RAISERROR ('Failed to delete diary entry.', 16, 1);
        SELECT 0 AS DiaryDeleted;
        RETURN;
    END

    SELECT 1 AS DiaryDeleted;
END;
GO

-- 5. Procedure to get full row
CREATE OR ALTER PROCEDURE DP_GetDiary
@DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.DF_GetDiary(@DiaryId);
END;
GO

-- 6. Procedure to get dateLogged only
CREATE OR ALTER PROCEDURE DP_GetDateLogged
@DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.DF_GetDateLogged(@DiaryId) AS DateLogged;
END;
GO

-- 1. Procedure to create a new reaction
CREATE OR ALTER PROCEDURE RP_CreateReaction
@ReactionType INT
AS
BEGIN
    IF DBO.RF_IsReactionTypeLegal(@ReactionType) = 0
    BEGIN
        RAISERROR ('Failed to create reaction.', 16, 1);
        SELECT NULL AS ReactionId;
        RETURN;
    END

    DECLARE @ReactionId UNIQUEIDENTIFIER = NEWID();

    INSERT INTO Reactions (reactionId, reactionType)
    VALUES (@ReactionId, @ReactionType);

    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        RAISERROR ('Failed to create reaction.', 16, 1);
        SELECT NULL AS ReactionId;
        RETURN;
    END

    SELECT @ReactionId AS ReactionId;
END;
GO

-- 2. Procedure to update reactionType
CREATE OR ALTER PROCEDURE RP_UpdateReactionType
@ReactionId UNIQUEIDENTIFIER,
@ReactionType INT
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0 OR
       DBO.RF_IsReactionTypeLegal(@ReactionType) = 0
    BEGIN
        RAISERROR ('Failed to update reaction type.', 16, 1);
        SELECT 0 AS ReactionTypeUpdated;
        RETURN;
    END

    UPDATE Reactions SET reactionType = @ReactionType WHERE reactionId = @ReactionId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ReactionTypeUpdated;
END;
GO

-- 3. Procedure to update all columns
CREATE OR ALTER PROCEDURE RP_UpdateReaction
@ReactionId UNIQUEIDENTIFIER,
@ReactionType INT
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        RAISERROR ('Failed to update reaction.', 16, 1);
        SELECT 0 AS ReactionUpdated;
        RETURN;
    END

    EXEC RP_UpdateReactionType @ReactionId, @ReactionType;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS ReactionUpdated;
END;
GO

-- 4. Procedure to delete a reaction
CREATE OR ALTER PROCEDURE RP_DeleteReaction
@ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.RF_ReactionIdExists(@ReactionId) = 0
    BEGIN
        RAISERROR ('Failed to delete reaction.', 16, 1);
        SELECT 0 AS ReactionDeleted;
        RETURN;
    END

    DELETE FROM Reactions WHERE reactionId = @ReactionId;

    IF DBO.RF_ReactionIdExists(@ReactionId) = 1
    BEGIN
        RAISERROR ('Failed to delete reaction.', 16, 1);
        SELECT 0 AS ReactionDeleted;
        RETURN;
    END
    
    SELECT 1 AS ReactionDeleted;
END;
GO

-- 5. Procedure to get full row
CREATE OR ALTER PROCEDURE RP_GetReaction
@ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT * FROM DBO.RF_GetReaction(@ReactionId);
END;
GO

-- 6. Procedure to get reactionType
CREATE OR ALTER PROCEDURE RP_GetReactionType
@ReactionId UNIQUEIDENTIFIER
AS
BEGIN
    SELECT DBO.RF_GetReactionType(@ReactionId) AS ReactionType;
END;
GO
