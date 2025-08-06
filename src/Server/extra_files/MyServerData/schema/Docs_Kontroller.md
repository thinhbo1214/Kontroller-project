# KontrollerDB Database Documentation

## Overview
The `KontrollerDB` database supports a game management system, storing and managing data for users, games, reviews, comments, ratings, lists, activities, diaries, and their relationships. It uses SQL Server with `UNIQUEIDENTIFIER` for primary keys and enforces data integrity through constraints and foreign keys.

## Schema

### Tables

#### Users
Stores user information, including credentials and profile details.

| Column         | Type                | Description                                      | Constraints                              |
|----------------|---------------------|--------------------------------------------------|------------------------------------------|
| userId         | UNIQUEIDENTIFIER    | Unique identifier for the user.                  | PRIMARY KEY, DEFAULT NEWID()            |
| username       | VARCHAR(100)        | Unique username (3-100 characters, alphanumeric with ._-). | NOT NULL, UNIQUE, CHECK(C_USER_USERNAME) |
| password_hash  | VARBINARY(128)      | SHA2_256 hashed password.                       | NOT NULL                                |
| email          | VARCHAR(100)        | Unique email address (valid format).             | NOT NULL, UNIQUE, CHECK(C_USER_EMAIL)   |
| avatar         | VARCHAR(255)        | Optional URL to user avatar image.              | NULL                                    |
| isLoggedIn     | BIT                 | Indicates if the user is currently logged in.    | DEFAULT 0                               |

#### Games
Stores game information, including title, description, and ratings.

| Column         | Type                | Description                                      | Constraints                              |
|----------------|---------------------|--------------------------------------------------|------------------------------------------|
| gameId         | UNIQUEIDENTIFIER    | Unique identifier for the game.                  | PRIMARY KEY, DEFAULT NEWID()            |
| title          | NVARCHAR(100)       | Game title (1-100 characters, alphanumeric with ._-). | NOT NULL, CHECK(C_GAME_TITLE)        |
| descriptions   | NVARCHAR(MAX)       | Detailed description of the game.                | NOT NULL                                |
| genre          | NVARCHAR(100)       | Game genre (alphanumeric with ._-).             | NOT NULL, CHECK(C_GAME_GENRE)           |
| avgRating      | DECIMAL(4,2)        | Average rating (0.00-10.00).                    | DEFAULT 0.00                            |
| poster         | VARCHAR(255)        | Optional URL to game poster image.              | NULL                                    |
| backdrop       | VARCHAR(255)        | Optional URL to game backdrop image.            | NULL                                    |
| details        | NVARCHAR(MAX)       | Additional game details.                        | NOT NULL                                |

#### Game_Service
Stores services associated with games (e.g., platforms or stores).

| Column         | Type                | Description                                      | Constraints                              |
|----------------|---------------------|--------------------------------------------------|------------------------------------------|
| gameId         | UNIQUEIDENTIFIER    | Foreign key referencing Games.                  | PRIMARY KEY (with serviceName), FOREIGN KEY |
| serviceName    | NVARCHAR(30)        | Service name (1-30 characters, alphanumeric with ._-). | NOT NULL, CHECK(C_GAME_SERVICE_NAME)  |

#### Reviews
Stores user reviews for games.

| Column         | Type                | Description                                      | Constraints                              |
|----------------|---------------------|--------------------------------------------------|------------------------------------------|
| reviewId       | UNIQUEIDENTIFIER    | Unique identifier for the review.                | PRIMARY KEY, DEFAULT NEWID()            |
| content        | NVARCHAR(MAX)       | Review content.                                 | NOT NULL                                |
| rating         | DECIMAL(4,2)        | Rating score (1.00-10.00).                      | NOT NULL, CHECK(C_REVIEW_RATING)        |
| dateCreated    | DATETIME            | Date and time the review was created.           | DEFAULT GETDATE()                      |

#### Comments
Stores comments on reviews or other entities.

| Column         | Type                | Description                                      | Constraints                              |
|----------------|---------------------|--------------------------------------------------|------------------------------------------|
| commentId      | UNIQUEIDENTIFIER    | Unique identifier for the comment.               | PRIMARY KEY, DEFAULT NEWID()            |
| content        | NVARCHAR(MAX)       | Comment content.                                | NOT NULL                                |
| created_at     | DATETIME            | Date and time the comment was created.          | DEFAULT GETDATE()                      |

#### Rates
Stores rating scores for games or reviews.

| Column         | Type                | Description                                      | Constraints                              |
|----------------|---------------------|--------------------------------------------------|------------------------------------------|
| rateId         | UNIQUEIDENTIFIER    | Unique identifier for the rate.                  | PRIMARY KEY, DEFAULT NEWID()            |
| rateValue      | INT                 | Rating value (1-10).                            | NOT NULL, CHECK(C_RATE_VALUE)           |

#### Lists
Stores user-created lists for organizing games.

| Column         | Type                | Description                                      | Constraints                              |
|----------------|---------------------|--------------------------------------------------|------------------------------------------|
| listId         | UNIQUEIDENTIFIER    | Unique identifier for the list.                  | PRIMARY KEY, DEFAULT NEWID()            |
| _name          | NVARCHAR(100)       | List name (1-100 characters).                   | NOT NULL, CHECK(C_LIST_NAME)            |
| descriptions   | NVARCHAR(MAX)       | Optional description of the list.               | NULL                                    |
| created_at     | DATETIME            | Date and time the list was created.             | DEFAULT GETDATE()                      |

#### List_items
Stores individual items within lists.

| Column         | Type                | Description                                      | Constraints                              |
|----------------|---------------------|--------------------------------------------------|------------------------------------------|
| listItemId     | UNIQUEIDENTIFIER    | Unique identifier for the list item.             | PRIMARY KEY, DEFAULT NEWID()            |
| title          | NVARCHAR(100)       | Item title (alphanumeric with ._-).             | NOT NULL, CHECK(C_LIST_ITEM_TITLE)      |

#### Activities
Stores user activities (e.g., actions performed in the system).

| Column         | Type                | Description                                      | Constraints                              |
|----------------|---------------------|--------------------------------------------------|------------------------------------------|
| activityId     | UNIQUEIDENTIFIER    | Unique identifier for the activity.              | PRIMARY KEY, DEFAULT NEWID()            |
| content        | NVARCHAR(MAX)       | Activity description (1-1000 characters).       | NOT NULL, CHECK(C_ACTIVITY_CONTENT)     |
| dateDo         | DATETIME            | Date and time the activity was performed.       | DEFAULT GETDATE()                      |

#### Diaries
Stores user diaries for logging game-related activities.

| Column         | Type                | Description                                      | Constraints                              |
|----------------|---------------------|--------------------------------------------------|------------------------------------------|
| diaryId        | UNIQUEIDENTIFIER    | Unique identifier for the diary entry.           | PRIMARY KEY, DEFAULT NEWID()            |
| dateLogged     | DATETIME            | Date and time the diary entry was logged.       | DEFAULT GETDATE(), CHECK(C_DIARY_DATE) |

#### Reactions
Stores user reactions (e.g., like, dislike) to reviews or comments.

| Column         | Type                | Description                                      | Constraints                              |
|----------------|---------------------|--------------------------------------------------|------------------------------------------|
| reactionId     | UNIQUEIDENTIFIER    | Unique identifier for the reaction.              | PRIMARY KEY, DEFAULT NEWID()            |
| reactionType   | INT                 | Type of reaction (0: Like, 1: Dislike, 2: Love, 3: Angry). | NOT NULL, CHECK(C_REACTION_TYPE) |
| dateDo         | DATETIME            | Date and time the reaction was performed.       | DEFAULT GETDATE()                      |

### Relationship Tables
The following tables manage many-to-many relationships between entities:

- **User_Diary**: Links users to diaries.
- **User_List**: Links users to lists.
- **User_User**: Represents follow relationships between users.
- **User_Activity**: Links users to activities.
- **Review_User**: Links reviews to their authors.
- **Review_Rate**: Links reviews to ratings.
- **Review_Reaction**: Links reviews to reactions.
- **Game_Review**: Links games to reviews.
- **Reaction_User**: Links reactions to their authors.
- **Rate_User**: Links ratings to their authors.
- **Rate_Game**: Links ratings to target games.
- **List_ListItem**: Links lists to their items.
- **ListItem_Game**: Links list items to target games.
- **Comment_User**: Links comments to their authors.
- **Comment_Reaction**: Links comments to reactions.
- **Comment_Review**: Links comments to target reviews.

### Constraints
- **Primary Keys**: All tables use `UNIQUEIDENTIFIER` with `NEWID()` for unique identification.
- **Foreign Keys**: Ensure referential integrity in relationship tables.
- **CHECK Constraints**:
  - Username, game title, genre, and list item title: Alphanumeric with `._-`.
  - Email: Basic format validation (`%_@__%.__%`).
  - Rating (Reviews, Rates): Between 1 and 10.
  - Reaction type: 0 (Like), 1 (Dislike), 2 (Love), 3 (Angry).
  - List name: 1-100 characters.
  - Activity content: 1-1000 characters.
  - Diary date: Not in the future.

## Usage Guidelines
- **Data Integrity**: Use stored procedures (to be implemented) for CRUD operations to enforce validation and consistency.
- **Indexes**: Consider adding non-clustered indexes on frequently queried columns (e.g., `username`, `email`, `gameId`) for performance.
- **Triggers**: Implement triggers to maintain `avgRating` in the `Games` table based on `Rates` or `Reviews`.
- **Security**: Add password salting to enhance security for `password_hash` in `Users`.

## Future Improvements
- Implement stored procedures and functions for CRUD operations.
- Add triggers to update `avgRating` automatically.
- Enhance email validation with a more robust pattern.
- Add indexes for performance optimization.
- Document stored procedures and functions in separate Markdown files.