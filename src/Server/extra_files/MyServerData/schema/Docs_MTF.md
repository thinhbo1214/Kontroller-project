# KontrollerDB Database Documentation

## Overview
The `KontrollerDB` database supports a game management system, storing and managing data for users, games, reviews, comments, ratings, lists, activities, diaries, and their relationships. It uses SQL Server with `UNIQUEIDENTIFIER` for primary keys and enforces data integrity through constraints, foreign keys, and helper functions.

## Schema

### Tables
*(See previous documentation for table details)*

### Relationship Tables
*(See previous documentation for relationship table details)*

### Constraints
*(See previous documentation for constraint details)*

## Functions

### Helper Functions

#### HF_IsUrlLegal
- **Description**: Checks if a URL is valid (starts with http:// or https://, no spaces, max 255 characters).
- **Parameters**:
  - `@Url` (VARCHAR(255)): The URL to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.HF_IsUrlLegal('https://example.com'); -- Returns 1
  SELECT DBO.HF_IsUrlLegal('invalid url'); -- Returns 0
  ```

### User Table Functions

#### UF_UserIdExists
- **Description**: Checks if a user exists based on their userId.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): The user ID to check.
- **Returns**: BIT (1 if exists, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.UF_UserIdExists(NEWID()); -- Returns 0 (if ID does not exist)
  ```

#### UF_GetUserDetails
- **Description**: Retrieves all user details (userId, username, email, avatar, isLoggedIn).
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): The user ID to query.
- **Returns**: TABLE (userId, username, email, avatar, isLoggedIn).
- **Example**:
  ```sql
  SELECT * FROM DBO.UF_GetUserDetails(NEWID());
  ```

#### UF_GetUsername
- **Description**: Retrieves the username for a given userId.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): The user ID to query.
- **Returns**: VARCHAR(100) (username or NULL if user does not exist).
- **Example**:
  ```sql
  SELECT DBO.UF_GetUsername(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### UF_GetEmail
- **Description**: Retrieves the email for a given userId.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): The user ID to query.
- **Returns**: VARCHAR(100) (email or NULL if user does not exist).
- **Example**:
  ```sql
  SELECT DBO.UF_GetEmail(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### UF_GetUserAvatar
- **Description**: Retrieves the avatar URL for a given userId.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): The user ID to query.
- **Returns**: VARCHAR(255) (avatar URL or NULL if user does not exist).
- **Example**:
  ```sql
  SELECT DBO.UF_GetUserAvatar(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### UF_IsUserLoggedIn
- **Description**: Checks if a user is currently logged in.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): The user ID to check.
- **Returns**: BIT (1 if logged in, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.UF_IsUserLoggedIn(NEWID()); -- Returns 0 (if ID does not exist)
  ```

#### UF_IsPasswordLegal
- **Description**: Checks if a password meets security requirements (8-50 characters, includes uppercase, lowercase, digit, and special character).
- **Parameters**:
  - `@Password` (VARCHAR(100)): The password to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.UF_IsPasswordLegal('Password123!'); -- Returns 1
  SELECT DBO.UF_IsPasswordLegal('pass'); -- Returns 0
  ```

#### UF_IsUsernameLegal
- **Description**: Checks if a username is valid (3-50 characters, alphanumeric with _-).
- **Parameters**:
  - `@Username` (VARCHAR(100)): The username to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.UF_IsUsernameLegal('john_doe'); -- Returns 1
  SELECT DBO.UF_IsUsernameLegal('jo@hn'); -- Returns 0
  ```

#### UF_IsEmailLegal
- **Description**: Checks if an email is valid (5-100 characters, basic email format).
- **Parameters**:
  - `@Email` (VARCHAR(100)): The email to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.UF_IsEmailLegal('john@example.com'); -- Returns 1
  SELECT DBO.UF_IsEmailLegal('invalid'); -- Returns 0
  ```

#### UF_IsAvatarLegal
- **Description**: Checks if an avatar URL is valid by reusing HF_IsUrlLegal.
- **Parameters**:
  - `@Avatar` (VARCHAR(255)): The avatar URL to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.UF_IsAvatarLegal('https://example.com/avatar.jpg'); -- Returns 1
  ```

#### UF_UsernameExists
- **Description**: Checks if a username already exists.
- **Parameters**:
  - `@Username` (VARCHAR(100)): The username to check.
- **Returns**: BIT (1 if exists, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.UF_UsernameExists('john_doe'); -- Returns 1 (if exists)
  ```

#### UF_EmailExists
- **Description**: Checks if an email already exists.
- **Parameters**:
  - `@Email` (VARCHAR(100)): The email to check.
- **Returns**: BIT (1 if exists, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.UF_EmailExists('john@example.com'); -- Returns 1 (if exists)
  ```

#### UF_IsPasswordMatch
- **Description**: Checks if a provided password matches the stored hash.
- **Parameters**:
  - `@UserId` (UNIQUEIDENTIFIER): The user ID to check.
  - `@Password` (VARCHAR(100)): The password to verify.
- **Returns**: BIT (1 if matches, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.UF_IsPasswordMatch(NEWID(), 'Password123!'); -- Returns 0 (if ID does not exist)
  ```

#### UF_IsUsernameUsable
- **Description**: Checks if a username is valid and not already in use.
- **Parameters**:
  - `@Username` (VARCHAR(100)): The username to check.
- **Returns**: BIT (1 if usable, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.UF_IsUsernameUsable('new_user'); -- Returns 1 (if valid and not used)
  ```

#### UF_IsEmailUsable
- **Description**: Checks if an email is valid and not already in use.
- **Parameters**:
  - `@Email` (VARCHAR(100)): The email to check.
- **Returns**: BIT (1 if usable, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.UF_IsEmailUsable('new@example.com'); -- Returns 1 (if valid and not used)
  ```

#### UF_IsUserInputValid
- **Description**: Checks if user input (username, password, email) is valid and usable.
- **Parameters**:
  - `@Username` (VARCHAR(100)): The username to validate.
  - `@Password` (VARCHAR(100)): The password to validate.
  - `@Email` (VARCHAR(100)): The email to validate.
- **Returns**: BIT (1 if all inputs are valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.UF_IsUserInputValid('new_user', 'Password123!', 'new@example.com'); -- Returns 1 (if all valid)
  ```

### Games Table Functions

#### GF_GameIdExists
- **Description**: Checks if a game exists based on its gameId.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): The game ID to check.
- **Returns**: BIT (1 if exists, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.GF_GameIdExists(NEWID()); -- Returns 0 (if ID does not exist)
  ```

#### GF_GetGameAllInfo
- **Description**: Retrieves all game details (gameId, title, descriptions, genre, avgRating, poster, backdrop, details).
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): The game ID to query.
- **Returns**: TABLE (gameId, title, descriptions, genre, avgRating, poster, backdrop, details).
- **Example**:
  ```sql
  SELECT * FROM DBO.GF_GetGameAllInfo(NEWID());
  ```

#### GF_GetGameTitle
- **Description**: Retrieves the title for a given gameId.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): The game ID to query.
- **Returns**: NVARCHAR(100) (title or NULL if game does not exist).
- **Example**:
  ```sql
  SELECT DBO.GF_GetGameTitle(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### GF_GetGameGenre
- **Description**: Retrieves the genre for a given gameId.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): The game ID to query.
- **Returns**: NVARCHAR(100) (genre or NULL if game does not exist).
- **Example**:
  ```sql
  SELECT DBO.GF_GetGameGenre(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### GF_GetGameAvgRating
- **Description**: Retrieves the average rating for a given gameId.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): The game ID to query.
- **Returns**: DECIMAL(4,2) (rating or NULL if game does not exist).
- **Example**:
  ```sql
  SELECT DBO.GF_GetGameAvgRating(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### GF_GetGamePoster
- **Description**: Retrieves the poster URL for a given gameId.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): The game ID to query.
- **Returns**: VARCHAR(255) (poster URL or NULL if game does not exist).
- **Example**:
  ```sql
  SELECT DBO.GF_GetGamePoster(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### GF_GetGameBackdrop
- **Description**: Retrieves the backdrop URL for a given gameId.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): The game ID to query.
- **Returns**: VARCHAR(255) (backdrop URL or NULL if game does not exist).
- **Example**:
  ```sql
  SELECT DBO.GF_GetGameBackdrop(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### GF_GetGameDetails
- **Description**: Retrieves the details for a given gameId.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): The game ID to query.
- **Returns**: NVARCHAR(MAX) (details or NULL if game does not exist).
- **Example**:
  ```sql
  SELECT DBO.GF_GetGameDetails(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### GF_GetGameDescription
- **Description**: Retrieves the description for a given gameId.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): The game ID to query.
- **Returns**: NVARCHAR(MAX) (description or NULL if game does not exist).
- **Example**:
  ```sql
  SELECT DBO.GF_GetGameDescription(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### GF_GetGameServices
- **Description**: Retrieves all services associated with a given gameId.
- **Parameters**:
  - `@GameId` (UNIQUEIDENTIFIER): The game ID to query.
- **Returns**: TABLE (serviceName).
- **Example**:
  ```sql
  SELECT * FROM DBO.GF_GetGameServices(NEWID());
  ```

#### GF_IsGameTitleLegal
- **Description**: Checks if a game title is valid (1-100 characters, alphanumeric with ._-).
- **Parameters**:
  - `@Title` (NVARCHAR(100)): The game title to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.GF_IsGameTitleLegal('Game Title'); -- Returns 1
  SELECT DBO.GF_IsGameTitleLegal('Invalid@Title'); -- Returns 0
  ```

#### GF_IsGameGenreLegal
- **Description**: Checks if a game genre is valid (1-100 characters).
- **Parameters**:
  - `@Genre` (NVARCHAR(100)): The game genre to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.GF_IsGameGenreLegal('Action'); -- Returns 1
  ```

#### GF_IsGameDescriptionLegal
- **Description**: Checks if a game description is valid (1-4000 characters).
- **Parameters**:
  - `@Description` (NVARCHAR(MAX)): The game description to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.GF_IsGameDescriptionLegal('This is a game description.'); -- Returns 1
  ```

#### GF_IsGameDetailsLegal
- **Description**: Checks if game details are valid (1-4000 characters).
- **Parameters**:
  - `@Details` (NVARCHAR(MAX)): The game details to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.GF_IsGameDetailsLegal('Detailed info about the game.'); -- Returns 1
  ```

#### GF_IsGamePosterLegal
- **Description**: Checks if a game poster URL is valid by reusing HF_IsUrlLegal.
- **Parameters**:
  - `@Poster` (VARCHAR(255)): The poster URL to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.GF_IsGamePosterLegal('https://example.com/poster.jpg'); -- Returns 1
  ```

#### GF_IsGameBackdropLegal
- **Description**: Checks if a game backdrop URL is valid by reusing HF_IsUrlLegal.
- **Parameters**:
  - `@Backdrop` (VARCHAR(255)): The backdrop URL to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.GF_IsGameBackdropLegal('https://example.com/backdrop.jpg'); -- Returns 1
  ```

#### GF_IsGameInputValid
- **Description**: Checks if all game inputs (title, genre, description, details, poster, backdrop) are valid.
- **Parameters**:
  - `@Title` (NVARCHAR(100)): The game title.
  - `@Genre` (NVARCHAR(100)): The game genre.
  - `@Description` (NVARCHAR(MAX)): The game description.
  - `@Details` (NVARCHAR(MAX)): The game details.
  - `@Poster` (VARCHAR(255)): The game poster URL.
  - `@Backdrop` (VARCHAR(255)): The game backdrop URL.
- **Returns**: BIT (1 if all valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.GF_IsGameInputValid('Game', 'Action', 'Description', 'Details', 'https://example.com/poster.jpg', 'https://example.com/backdrop.jpg'); -- Returns 1
  ```

### Review Table Functions

#### RF_ReviewIdExists
- **Description**: Checks if a review exists based on its reviewId.
- **Parameters**:
  - `@ReviewId` (UNIQUEIDENTIFIER): The review ID to check.
- **Returns**: BIT (1 if exists, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.RF_ReviewIdExists(NEWID()); -- Returns 0 (if ID does not exist)
  ```

#### RF_GetReview
- **Description**: Retrieves all review details.
- **Parameters**:
  - `@ReviewId` (UNIQUEIDENTIFIER): The review ID to query.
- **Returns**: TABLE (all columns from Reviews).
- **Example**:
  ```sql
  SELECT * FROM DBO.RF_GetReview(NEWID());
  ```

#### RF_GetContent
- **Description**: Retrieves the content for a given reviewId.
- **Parameters**:
  - `@ReviewId` (UNIQUEIDENTIFIER): The review ID to query.
- **Returns**: NVARCHAR(MAX) (content or NULL if review does not exist).
- **Example**:
  ```sql
  SELECT DBO.RF_GetContent(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### RF_GetRating
- **Description**: Retrieves the rating for a given reviewId.
- **Parameters**:
  - `@ReviewId` (UNIQUEIDENTIFIER): The review ID to query.
- **Returns**: DECIMAL(4,2) (rating or NULL if review does not exist).
- **Example**:
  ```sql
  SELECT DBO.RF_GetRating(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### RF_GetDateCreated
- **Description**: Retrieves the creation date for a given reviewId.
- **Parameters**:
  - `@ReviewId` (UNIQUEIDENTIFIER): The review ID to query.
- **Returns**: DATETIME (creation date or NULL if review does not exist).
- **Example**:
  ```sql
  SELECT DBO.RF_GetDateCreated(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### RF_IsContentLegality
- **Description**: Checks if review content is valid (1-4000 characters).
- **Parameters**:
  - `@Content` (NVARCHAR(MAX)): The review content to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.RF_IsContentLegality('This is a review.'); -- Returns 1
  ```

#### RF_IsRatingLegality
- **Description**: Checks if a review rating is valid (0-10).
- **Parameters**:
  - `@Rating` (DECIMAL(4,2)): The rating to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.RF_IsRatingLegality(5.5); -- Returns 1
  SELECT DBO.RF_IsRatingLegality(11); -- Returns 0
  ```

### Comment Table Functions

#### CF_CommentIdExists
- **Description**: Checks if a comment exists based on its commentId.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): The comment ID to check.
- **Returns**: BIT (1 if exists, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.CF_CommentIdExists(NEWID()); -- Returns 0 (if ID does not exist)
  ```

#### CF_GetComment
- **Description**: Retrieves all comment details.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): The comment ID to query.
- **Returns**: TABLE (all columns from Comments).
- **Example**:
  ```sql
  SELECT * FROM DBO.CF_GetComment(NEWID());
  ```

#### CF_GetContent
- **Description**: Retrieves the content for a given commentId.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): The comment ID to query.
- **Returns**: NVARCHAR(MAX) (content or NULL if comment does not exist).
- **Example**:
  ```sql
  SELECT DBO.CF_GetContent(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### CF_GetCreatedAt
- **Description**: Retrieves the creation date for a given commentId.
- **Parameters**:
  - `@CommentId` (UNIQUEIDENTIFIER): The comment ID to query.
- **Returns**: DATETIME (creation date or NULL if comment does not exist).
- **Example**:
  ```sql
  SELECT DBO.CF_GetCreatedAt(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### CF_IsContentLegality
- **Description**: Checks if comment content is valid (1-4000 characters).
- **Parameters**:
  - `@Content` (NVARCHAR(MAX)): The comment content to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.CF_IsContentLegality('This is a comment.'); -- Returns 1
  ```

### Rate Table Functions

#### RF_RateIdExists
- **Description**: Checks if a rate exists based on its rateId.
- **Parameters**:
  - `@RateId` (UNIQUEIDENTIFIER): The rate ID to check.
- **Returns**: BIT (1 if exists, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.RF_RateIdExists(NEWID()); -- Returns 0 (if ID does not exist)
  ```

#### RF_GetRate
- **Description**: Retrieves all rate details.
- **Parameters**:
  - `@RateId` (UNIQUEIDENTIFIER): The rate ID to query.
- **Returns**: TABLE (all columns from Rates).
- **Example**:
  ```sql
  SELECT * FROM DBO.RF_GetRate(NEWID());
  ```

#### RF_GetValue
- **Description**: Retrieves the rating value for a given rateId.
- **Parameters**:
  - `@RateId` (UNIQUEIDENTIFIER): The rate ID to query.
- **Returns**: INT (rating value or NULL if rate does not exist).
- **Example**:
  ```sql
  SELECT DBO.RF_GetValue(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### RF_IsRateLegal
- **Description**: Checks if a rating value is valid (0-10).
- **Parameters**:
  - `@RateValue` (INT): The rating value to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.RF_IsRateLegal(5); -- Returns 1
  SELECT DBO.RF_IsRateLegal(11); -- Returns 0
  ```

### List Table Functions

#### LF_ListIdExists
- **Description**: Checks if a list exists based on its listId.
- **Parameters**:
  - `@ListId` (UNIQUEIDENTIFIER): The list ID to check.
- **Returns**: BIT (1 if exists, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.LF_ListIdExists(NEWID()); -- Returns 0 (if ID does not exist)
  ```

#### LF_GetList
- **Description**: Retrieves all list details.
- **Parameters**:
  - `@ListId` (UNIQUEIDENTIFIER): The list ID to query.
- **Returns**: TABLE (all columns from Lists).
- **Example**:
  ```sql
  SELECT * FROM DBO.LF_GetList(NEWID());
  ```

#### LF_GetName
- **Description**: Retrieves the name for a given listId.
- **Parameters**:
  - `@ListId` (UNIQUEIDENTIFIER): The list ID to query.
- **Returns**: NVARCHAR(100) (name or NULL if list does not exist).
- **Example**:
  ```sql
  SELECT DBO.LF_GetName(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### LF_GetDescriptions
- **Description**: Retrieves the description for a given listId.
- **Parameters**:
  - `@ListId` (UNIQUEIDENTIFIER): The list ID to query.
- **Returns**: NVARCHAR(MAX) (description or NULL if list does not exist).
- **Example**:
  ```sql
  SELECT DBO.LF_GetDescriptions(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### LF_GetCreatedAt
- **Description**: Retrieves the creation date for a given listId.
- **Parameters**:
  - `@ListId` (UNIQUEIDENTIFIER): The list ID to query.
- **Returns**: DATETIME (creation date or NULL if list does not exist).
- **Example**:
  ```sql
  SELECT DBO.LF_GetCreatedAt(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### LF_IsNameLegal
- **Description**: Checks if a list name is valid (non-empty).
- **Parameters**:
  - `@Name` (NVARCHAR(100)): The list name to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.LF_IsNameLegal('My List'); -- Returns 1
  SELECT DBO.LF_IsNameLegal(''); -- Returns 0
  ```

#### LF_IsDescriptionLegal
- **Description**: Checks if a list description is valid (1-4000 characters).
- **Parameters**:
  - `@Description` (NVARCHAR(MAX)): The list description to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.LF_IsDescriptionLegal('This is a list description.'); -- Returns 1
  ```

### List Item Table Functions

#### LIF_ListItemIdExists
- **Description**: Checks if a list item exists based on its listItemId.
- **Parameters**:
  - `@ListItemId` (UNIQUEIDENTIFIER): The list item ID to check.
- **Returns**: BIT (1 if exists, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.LIF_ListItemIdExists(NEWID()); -- Returns 0 (if ID does not exist)
  ```

#### LIF_GetListItem
- **Description**: Retrieves all list item details.
- **Parameters**:
  - `@ListItemId` (UNIQUEIDENTIFIER): The list item ID to query.
- **Returns**: TABLE (all columns from List_items).
- **Example**:
  ```sql
  SELECT * FROM DBO.LIF_GetListItem(NEWID());
  ```

#### LIF_GetTitle
- **Description**: Retrieves the title for a given listItemId.
- **Parameters**:
  - `@ListItemId` (UNIQUEIDENTIFIER): The list item ID to query.
- **Returns**: NVARCHAR(100) (title or NULL if list item does not exist).
- **Example**:
  ```sql
  SELECT DBO.LIF_GetTitle(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### LIF_IsTitleLegal
- **Description**: Checks if a list item title is valid (non-empty).
- **Parameters**:
  - `@Title` (NVARCHAR(100)): The list item title to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.LIF_IsTitleLegal('Item Title'); -- Returns 1
  SELECT DBO.LIF_IsTitleLegal(''); -- Returns 0
  ```

### Activity Table Functions

#### AF_ActivityIdExists
- **Description**: Checks if an activity exists based on its activityId.
- **Parameters**:
  - `@ActivityId` (UNIQUEIDENTIFIER): The activity ID to check.
- **Returns**: BIT (1 if exists, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.AF_ActivityIdExists(NEWID()); -- Returns 0 (if ID does not exist)
  ```

#### AF_GetActivity
- **Description**: Retrieves all activity details.
- **Parameters**:
  - `@ActivityId` (UNIQUEIDENTIFIER): The activity ID to query.
- **Returns**: TABLE (all columns from Activities).
- **Example**:
  ```sql
  SELECT * FROM DBO.AF_GetActivity(NEWID());
  ```

#### AF_GetContent
- **Description**: Retrieves the content for a given activityId.
- **Parameters**:
  - `@ActivityId` (UNIQUEIDENTIFIER): The activity ID to query.
- **Returns**: NVARCHAR(MAX) (content or NULL if activity does not exist).
- **Example**:
  ```sql
  SELECT DBO.AF_GetContent(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### AF_GetDateDo
- **Description**: Retrieves the date performed for a given activityId.
- **Parameters**:
  - `@ActivityId` (UNIQUEIDENTIFIER): The activity ID to query.
- **Returns**: DATETIME (date or NULL if activity does not exist).
- **Example**:
  ```sql
  SELECT DBO.AF_GetDateDo(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### AF_IsContentLegal
- **Description**: Checks if activity content is valid (1-4000 characters).
- **Parameters**:
  - `@Content` (NVARCHAR(MAX)): The activity content to validate.
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.AF_IsContentLegal('This is an activity.'); -- Returns 1
  ```

### Diary Table Functions

#### DF_DiaryIdExists
- **Description**: Checks if a diary entry exists based on its diaryId.
- **Parameters**:
  - `@DiaryId` (UNIQUEIDENTIFIER): The diary ID to check.
- **Returns**: BIT (1 if exists, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.DF_DiaryIdExists(NEWID()); -- Returns 0 (if ID does not exist)
  ```

#### DF_GetDiary
- **Description**: Retrieves all diary entry details.
- **Parameters**:
  - `@DiaryId` (UNIQUEIDENTIFIER): The diary ID to query.
- **Returns**: TABLE (all columns from Diaries).
- **Example**:
  ```sql
  SELECT * FROM DBO.DF_GetDiary(NEWID());
  ```

#### DF_GetDateLogged
- **Description**: Retrieves the logged date for a given diaryId.
- **Parameters**:
  - `@DiaryId` (UNIQUEIDENTIFIER): The diary ID to query.
- **Returns**: DATETIME (logged date or NULL if diary does not exist).
- **Example**:
  ```sql
  SELECT DBO.DF_GetDateLogged(NEWID()); -- Returns NULL (if ID does not exist)
  ```

### Reaction Table Functions

#### RF_ReactionIdExists
- **Description**: Checks if a reaction exists based on its reactionId.
- **Parameters**:
  - `@ReactionId` (UNIQUEIDENTIFIER): The reaction ID to check.
- **Returns**: BIT (1 if exists, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.RF_ReactionIdExists(NEWID()); -- Returns 0 (if ID does not exist)
  ```

#### RF_IsReactionTypeLegal
- **Description**: Checks if a reaction type is valid (0-3, representing Like, Dislike, Love, Angry).
- **Parameters**:
  - `@ReactionType` (INT): The reaction type to validate (0: Like, 1: Dislike, 2: Love, 3: Angry).
- **Returns**: BIT (1 if valid, 0 otherwise).
- **Example**:
  ```sql
  SELECT DBO.RF_IsReactionTypeLegal(2); -- Returns 1 (Love)
  SELECT DBO.RF_IsReactionTypeLegal(4); -- Returns 0
  ```

#### RF_GetReaction
- **Description**: Retrieves all reaction details.
- **Parameters**:
  - `@ReactionId` (UNIQUEIDENTIFIER): The reaction ID to query.
- **Returns**: TABLE (all columns from Reactions).
- **Example**:
  ```sql
  SELECT * FROM DBO.RF_GetReaction(NEWID());
  ```

#### RF_GetReactionType
- **Description**: Retrieves the reaction type for a given reactionId.
- **Parameters**:
  - `@ReactionId` (UNIQUEIDENTIFIER): The reaction ID to query.
- **Returns**: INT (reaction type: 0 for Like, 1 for Dislike, 2 for Love, 3 for Angry, or NULL if reaction does not exist).
- **Example**:
  ```sql
  SELECT DBO.RF_GetReactionType(NEWID()); -- Returns NULL (if ID does not exist)
  ```

#### RF_GetDateDo
- **Description**: Retrieves the date performed for a given reactionId.
- **Parameters**:
  - `@ReactionId` (UNIQUEIDENTIFIER): The reaction ID to query.
- **Returns**: DATETIME (date or NULL if reaction does not exist).
- **Example**:
  ```sql
  SELECT DBO.RF_GetDateDo(NEWID()); -- Returns NULL (if ID does not exist)
  ```