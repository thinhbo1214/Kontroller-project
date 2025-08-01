CREATE DATABASE KontrollerDB;
GO

USE KontrollerDB;
GO

-- Users table
CREATE TABLE Users (
    userId UNIQUEIDENTIFIER DEFAULT NEWID(),
    username VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARBINARY(128) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    avatar VARCHAR(255),
    isLoggedIn BIT DEFAULT 0,
    PRIMARY KEY (userId)
);

GO

-- Games table
CREATE TABLE Games (
    gameId UNIQUEIDENTIFIER DEFAULT NEWID(),
    title NVARCHAR(100) NOT NULL,
    descriptions NVARCHAR(MAX) NOT NULL,
    genre NVARCHAR(100) NOT NULL,
    avgRating DECIMAL(4,2) DEFAULT 0.00,
    poster VARCHAR(255),
    backdrop VARCHAR(255),
    details NVARCHAR(MAX) NOT NULL,
    PRIMARY KEY (gameId)
);
GO

CREATE TABLE Game_Service (
    gameId UNIQUEIDENTIFIER NOT NULL,
    serviceName NVARCHAR(30) NOT NULL,
    PRIMARY KEY (gameId, serviceName),
    FOREIGN KEY (gameId) REFERENCES Games(gameId)
);
GO 

-- Reviews table
CREATE TABLE Reviews (
    reviewId UNIQUEIDENTIFIER DEFAULT NEWID(),
    content NVARCHAR(MAX) NOT NULL,
    rating DECIMAL(4,2),
    dateCreated DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (reviewId)
);
GO

-- Comments table
CREATE TABLE Comments (
    commentId UNIQUEIDENTIFIER DEFAULT NEWID(),
    content NVARCHAR(MAX) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (commentId)
);
GO

-- Rates table
CREATE TABLE Rates (
    rateId UNIQUEIDENTIFIER DEFAULT NEWID(),
    rateValue INT NOT NULL,
    PRIMARY KEY (rateId)
);
GO

-- Lists table
CREATE TABLE Lists (
    listId UNIQUEIDENTIFIER DEFAULT NEWID(),
    _name NVARCHAR(100) NOT NULL,
    descriptions NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (listId)
);
GO

-- List Items
CREATE TABLE List_items (
    listItemId UNIQUEIDENTIFIER DEFAULT NEWID(),
    title NVARCHAR(100) NOT NULL,
    PRIMARY KEY (listItemId)
);
GO


-- Activity table (activity_type and target_type as VARCHARs)
CREATE TABLE Activities (
    activityId UNIQUEIDENTIFIER DEFAULT NEWID(),
    content NVARCHAR(MAX) NOT NULL,
    dateDo DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (activityId)
);
GO

-- Diaries table
CREATE TABLE Diaries (
    diaryId UNIQUEIDENTIFIER DEFAULT NEWID(),
    dateLogged DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (diaryId)
);
GO

-- Reactions table
CREATE TABLE Reactions (
    reactionId UNIQUEIDENTIFIER DEFAULT NEWID(),
    reactionType INT NOT NULL,
    dateDo DATETIME DEFAULT GETDATE(),
    PRIMARY KEY (reactionId)
);
GO

-- extra tables for relationships
CREATE TABLE User_Diary (
    userId UNIQUEIDENTIFIER NOT NULL,
    diaryId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (userId, diaryId),
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (diaryId) REFERENCES Diaries(diaryId)
);
GO

CREATE TABLE User_List (
    userId UNIQUEIDENTIFIER NOT NULL,
    listId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (userId, listId),
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (listId) REFERENCES Lists(listId)
);
GO

CREATE TABLE User_User (
    userFollower UNIQUEIDENTIFIER NOT NULL,
    userFollowing UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (userFollower, userFollowing),
    FOREIGN KEY (userFollower) REFERENCES Users(userId),
    FOREIGN KEY (userFollowing) REFERENCES Users(userId)
);
GO

CREATE TABLE User_Activity (
    userId UNIQUEIDENTIFIER NOT NULL,
    activityId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (userId, activityId),
    FOREIGN KEY (userId) REFERENCES Users(userId),
    FOREIGN KEY (activityId) REFERENCES Activities(activityId)
);
GO

CREATE TABLE Review_User (
    author UNIQUEIDENTIFIER NOT NULL,
    reviewId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (author, reviewId),
    FOREIGN KEY (author) REFERENCES Users(userId),
    FOREIGN KEY (reviewId) REFERENCES Reviews(reviewId)
);
GO

CREATE TABLE Review_Rate (
    rateId UNIQUEIDENTIFIER NOT NULL,
    reviewId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (rateId, reviewId),
    FOREIGN KEY (rateId) REFERENCES Rates(rateId),
    FOREIGN KEY (reviewId) REFERENCES Reviews(reviewId)
);
GO

CREATE TABLE Review_Reaction (
    reactionId UNIQUEIDENTIFIER NOT NULL,
    reviewId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (reactionId, reviewId),
    FOREIGN KEY (reactionId) REFERENCES Reactions(reactionId),
    FOREIGN KEY (reviewId) REFERENCES Reviews(reviewId)
);
GO

CREATE TABLE Game_Review (
    gameId UNIQUEIDENTIFIER NOT NULL,
    reviewId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (gameId, reviewId),
    FOREIGN KEY (gameId) REFERENCES Games(gameId),
    FOREIGN KEY (reviewId) REFERENCES Reviews(reviewId)
);
GO

CREATE TABLE Reaction_User (
    reactionId UNIQUEIDENTIFIER NOT NULL,
    author UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (reactionId, author),
    FOREIGN KEY (reactionId) REFERENCES Reactions(reactionId),
    FOREIGN KEY (author) REFERENCES Users(userId)
);
GO

CREATE TABLE Rate_User (
    rateId UNIQUEIDENTIFIER NOT NULL,
    rater UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (rateId, rater),
    FOREIGN KEY (rateId) REFERENCES Rates(rateId),
    FOREIGN KEY (rater) REFERENCES Users(userId)
);
GO

CREATE TABLE Rate_Game (
    rateId UNIQUEIDENTIFIER NOT NULL,
    targetGame UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (rateId, targetGame),
    FOREIGN KEY (rateId) REFERENCES Rates(rateId),
    FOREIGN KEY (targetGame) REFERENCES Games(gameId)
);
GO

CREATE TABLE List_ListItem (
    listId UNIQUEIDENTIFIER NOT NULL,
    listItemId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (listId, listItemId),
    FOREIGN KEY (listId) REFERENCES Lists(listId),
    FOREIGN KEY (listItemId) REFERENCES List_items(listItemId)
);
GO

CREATE TABLE ListItem_Game (
    listItemId UNIQUEIDENTIFIER NOT NULL,
    targetGame UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (listItemId, targetGame),
    FOREIGN KEY (listItemId) REFERENCES List_items(listItemId),
    FOREIGN KEY (targetGame) REFERENCES Games(gameId)
);
GO 

CREATE TABLE Comment_User (
    commentId UNIQUEIDENTIFIER NOT NULL,
    author UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (commentId, author),
    FOREIGN KEY (commentId) REFERENCES Comments(commentId),
    FOREIGN KEY (author) REFERENCES Users(userId)
);
GO 

CREATE TABLE Comment_Reaction (
    commentId UNIQUEIDENTIFIER  NOT NULL,
    reactionId UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (commentId, reactionId),
    FOREIGN KEY (commentId) REFERENCES Comments(commentId),
    FOREIGN KEY (reactionId) REFERENCES Reactions(reactionId)
);
GO 

ALTER TABLE Users
ADD CONSTRAINT C_USER_EMAIL
CHECK (email LIKE '%_@__%.__%');

ALTER TABLE Users
ADD CONSTRAINT C_USER_USERNAME
CHECK (username NOT LIKE '%[^a-zA-Z0-9._-]%');

ALTER TABLE Games
ADD CONSTRAINT C_GAME_TITLE
CHECK (title NOT LIKE '%[^a-zA-Z0-9._-]%');

ALTER TABLE Games
ADD CONSTRAINT C_GAME_GENRE
CHECK (genre NOT LIKE '%[^a-zA-Z0-9._-]%');

ALTER TABLE Game_Service
ADD CONSTRAINT C_GAME_SERVICE_NAME
CHECK (serviceName NOT LIKE '%[^a-zA-Z0-9._-]%');

ALTER TABLE Reviews
ADD CONSTRAINT C_REVIEW_RATING
CHECK (rating BETWEEN 1 AND 10);

ALTER TABLE Rates
ADD CONSTRAINT C_RATE_VALUE
CHECK (rateValue BETWEEN 1 AND 10);

ALTER TABLE Reactions
ADD CONSTRAINT C_REACTION_TYPE
CHECK (reactionType IN (0, 1, 2, 3)); -- 0: Like, 1: Dislike, 2: Love, 3: Angry

ALTER TABLE Lists
ADD CONSTRAINT C_LIST_NAME
CHECK (LEN(_name) > 0 AND LEN(_name) <= 100);

ALTER TABLE List_items
ADD CONSTRAINT C_LIST_ITEM_TITLE
CHECK (title NOT LIKE '%[^a-zA-Z0-9._-]%');

ALTER TABLE Activities
ADD CONSTRAINT C_ACTIVITY_CONTENT
CHECK (LEN(content) > 0 AND LEN(content) <= 1000);

ALTER TABLE Diaries
ADD CONSTRAINT C_DIARY_DATE
CHECK (dateLogged <= GETDATE());



