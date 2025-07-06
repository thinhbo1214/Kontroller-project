CREATE DATABASE KontrollerDB
GO

USE KontrollerDB
GO

-- Account Table
CREATE TABLE Account (
    userID INT PRIMARY KEY,
    userName VARCHAR(50),
    password VARCHAR(100),
    email VARCHAR(100),
    stat VARCHAR(20),
    player_list TEXT
)
GO

-- Game Table
CREATE TABLE Game (
    gameID INT PRIMARY KEY,
    title VARCHAR(100),
    description TEXT,
    genre VARCHAR(50)
)
GO

-- Review Table
CREATE TABLE Review (
    reviewID INT PRIMARY KEY,
    content TEXT,
    reviewDate DATE,
    userID INT,
    FOREIGN KEY (userID) REFERENCES Account(userID)
)
GO

-- Comment Table
CREATE TABLE Comment (
    commentID INT PRIMARY KEY,
    content TEXT,
    commentDate DATE,
    userID INT,
    reviewID INT,
    FOREIGN KEY (userID) REFERENCES Account(userID),
    FOREIGN KEY (reviewID) REFERENCES Review(reviewID)
)
GO
-- Rate Table
CREATE TABLE Rate (
    rateID INT PRIMARY KEY,
    value INT CHECK (Value BETWEEN 1 AND 5),
    userID INT,
    reviewID INT,
    gameID INT,
    FOREIGN KEY (userID) REFERENCES Account(userID),
    FOREIGN KEY (reviewID) REFERENCES Review(reviewID),
    FOREIGN KEY (gameID) REFERENCES Game(gameID)
)
GO

-- Like Table
CREATE TABLE Likes (
    userID INT,
    targetType VARCHAR(20),
    likedDate DATE,
    reviewID INT,
    commentID INT,
    PRIMARY KEY (userID, reviewID, commentID),
    FOREIGN KEY (userID) REFERENCES Account(userID),
    FOREIGN KEY (reviewID) REFERENCES Review(reviewID),
    FOREIGN KEY (commentID) REFERENCES Comment(commentID)
)
GO

-- Follow Table
CREATE TABLE Follow (
    followerID INT,
    followedID INT,
    followDate DATE,
    PRIMARY KEY (followerID, followedID),
    FOREIGN KEY (followerID) REFERENCES Account(userID),
    FOREIGN KEY (followedID) REFERENCES Account(userID)
)
GO

-- Block Table
CREATE TABLE Block (
    blockerID INT,
    blockedID INT,
    blockedDate DATE,
    PRIMARY KEY (blockerID, blockedID),
    FOREIGN KEY (blockerID) REFERENCES Account(userID),
    FOREIGN KEY (blockedID) REFERENCES Account(userID)
)
