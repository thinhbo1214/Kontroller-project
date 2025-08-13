/*
    Database: KontrollerDB
    Description: Database for a game management system, storing information about users, games, reviews, comments, ratings, lists, activities, diaries, and their relationships.
*/
CREATE DATABASE KontrollerDB;
GO

USE KontrollerDB;
GO

/*
    Table: Users
    Description: Stores user information, including credentials and profile details.
    Columns:
        - userId: Unique identifier for the user.
        - username: Unique username (3-100 characters, alphanumeric with ._-).
        - password_hash: SHA2_256 hashed password.
        - email: Unique email address (valid format).
        - avatar: Optional URL to user avatar image.
        - isLoggedIn: Indicates if the user is currently logged in.
    Constraints:
        - PRIMARY KEY: userId
        - UNIQUE: username, email
        - CHECK: Valid email format, valid username characters
*/
CREATE TABLE [Users] (
    userId UNIQUEIDENTIFIER DEFAULT NEWID(),
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARBINARY(128) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    avatar VARCHAR(255) DEFAULT 'https://cdn2.fptshop.com.vn/small/avatar_trang_1_cd729c335b.jpg',
    isLoggedIn BIT DEFAULT 0,
    numberFollower INT DEFAULT 0,
    numberFollowing INT DEFAULT 0,
    numberList INT DEFAULT 0,
    PRIMARY KEY (userId)
);
GO

/*
    Table: Games
    Description: Stores game information, including title, description, and ratings.
    Columns:
        - gameId: Unique identifier for the game.
        - title: Game title (1-100 characters, alphanumeric with ._-).
        - descriptions: Detailed description of the game.
        - genre: Game genre (alphanumeric with ._-).
        - avgRating: Average rating (0.00-10.00).
        - poster: Optional URL to game poster image.
        - backdrop: Optional URL to game backdrop image.
        - details: Additional game details.
    Constraints:
        - PRIMARY KEY: gameId
        - CHECK: Valid title and genre characters
*/
CREATE TABLE [Games] (
    gameId UNIQUEIDENTIFIER DEFAULT NEWID(),
    title NVARCHAR(100) NOT NULL,
    descriptions NVARCHAR(4000) NOT NULL,
    genre NVARCHAR(100) NOT NULL,
    avgRating DECIMAL(4,2) DEFAULT 0.00,
    poster VARCHAR(255),
    backdrop VARCHAR(255),
    details NVARCHAR(4000) NOT NULL,
    numberReview INT DEFAULT 0,
    PRIMARY KEY (gameId)
);
GO

/*
    Table: Game_Service
    Description: Stores services associated with games (e.g., platforms or stores).
    Columns:
        - gameId: Foreign key referencing Games.
        - serviceName: Name of the service (1-30 characters, alphanumeric with ._-).
    Constraints:
        - PRIMARY KEY: (gameId, serviceName)
        - FOREIGN KEY: gameId references Games(gameId)
        - CHECK: Valid serviceName characters
*/
CREATE TABLE [Game_Service] (
    gameId UNIQUEIDENTIFIER NOT NULL,
    serviceName NVARCHAR(30) NOT NULL,
    PRIMARY KEY (gameId, serviceName),
    FOREIGN KEY (gameId) REFERENCES Games(gameId)
);
GO 

/*
    Table: Reviews
    Description: Stores user reviews for games.
    Columns:
        - reviewId: Unique identifier for the review.
        - content: Review content.
        - rating: Rating score (1.00-10.00).
        - dateCreated: Date and time the review was created.
    Constraints:
        - PRIMARY KEY: reviewId
        - CHECK: Rating between 1 and 10
*/
CREATE TABLE [Reviews] (
    reviewId UNIQUEIDENTIFIER DEFAULT NEWID(),
    content NVARCHAR(MAX) NOT NULL,
    rating DECIMAL(4,2) NOT NULL DEFAULT 0,
    dateCreated DATETIME DEFAULT GETDATE(),
    numberReaction INT DEFAULT 0,
    numberComment INT DEFAULT 0,
    PRIMARY KEY (reviewId)
);
GO

/*
    Table: Comments
    Description: Stores comments on reviews or other entities.
    Columns:
        - commentId: Unique identifier for the comment.
        - content: Comment content.
        - created_at: Date and time the comment was created.
    Constraints:
        - PRIMARY KEY: commentId
*/
CREATE TABLE [Comments] (
    commentId UNIQUEIDENTIFIER DEFAULT NEWID(),
    content NVARCHAR(4000) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    numberReaction INT DEFAULT 0,
    PRIMARY KEY (commentId)
);
GO


/*
    Table: Lists
    Description: Stores user-created lists for organizing games.
    Columns:
        - listId: Unique identifier for the list.
        - _name: List name (1-100 characters).
        - descriptions: Optional description of the list.
        - created_at: Date and time the list was created.
    Constraints:
        - PRIMARY KEY: listId
        - CHECK: Valid name length
*/
CREATE TABLE [Lists] (
    listId UNIQUEIDENTIFIER DEFAULT NEWID(),
    title NVARCHAR(100) NOT NULL,
    descriptions NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    numberGame INT DEFAULT 0,
    PRIMARY KEY (listId)
);
GO

/*
    Table: Activities
    Description: Stores user activities (e.g., actions performed in the system).
    Columns:
        - activityId: Unique identifier for the activity.
        - content: Activity description (1-1000 characters).
        - dateDo: Date and time the activity was performed.
    Constraints:
        - PRIMARY KEY: activityId
        - CHECK: Valid content length
*/
CREATE TABLE [Activities] (
    activityId UNIQUEIDENTIFIER DEFAULT NEWID(),
    content NVARCHAR(4000) NOT NULL,
    dateDo DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (activityId)
);
GO

/*
    Table: Diaries
    Description: Stores user diaries for logging game-related activities.
    Columns:
        - diaryId: Unique identifier for the diary entry.
        - dateLogged: Date and time the diary entry was logged.
    Constraints:
        - PRIMARY KEY: diaryId
        - CHECK: dateLogged not in the future
*/
CREATE TABLE [Diaries] (
    diaryId UNIQUEIDENTIFIER DEFAULT NEWID(),
    dateLogged DATETIME DEFAULT GETDATE(),
    numberGameLogged INT DEFAULT 0,
    PRIMARY KEY (diaryId)
);
GO

/*
    Table: Reactions
    Description: Stores user reactions (e.g., like, dislike) to reviews or comments.
    Columns:
        - reactionId: Unique identifier for the reaction.
        - reactionType: Type of reaction (0: Like, 1: Dislike, 2: Love, 3: Angry).
        - dateDo: Date and time the reaction was performed.
    Constraints:
        - PRIMARY KEY: reactionId
        - CHECK: Valid reactionType (0-3)
*/
CREATE TABLE [Reactions] (
    reactionId UNIQUEIDENTIFIER DEFAULT NEWID(),
    reactionType INT NOT NULL,
    dateDo DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (reactionId)
);
GO

/*
    Table: User_Diary
    Description: Represents the many-to-many relationship between Users and Diaries.
    Columns:
        - userId: Foreign key referencing Users.
        - diaryId: Foreign key referencing Diaries.
    Constraints:
        - PRIMARY KEY: (userId, diaryId)
        - FOREIGN KEY: userId, diaryId
*/
CREATE TABLE [User_Diary] (
    userId UNIQUEIDENTIFIER NOT NULL,
    diaryId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (userId, diaryId),
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (diaryId) REFERENCES Diaries(diaryId)
);
GO

/*
    Table: User_List
    Description: Represents the many-to-many relationship between Users and Lists.
    Columns:
        - userId: Foreign key referencing Users.
        - listId: Foreign key referencing Lists.
    Constraints:
        - PRIMARY KEY: (userId, listId)
        - FOREIGN KEY: userId, listId
*/
CREATE TABLE [User_List] (
    userId UNIQUEIDENTIFIER NOT NULL,
    listId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (userId, listId),
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (listId) REFERENCES Lists(listId)
);
GO

/*
    Table: User_User
    Description: Represents follow relationships between users.
    Columns:
        - userFollower: Foreign key referencing the user who follows.
        - userFollowing: Foreign key referencing the user being followed.
    Constraints:
        - PRIMARY KEY: (userFollower, userFollowing)
        - FOREIGN KEY: userFollower, userFollowing
*/
CREATE TABLE [User_User] (
    userFollower UNIQUEIDENTIFIER NOT NULL,
    userFollowing UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (userFollower, userFollowing),
    FOREIGN KEY (userFollower) REFERENCES Users(userId),
    FOREIGN KEY (userFollowing) REFERENCES Users(userId)
);
GO

/*
    Table: User_Activity
    Description: Represents the many-to-many relationship between Users and Activities.
    Columns:
        - userId: Foreign key referencing Users.
        - activityId: Foreign key referencing Activities.
    Constraints:
        - PRIMARY KEY: (userId, activityId)
        - FOREIGN KEY: userId, activityId
*/
CREATE TABLE [User_Activity] (
    userId UNIQUEIDENTIFIER NOT NULL,
    activityId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (userId, activityId),
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (activityId) REFERENCES Activities(activityId)
);
GO

/*
    Table: Review_User
    Description: Links reviews to their authors.
    Columns:
        - author: Foreign key referencing Users.
        - reviewId: Foreign key referencing Reviews.
    Constraints:
        - PRIMARY KEY: (author, reviewId)
        - FOREIGN KEY: author, reviewId
*/
CREATE TABLE [Review_User] (
    author UNIQUEIDENTIFIER NOT NULL,
    reviewId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (author, reviewId),
    FOREIGN KEY (author) REFERENCES Users(userId),
    FOREIGN KEY (reviewId) REFERENCES Reviews(reviewId)
);
GO

/*
    Table: Review_Reaction
    Description: Links reviews to user reactions.
    Columns:
        - reactionId: Foreign key referencing Reactions.
        - reviewId: Foreign key referencing Reviews.
    Constraints:
        - PRIMARY KEY: (reactionId, reviewId)
        - FOREIGN KEY: reactionId, reviewId
*/
CREATE TABLE [Review_Reaction] (
    reactionId UNIQUEIDENTIFIER NOT NULL,
    reviewId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (reactionId, reviewId),
    FOREIGN KEY (reactionId) REFERENCES Reactions(reactionId),
    FOREIGN KEY (reviewId) REFERENCES Reviews(reviewId)
);
GO

/*
    Table: Game_Review
    Description: Links games to their reviews.
    Columns:
        - gameId: Foreign key referencing Games.
        - reviewId: Foreign key referencing Reviews.
    Constraints:
        - PRIMARY KEY: (gameId, reviewId)
        - FOREIGN KEY: gameId, reviewId
*/
CREATE TABLE [Game_Review] (
    gameId UNIQUEIDENTIFIER NOT NULL,
    reviewId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (gameId, reviewId),
    FOREIGN KEY (gameId) REFERENCES Games(gameId),
    FOREIGN KEY (reviewId) REFERENCES Reviews(reviewId)
);
GO

/*
    Table: Reaction_User
    Description: Links reactions to their authors.
    Columns:
        - reactionId: Foreign key referencing Reactions.
        - author: Foreign key referencing Users.
    Constraints:
        - PRIMARY KEY: (reactionId, author)
        - FOREIGN KEY: reactionId, author
*/
CREATE TABLE [Reaction_User] (
    reactionId UNIQUEIDENTIFIER NOT NULL,
    author UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (reactionId, author),
    FOREIGN KEY (reactionId) REFERENCES Reactions(reactionId),
    FOREIGN KEY (author) REFERENCES Users(userId)
);
GO


/*
    Table: List_Game
    Description: Represents the many-to-many relationship between Lists and Games.
    Columns:
        - listId: Foreign key referencing Lists.
        - targetGame: Foreign key referencing Games.
    Constraints:
        - PRIMARY KEY: (listId, targetGame)
        - FOREIGN KEY: listId references Lists(listId)
        - FOREIGN KEY: targetGame references Games(gameId)
*/ 
CREATE TABLE [List_Game] (
    listId UNIQUEIDENTIFIER NOT NULL,
    targetGame UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (listId, targetGame),
    FOREIGN KEY (listId) REFERENCES Lists(listId),
    FOREIGN KEY (targetGame) REFERENCES Games(gameId)
);
GO 

/*
    Table: Comment_User
    Description: Links comments to their authors.
    Columns:
        - commentId: Foreign key referencing Comments.
        - author: Foreign key referencing Users.
    Constraints:
        - PRIMARY KEY: (commentId, author)
        - FOREIGN KEY: commentId, author
*/
CREATE TABLE [Comment_User] (
    commentId UNIQUEIDENTIFIER NOT NULL,
    author UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (commentId, author),
    FOREIGN KEY (commentId) REFERENCES Comments(commentId),
    FOREIGN KEY (author) REFERENCES Users(userId)
);
GO 

/*
    Table: Comment_Reaction
    Description: Links comments to user reactions.
    Columns:
        - commentId: Foreign key referencing Comments.
        - reactionId: Foreign key referencing Reactions.
    Constraints:
        - PRIMARY KEY: (commentId, reactionId)
        - FOREIGN KEY: commentId, reactionId
*/
CREATE TABLE [Comment_Reaction] (
    commentId UNIQUEIDENTIFIER NOT NULL,
    reactionId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (commentId, reactionId),
    FOREIGN KEY (commentId) REFERENCES Comments(commentId),
    FOREIGN KEY (reactionId) REFERENCES Reactions(reactionId)
);
GO 

/*
    Table: Comment_Review
    Description: Links comments to their target reviews.
    Columns:
        - commentId: Foreign key referencing Comments.
        - reviewId: Foreign key referencing Reviews.
    Constraints:
        - PRIMARY KEY: (commentId, reviewId)
        - FOREIGN KEY: commentId, reviewId
*/
CREATE TABLE [Comment_Review] (
    commentId UNIQUEIDENTIFIER NOT NULL,
    reviewId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (commentId, reviewId),
    FOREIGN KEY (commentId) REFERENCES Comments(commentId),
    FOREIGN KEY (reviewId) REFERENCES Reviews(reviewId)
);
GO

ALTER TABLE [Users]
ADD CONSTRAINT C_USER_EMAIL
CHECK (email LIKE '%_@__%.__%');

ALTER TABLE [Users]
ADD CONSTRAINT C_USER_USERNAME
CHECK (username NOT LIKE '%[^a-zA-Z0-9._-]%');

ALTER TABLE [Reviews]
ADD CONSTRAINT C_REVIEW_RATING
CHECK (rating BETWEEN 0 AND 10);

ALTER TABLE [Reactions]
ADD CONSTRAINT C_REACTION_TYPE
CHECK (reactionType IN (0, 1, 2, 3)); -- 0: Like, 1: Dislike, 2: Love, 3: Angry

ALTER TABLE [Activities]
ADD CONSTRAINT C_ACTIVITY_CONTENT
CHECK (LEN(content) > 0 AND LEN(content) <= 4000);

ALTER TABLE [Diaries]
ADD CONSTRAINT C_DIARY_DATE
CHECK (dateLogged <= GETDATE());


CREATE TYPE IdList AS TABLE
(
    Id UNIQUEIDENTIFIER PRIMARY KEY
);