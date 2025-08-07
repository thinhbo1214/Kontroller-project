# Database Stored Procedures Documentation

## Table of Contents
1. [Introduction](#introduction)
2. [Procedure Helper](#procedure-helper)
3. [User Table Procedures](#user-table-procedures)
4. [Games Table Procedures](#games-table-procedures)
5. [Review Table Procedures](#review-table-procedures)
6. [Comment Table Procedures](#comment-table-procedures)
7. [Rate Table Procedures](#rate-table-procedures)
8. [List Table Procedures](#list-table-procedures)
9. [List Item Procedures](#list-item-procedures)
10. [Activity Procedures](#activity-procedures)
11. [Diary Procedures](#diary-procedures)
12. [Reaction Procedures](#reaction-procedures)

## Introduction
This document describes the stored procedures for managing users, games, reviews, comments, rates, lists, list items, activities, diaries, and reactions in a database system. Each procedure is designed to handle specific operations (create, update, delete, retrieve) with validation checks to ensure data integrity. Procedures use OUTPUT parameters or SELECT statements to return results.

## Procedure Helper

### HP_GenerateStrongPassword
- **Description**: Generates a strong random password with at least one uppercase, lowercase, digit, and special character.
- **Parameters**:
  - `@Length (INT)`: Desired password length (8-50, default 12).
  - `@Password (VARCHAR(100) OUTPUT)`: Generated password.
- **Returns**: `@Password` contains the generated password or NULL if length is invalid.
- **Logic**: Validates length, builds password with mandatory character types, fills remaining length with random characters, and shuffles the result.

## User Table Procedures

### UP_CreateUser
- **Description**: Creates a new user with a unique ID, username, hashed password, and email.
- **Parameters**:
  - `@Username (VARCHAR(100))`: Username for the new user.
  - `@Password (VARCHAR(100))`: Password to be hashed.
  - `@Email (VARCHAR(100))`: User's email address.
  - `@NewUserId (UNIQUEIDENTIFIER OUTPUT)`: Generated user ID.
- **Returns**: `@NewUserId` contains the new user’s ID or NULL if creation fails.
- **Logic**: Validates input, generates a unique ID, inserts user data with hashed password, and verifies insertion.

### UP_UpdateUsername
- **Description**: Updates the username of an existing user.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to update.
  - `@NewUsername (VARCHAR(100))`: New username.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates the new username and updates the Users table.

### UP_UpdateUserEmail
- **Description**: Updates the email address of an existing user.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to update.
  - `@NewEmail (VARCHAR(100))`: New email address.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates the new email and updates the Users table.

### UP_UpdateUserAvatar
- **Description**: Updates the avatar of an existing user.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to update.
  - `@NewAvatar (VARCHAR(255))`: New avatar URL or path.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates the new avatar and updates the Users table.

### UP_UpdateUserLoginStatus
- **Description**: Updates the login status of an existing user.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to update.
  - `@IsLoggedIn (BIT)`: New login status (1 for logged in, 0 for logged out).
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates the login status and updates the Users table.

### UP_UpdatePassword
- **Description**: Updates the password of an existing user.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to update.
  - `@NewPassword (VARCHAR(100))`: New password to be hashed.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates the new password, hashes it, and updates the Users table.

### UP_UpdateUserDetails
- **Description**: Updates multiple user details (username, password, email, avatar, login status) in a single call.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to update.
  - `@Username (VARCHAR(100))`: New username (optional).
  - `@Password (VARCHAR(100))`: New password (optional).
  - `@Email (VARCHAR(100))`: New email (optional).
  - `@Avatar (VARCHAR(255))`: New avatar (optional).
  - `@IsUserLoggedIn (BIT)`: New login status (optional).
  - `@Result (INT OUTPUT)`: Total number of rows affected.
- **Returns**: `@Result` contains the sum of rows affected by individual updates.
- **Logic**: Calls individual update procedures for each provided parameter and sums the affected rows.

### UP_DeleteUser
- **Description**: Deletes a user after verifying their password.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to delete.
  - `@Password (VARCHAR(100))`: Password to verify user identity.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Verifies the password, deletes the user, and checks deletion success.

### UP_CheckUserLoggedIn
- **Description**: Checks if a user is logged in.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to check.
- **Returns**: `BIT` (1 if user is logged in, 0 otherwise).
- **Logic**: Calls UF_IsUserLoggedIn function to retrieve login status.

### UP_GetUserDetails
- **Description**: Retrieves all details for a specified user.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to query.
- **Returns**: `TABLE` with all columns from UF_GetUserDetails function.
- **Logic**: Calls UF_GetUserDetails to fetch user details.

### UP_GetUserDisplayInfo
- **Description**: Retrieves the avatar and username for a specified user.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to query.
- **Returns**: `TABLE` with avatar and username from UF_GetUserAvatar and UF_GetUsername.
- **Logic**: Calls respective functions to fetch avatar and username.

### UP_GetUserEmail
- **Description**: Retrieves the email address for a specified user.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to query.
- **Returns**: `VARCHAR(100)` (user's email or NULL if not found).
- **Logic**: Calls UF_GetEmail to fetch the email address.

### UP_GetUserUsername
- **Description**: Retrieves the username for a specified user.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to query.
- **Returns**: `VARCHAR(100)` (user's username or NULL if not found).
- **Logic**: Calls UF_GetUsername to fetch the username.

### UP_GetUserAvatar
- **Description**: Retrieves the avatar for a specified user.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to query.
- **Returns**: `VARCHAR(255)` (user's avatar URL or NULL if not found).
- **Logic**: Calls UF_GetUserAvatar to fetch the avatar.

### UP_GetUserLoginStatus
- **Description**: Retrieves the login status for a specified user.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to query.
- **Returns**: `BIT` (1 if user is logged in, 0 otherwise).
- **Logic**: Calls UF_IsUserLoggedIn to fetch login status.

### UP_CheckUserExists
- **Description**: Checks if a user exists by their ID.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to check.
- **Returns**: `BIT` (1 if user exists, 0 otherwise).
- **Logic**: Calls UF_UserIdExists to check user existence.

### UP_CheckLoginAccount
- **Description**: Verifies user login credentials and retrieves user ID.
- **Parameters**:
  - `@Username (VARCHAR(100))`: Username to verify.
  - `@Password (VARCHAR(100))`: Password to verify.
  - `@UserId (UNIQUEIDENTIFIER OUTPUT)`: ID of the verified user.
- **Returns**: `@UserId` contains the user ID if credentials are valid, NULL otherwise.
- **Logic**: Validates username and password, retrieves user ID, and verifies password match.

### UP_ForgetPassword
- **Description**: Generates and updates a new password for a user based on their email.
- **Parameters**:
  - `@Email (VARCHAR(100))`: User's email address.
  - `@NewPassword (VARCHAR(100) OUTPUT)`: Generated new password.
- **Returns**: `@NewPassword` contains the new password or NULL if email is invalid or update fails.
- **Logic**: Verifies email, generates a new password, updates the user’s password, and verifies success.

### UP_ChangePassword
- **Description**: Changes a user's password after verifying the old password.
- **Parameters**:
  - `@UserId (UNIQUEIDENTIFIER)`: ID of the user to update.
  - `@OldPassword (VARCHAR(100))`: Current password for verification.
  - `@NewPassword (VARCHAR(100))`: New password to set.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Verifies user existence and old password, validates new password, and updates the password.

## Games Table Procedures

### GP_CreateGame
- **Description**: Creates a new game with title, genre, description, and details.
- **Parameters**:
  - `@Title (NVARCHAR(100))`: Game title.
  - `@Genre (NVARCHAR(100))`: Game genre.
  - `@Description (NVARCHAR(MAX))`: Game description.
  - `@Details (NVARCHAR(MAX))`: Additional game details.
  - `@GameId (UNIQUEIDENTIFIER OUTPUT)`: Generated ID for the new game.
- **Returns**: `@GameId` contains the new game’s ID or NULL if creation fails.
- **Logic**: Validates input, generates a unique ID, inserts game data, and verifies insertion.

### GP_UpdateGameTitle
- **Description**: Updates the title of an existing game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to update.
  - `@NewTitle (NVARCHAR(100))`: New game title.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates the new title and updates the Games table.

### GP_UpdateGameGenre
- **Description**: Updates the genre of an existing game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to update.
  - `@NewGenre (NVARCHAR(100))`: New game genre.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates the new genre and updates the Games table.

### GP_UpdateGameDescription
- **Description**: Updates the description of an existing game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to update.
  - `@NewDescription (NVARCHAR(MAX))`: New game description.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates the new description and updates the Games table.

### GP_UpdateGameDetails
- **Description**: Updates the details of an existing game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to update.
  - `@NewDetails (NVARCHAR(MAX))`: New game details.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates the new details and updates the Games table.

### GP_UpdateGamePoster
- **Description**: Updates the poster URL of an existing game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to update.
  - `@NewPoster (VARCHAR(255))`: New poster URL.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates the new poster and updates the Games table.

### GP_UpdateGameBackdrop
- **Description**: Updates the backdrop URL of an existing game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to update.
  - `@NewBackdrop (VARCHAR(255))`: New backdrop URL.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates the new backdrop and updates the Games table.

### GP_UpdateGameAllInfo
- **Description**: Updates multiple game attributes (title, genre, description, details, poster, backdrop) in a single call.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to update.
  - `@Title (NVARCHAR(100))`: New game title (optional).
  - `@Genre (NVARCHAR(100))`: New game genre (optional).
  - `@Descriptions (NVARCHAR(MAX))`: New game description (optional).
  - `@Details (NVARCHAR(MAX))`: New game details (optional).
  - `@Poster (VARCHAR(255))`: New poster URL (optional).
  - `@Backdrop (VARCHAR(255))`: New backdrop URL (optional).
  - `@Result (INT OUTPUT)`: Total number of rows affected.
- **Returns**: `@Result` contains the sum of rows affected by individual updates.
- **Logic**: Calls individual update procedures for each provided parameter and sums the affected rows.

### GP_DeleteGame
- **Description**: Deletes a game by its ID.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to delete.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Verifies game existence, deletes the game, and checks deletion success.

### GP_GetGameAllInfo
- **Description**: Retrieves all information for a specified game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to query.
- **Returns**: `TABLE` with all columns from GF_GetGameAllInfo function.
- **Logic**: Calls GF_GetGameAllInfo to fetch game details.

### GP_GetGameTitle
- **Description**: Retrieves the title of a specified game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to query.
- **Returns**: `NVARCHAR(100)` (game title or NULL if not found).
- **Logic**: Calls GF_GetGameTitle to fetch the title.

### GP_GetGameGenre
- **Description**: Retrieves the genre of a specified game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to query.
- **Returns**: `NVARCHAR(100)` (game genre or NULL if not found).
- **Logic**: Calls GF_GetGameGenre to fetch the genre.

### GP_GetGameDescription
- **Description**: Retrieves the description of a specified game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to query.
- **Returns**: `NVARCHAR(MAX)` (game description or NULL if not found).
- **Logic**: Calls GF_GetGameDescription to fetch the description.

### GP_GetGameDetails
- **Description**: Retrieves the details of a specified game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to query.
- **Returns**: `NVARCHAR(MAX)` (game details or NULL if not found).
- **Logic**: Calls GF_GetGameDetails to fetch the details.

### GP_GetGamePoster
- **Description**: Retrieves the poster URL of a specified game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to query.
- **Returns**: `VARCHAR(255)` (game poster URL or NULL if not found).
- **Logic**: Calls GF_GetGamePoster to fetch the poster.

### GP_GetGameBackdrop
- **Description**: Retrieves the backdrop URL of a specified game.
- **Parameters**:
  - `@GameId (UNIQUEIDENTIFIER)`: ID of the game to query.
- **Returns**: `VARCHAR(255)` (game backdrop URL or NULL if not found).
- **Logic**: Calls GF_GetGameBackdrop to fetch the backdrop.

## Review Table Procedures

### RP_CreateReview
- **Description**: Creates a new review with specified content.
- **Parameters**:
  - `@Content (NVARCHAR(MAX))`: Review content.
  - `@ReviewId (UNIQUEIDENTIFIER OUTPUT)`: Generated ID for the new review.
- **Returns**: `@ReviewId` contains the new review’s ID or NULL if creation fails.
- **Logic**: Validates content, generates a unique ID, inserts review data, and verifies insertion.

### RP_UpdateReviewContent
- **Description**: Updates the content of an existing review.
- **Parameters**:
  - `@ReviewId (UNIQUEIDENTIFIER)`: ID of the review to update.
  - `@Content (NVARCHAR(MAX))`: New review content.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates new content and updates the Reviews table.

### RP_UpdateReviewRating
- **Description**: Updates the rating of an existing review.
- **Parameters**:
  - `@ReviewId (UNIQUEIDENTIFIER)`: ID of the review to update.
  - `@Rating (DECIMAL(4,2))`: New rating value.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates new rating and updates the Reviews table.

### RP_UpdateReviewDetails
- **Description**: Updates both content and rating of an existing review.
- **Parameters**:
  - `@ReviewId (UNIQUEIDENTIFIER)`: ID of the review to update.
  - `@Content (NVARCHAR(MAX))`: New review content.
  - `@Rating (DECIMAL(4,2))`: New rating value.
  - `@Result (INT OUTPUT)`: Total number of rows affected.
- **Returns**: `@Result` contains the sum of rows affected by content and rating updates.
- **Logic**: Calls individual update procedures for content and rating.

### RP_DeleteReview
- **Description**: Deletes a review by its ID.
- **Parameters**:
  - `@ReviewId (UNIQUEIDENTIFIER)`: ID of the review to delete.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Verifies review existence, deletes the review, and checks deletion success.

### RP_GetReviewDetails
- **Description**: Retrieves all details for a specified review.
- **Parameters**:
  - `@ReviewId (UNIQUEIDENTIFIER)`: ID of the review to query.
- **Returns**: `TABLE` with all columns from RF_GetReview function.
- **Logic**: Calls RF_GetReview to fetch review details.

### RP_GetReviewContent
- **Description**: Retrieves the content of a specified review.
- **Parameters**:
  - `@ReviewId (UNIQUEIDENTIFIER)`: ID of the review to query.
- **Returns**: `NVARCHAR(MAX)` (review content or NULL if not found).
- **Logic**: Calls RF_GetContent to fetch the content.

### RP_GetReviewRating
- **Description**: Retrieves the rating of a specified review.
- **Parameters**:
  - `@ReviewId (UNIQUEIDENTIFIER)`: ID of the review to query.
- **Returns**: `DECIMAL(4,2)` (review rating or NULL if not found).
- **Logic**: Calls RF_GetRating to fetch the rating.

### RP_GetReviewDate
- **Description**: Retrieves the creation date of a specified review.
- **Parameters**:
  - `@ReviewId (UNIQUEIDENTIFIER)`: ID of the review to query.
- **Returns**: `DATETIME` (review creation date or NULL if not found).
- **Logic**: Calls RF_GetDateCreated to fetch the creation date.

## Comment Table Procedures

### CP_CreateComment
- **Description**: Creates a new comment with specified content.
- **Parameters**:
  - `@Content (NVARCHAR(MAX))`: Comment content.
  - `@CommentId (UNIQUEIDENTIFIER OUTPUT)`: Generated ID for the new comment.
- **Returns**: `@CommentId` contains the new comment’s ID or NULL if creation fails.
- **Logic**: Validates content, generates a unique ID, inserts comment data, and verifies insertion.

### CP_UpdateCommentContent
- **Description**: Updates the content of an existing comment.
- **Parameters**:
  - `@CommentId (UNIQUEIDENTIFIER)`: ID of the comment to update.
  - `@Content (NVARCHAR(MAX))`: New comment content.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates new content and updates the Comments table.

### CP_DeleteComment
- **Description**: Deletes a comment by its ID.
- **Parameters**:
  - `@CommentId (UNIQUEIDENTIFIER)`: ID of the comment to delete.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Verifies comment existence, deletes the comment, and checks deletion success.

### CP_GetCommentDetails
- **Description**: Retrieves all details for a specified comment.
- **Parameters**:
  - `@CommentId (UNIQUEIDENTIFIER)`: ID of the comment to query.
- **Returns**: `TABLE` with all columns from CF_GetComment function.
- **Logic**: Calls CF_GetComment to fetch comment details.

### CP_GetCommentContent
- **Description**: Retrieves the content of a specified comment.
- **Parameters**:
  - `@CommentId (UNIQUEIDENTIFIER)`: ID of the comment to query.
- **Returns**: `NVARCHAR(MAX)` (comment content or NULL if not found).
- **Logic**: Calls CF_GetContent to fetch the content.

### CP_GetCommentCreatedDate
- **Description**: Retrieves the creation date of a specified comment.
- **Parameters**:
  - `@CommentId (UNIQUEIDENTIFIER)`: ID of the comment to query.
- **Returns**: `DATETIME` (comment creation date or NULL if not found).
- **Logic**: Calls CF_GetCreatedAt to fetch the creation date.

## Rate Table Procedures

### RP_CreateRate
- **Description**: Creates a new rate with specified value.
- **Parameters**:
  - `@RateValue (INT)`: Rate value.
  - `@RateId (UNIQUEIDENTIFIER OUTPUT)`: Generated ID for the new rate.
- **Returns**: `@RateId` contains the new rate’s ID or NULL if creation fails.
- **Logic**: Validates rate value, generates a unique ID, inserts rate data, and verifies insertion.

### RP_UpdateRateValue
- **Description**: Updates the value of an existing rate.
- **Parameters**:
  - `@RateId (UNIQUEIDENTIFIER)`: ID of the rate to update.
  - `@RateValue (INT)`: New rate value.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates new rate value and updates the Rates table.

### RP_DeleteRate
- **Description**: Deletes a rate by its ID.
- **Parameters**:
  - `@RateId (UNIQUEIDENTIFIER)`: ID of the rate to delete.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Verifies rate existence, deletes the rate, and checks deletion success.

### RP_GetRateDetails
- **Description**: Retrieves all details for a specified rate.
- **Parameters**:
  - `@RateId (UNIQUEIDENTIFIER)`: ID of the rate to query.
- **Returns**: `TABLE` with all columns from RF_GetRate function.
- **Logic**: Calls RF_GetRate to fetch rate details.

### RP_GetRateValue
- **Description**: Retrieves the value of a specified rate.
- **Parameters**:
  - `@RateId (UNIQUEIDENTIFIER)`: ID of the rate to query.
- **Returns**: `INT` (rate value or NULL if not found).
- **Logic**: Calls RF_GetValue to fetch the rate value.

## List Table Procedures

### LP_CreateList
- **Description**: Creates a new list with specified name and optional description.
- **Parameters**:
  - `@Name (NVARCHAR(100))`: List name.
  - `@Descriptions (NVARCHAR(MAX))`: List description (optional).
  - `@ListId (UNIQUEIDENTIFIER OUTPUT)`: Generated ID for the new list.
- **Returns**: `@ListId` contains the new list’s ID or NULL if creation fails.
- **Logic**: Validates name and description, generates a unique ID, inserts list data, and verifies insertion.

### LP_UpdateListName
- **Description**: Updates the name of an existing list.
- **Parameters**:
  - `@ListId (UNIQUEIDENTIFIER)`: ID of the list to update.
  - `@Name (NVARCHAR(100))`: New list name.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates new name and updates the Lists table.

### LP_UpdateListDescriptions
- **Description**: Updates the description of an existing list.
- **Parameters**:
  - `@ListId (UNIQUEIDENTIFIER)`: ID of the list to update.
  - `@Descriptions (NVARCHAR(MAX))`: New list description.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates new description and updates the Lists table.

### LP_UpdateListDetails
- **Description**: Updates both name and description of an existing list.
- **Parameters**:
  - `@ListId (UNIQUEIDENTIFIER)`: ID of the list to update.
  - `@Name (NVARCHAR(100))`: New list name.
  - `@Descriptions (NVARCHAR(MAX))`: New list description.
  - `@Result (INT OUTPUT)`: Total number of rows affected.
- **Returns**: `@Result` contains the sum of rows affected by name and description updates.
- **Logic**: Calls individual update procedures for name and description.

### LP_DeleteList
- **Description**: Deletes a list by its ID.
- **Parameters**:
  - `@ListId (UNIQUEIDENTIFIER)`: ID of the list to delete.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Verifies list existence, deletes the list, and checks deletion success.

### LP_GetListDetails
- **Description**: Retrieves all details for a specified list.
- **Parameters**:
  - `@ListId (UNIQUEIDENTIFIER)`: ID of the list to query.
- **Returns**: `TABLE` with all columns from LF_GetList function.
- **Logic**: Calls LF_GetList to fetch list details.

### LP_GetListName
- **Description**: Retrieves the name of a specified list.
- **Parameters**:
  - `@ListId (UNIQUEIDENTIFIER)`: ID of the list to query.
- **Returns**: `NVARCHAR(100)` (list name or NULL if not found).
- **Logic**: Calls LF_GetName to fetch the list name.

### LP_GetListDescriptions
- **Description**: Retrieves the description of a specified list.
- **Parameters**:
  - `@ListId (UNIQUEIDENTIFIER)`: ID of the list to query.
- **Returns**: `NVARCHAR(MAX)` (list description or NULL if not found).
- **Logic**: Calls LF_GetDescriptions to fetch the description.

### LP_GetListCreatedDate
- **Description**: Retrieves the creation date of a specified list.
- **Parameters**:
  - `@ListId (UNIQUEIDENTIFIER)`: ID of the list to query.
- **Returns**: `DATETIME` (list creation date or NULL if not found).
- **Logic**: Calls LF_GetCreatedAt to fetch the creation date.

## List Item Procedures

### LIP_CreateListItem
- **Description**: Creates a new list item with specified title.
- **Parameters**:
  - `@Title (NVARCHAR(100))`: List item title.
  - `@ListItemId (UNIQUEIDENTIFIER OUTPUT)`: Generated ID for the new list item.
- **Returns**: `@ListItemId` contains the new list item’s ID or NULL if creation fails.
- **Logic**: Validates title, generates a unique ID, inserts list item data, and verifies insertion.

### LIP_UpdateTitle
- **Description**: Updates the title of an existing list item.
- **Parameters**:
  - `@ListItemId (UNIQUEIDENTIFIER)`: ID of the list item to update.
  - `@Title (NVARCHAR(100))`: New list item title.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates list item ID and title, updates the List_items table.

### LIP_UpdateListItem
- **Description**: Updates all columns of an existing list item.
- **Parameters**:
  - `@ListItemId (UNIQUEIDENTIFIER)`: ID of the list item to update.
  - `@Title (NVARCHAR(100))`: New list item title.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Calls LIP_UpdateTitle to update the title.

### LIP_DeleteListItem
- **Description**: Deletes a list item by its ID.
- **Parameters**:
  - `@ListItemId (UNIQUEIDENTIFIER)`: ID of the list item to delete.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Verifies list item existence, deletes the list item, and checks deletion success.

### LIP_GetListItem
- **Description**: Retrieves all details for a specified list item.
- **Parameters**:
  - `@ListItemId (UNIQUEIDENTIFIER)`: ID of the list item to query.
- **Returns**: `TABLE` with all columns from LIF_GetListItem function.
- **Logic**: Calls LIF_GetListItem to fetch list item details.

### LIP_GetTitle
- **Description**: Retrieves the title of a specified list item.
- **Parameters**:
  - `@ListItemId (UNIQUEIDENTIFIER)`: ID of the list item to query.
- **Returns**: `NVARCHAR(100)` (list item title or NULL if not found).
- **Logic**: Calls LIF_GetTitle to fetch the title.

## Activity Procedures

### AP_CreateActivity
- **Description**: Creates a new activity with specified content.
- **Parameters**:
  - `@Content (NVARCHAR(MAX))`: Activity content.
  - `@ActivityId (UNIQUEIDENTIFIER OUTPUT)`: Generated ID for the new activity.
- **Returns**: `@ActivityId` contains the new activity’s ID or NULL if creation fails.
- **Logic**: Validates content, generates a unique ID, inserts activity data, and verifies insertion.

### AP_UpdateContent
- **Description**: Updates the content of an existing activity.
- **Parameters**:
  - `@ActivityId (UNIQUEIDENTIFIER)`: ID of the activity to update.
  - `@Content (NVARCHAR(MAX))`: New activity content.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates activity ID and content, updates the Activities table.

### AP_UpdateActivity
- **Description**: Updates all columns of an existing activity.
- **Parameters**:
  - `@ActivityId (UNIQUEIDENTIFIER)`: ID of the activity to update.
  - `@Content (NVARCHAR(MAX))`: New activity content.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Calls AP_UpdateContent to update the content.

### AP_DeleteActivity
- **Description**: Deletes an activity by its ID.
- **Parameters**:
  - `@ActivityId (UNIQUEIDENTIFIER)`: ID of the activity to delete.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Verifies activity existence, deletes the activity, and checks deletion success.

### AP_GetActivity
- **Description**: Retrieves all details for a specified activity.
- **Parameters**:
  - `@ActivityId (UNIQUEIDENTIFIER)`: ID of the activity to query.
- **Returns**: `TABLE` with all columns from AF_GetActivity function.
- **Logic**: Calls AF_GetActivity to fetch activity details.

### AP_GetContent
- **Description**: Retrieves the content of a specified activity.
- **Parameters**:
  - `@ActivityId (UNIQUEIDENTIFIER)`: ID of the activity to query.
- **Returns**: `NVARCHAR(MAX)` (activity content or NULL if not found).
- **Logic**: Calls AF_GetContent to fetch the content.

### AP_GetDateDo
- **Description**: Retrieves the date performed for a specified activity.
- **Parameters**:
  - `@ActivityId (UNIQUEIDENTIFIER)`: ID of the activity to query.
- **Returns**: `DATETIME` (activity date or NULL if not found).
- **Logic**: Calls AF_GetDateDo to fetch the date.

## Diary Procedures

### DP_CreateDiary
- **Description**: Creates a new diary entry with a unique ID.
- **Parameters**:
  - `@DiaryId (UNIQUEIDENTIFIER OUTPUT)`: Generated ID for the new diary entry.
- **Returns**: `@DiaryId` contains the new diary entry’s ID or NULL if creation fails.
- **Logic**: Generates a unique ID, inserts diary data, and verifies insertion.

### DP_UpdateDateLogged
- **Description**: Updates the logged date of an existing diary entry.
- **Parameters**:
  - `@DiaryId (UNIQUEIDENTIFIER)`: ID of the diary entry to update.
  - `@DateLogged (DATETIME)`: New logged date.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates diary ID and date, updates the Diaries table.

### DP_UpdateDiary
- **Description**: Updates all columns of an existing diary entry.
- **Parameters**:
  - `@DiaryId (UNIQUEIDENTIFIER)`: ID of the diary entry to update.
  - `@DateLogged (DATETIME)`: New logged date.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Calls DP_UpdateDateLogged to update the logged date.

### DP_DeleteDiary
- **Description**: Deletes a diary entry by its ID.
- **Parameters**:
  - `@DiaryId (UNIQUEIDENTIFIER)`: ID of the diary entry to delete.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Verifies diary existence, deletes the diary entry, and checks deletion success.

### DP_GetDiary
- **Description**: Retrieves all details for a specified diary entry.
- **Parameters**:
  - `@DiaryId (UNIQUEIDENTIFIER)`: ID of the diary entry to query.
- **Returns**: `TABLE` with all columns from DF_GetDiary function.
- **Logic**: Calls DF_GetDiary to fetch diary details.

### DP_GetDateLogged
- **Description**: Retrieves the logged date of a specified diary entry.
- **Parameters**:
  - `@DiaryId (UNIQUEIDENTIFIER)`: ID of the diary entry to query.
- **Returns**: `DATETIME` (diary logged date or NULL if not found).
- **Logic**: Calls DF_GetDateLogged to fetch the logged date.

## Reaction Procedures

### RP_CreateReaction
- **Description**: Creates a new reaction with specified reaction type.
- **Parameters**:
  - `@ReactionType (INT)`: Type of reaction.
  - `@ReactionId (UNIQUEIDENTIFIER OUTPUT)`: Generated ID for the new reaction.
- **Returns**: `@ReactionId` contains the new reaction’s ID or NULL if creation fails.
- **Logic**: Validates reaction type, generates a unique ID, inserts reaction data, and verifies insertion.

### RP_UpdateReactionType
- **Description**: Updates the reaction type of an existing reaction.
- **Parameters**:
  - `@ReactionId (UNIQUEIDENTIFIER)`: ID of the reaction to update.
  - `@ReactionType (INT)`: New reaction type.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Validates reaction ID and type, updates the Reactions table.

### RP_UpdateReaction
- **Description**: Updates all columns of an existing reaction.
- **Parameters**:
  - `@ReactionId (UNIQUEIDENTIFIER)`: ID of the reaction to update.
  - `@ReactionType (INT)`: New reaction type.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Calls RP_UpdateReactionType to update the reaction type.

### RP_DeleteReaction
- **Description**: Deletes a reaction by its ID.
- **Parameters**:
  - `@ReactionId (UNIQUEIDENTIFIER)`: ID of the reaction to delete.
  - `@Result (INT OUTPUT)`: Number of rows affected (1 for success, 0 for failure).
- **Returns**: `@Result` indicates success (1) or failure (0).
- **Logic**: Verifies reaction existence, deletes the reaction, and checks deletion success.

### RP_GetReaction
- **Description**: Retrieves all details for a specified reaction.
- **Parameters**:
  - `@ReactionId (UNIQUEIDENTIFIER)`: ID of the reaction to query.
- **Returns**: `TABLE` with all columns from RF_GetReaction function.
- **Logic**: Calls RF_GetReaction to fetch reaction details.

### RP_GetReactionType
- **Description**: Retrieves the reaction type of a specified reaction.
- **Parameters**:
  - `@ReactionId (UNIQUEIDENTIFIER)`: ID of the reaction to query.
- **Returns**: `INT` (reaction type or NULL if not found).
- **Logic**: Calls RF_GetReactionType to fetch the reaction type.