CREATE DATABASE KontrollerDB;
GO

USE KontrollerDB;
GO

-- Users table
CREATE TABLE users (
    user_id VARCHAR(50) PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255),
    password_hash VARCHAR(255) NOT NULL,
    avatar VARCHAR(500),
    is_logged_in BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);
GO

-- Games table
CREATE TABLE games (
    game_id VARCHAR(50) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    genre VARCHAR(100),
    poster VARCHAR(500),
    backdrop VARCHAR(500),
    details NVARCHAR(MAX),
    services NVARCHAR(MAX),
    avg_rating DECIMAL(3,2) DEFAULT 0.00,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);
GO

-- Reviews table
CREATE TABLE reviews (
    review_id VARCHAR(50) PRIMARY KEY,
    game_id VARCHAR(50) NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    rating DECIMAL(2,1) CHECK (rating >= 0 AND rating <= 10),
    date_created DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Review_Game FOREIGN KEY (game_id) REFERENCES games(game_id),
    CONSTRAINT FK_Review_User FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT UQ_Review_User_Game UNIQUE (user_id, game_id)
);
GO

-- Comments table
CREATE TABLE comments (
    comment_id VARCHAR(50) PRIMARY KEY,
    review_id VARCHAR(50) NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    content TEXT NOT NULL,
    parent_comment_id VARCHAR(50) NULL,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (review_id) REFERENCES reviews(review_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (parent_comment_id) REFERENCES comments(comment_id)
);
GO

-- Rates table
CREATE TABLE rates (
    rate_id VARCHAR(50) PRIMARY KEY,
    game_id VARCHAR(50) NOT NULL,
    user_id VARCHAR(50) NOT NULL,
    rating DECIMAL(2,1) CHECK (rating >= 0 AND rating <= 10),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT UQ_Rate_User_Game UNIQUE (user_id, game_id)
);
GO

-- Lists table
CREATE TABLE lists (
    list_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    is_public BIT DEFAULT 1,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
GO

-- List Items
CREATE TABLE list_items (
    list_item_id VARCHAR(50) PRIMARY KEY,
    list_id VARCHAR(50) NOT NULL,
    game_id VARCHAR(50) NOT NULL,
    added_at DATETIME DEFAULT GETDATE(),
    notes TEXT,
    FOREIGN KEY (list_id) REFERENCES lists(list_id),
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    CONSTRAINT UQ_List_Game UNIQUE (list_id, game_id)
);
GO

-- Play Later List
CREATE TABLE play_later_list (
    play_later_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    game_id VARCHAR(50) NOT NULL,
    added_at DATETIME DEFAULT GETDATE(),
    priority INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (game_id) REFERENCES games(game_id),
    CONSTRAINT UQ_PlayLater_User_Game UNIQUE (user_id, game_id)
);
GO

-- Activities table (activity_type and target_type as VARCHARs)
CREATE TABLE activities (
    activity_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    activity_type VARCHAR(50) NOT NULL, -- review, rate, comment, etc.
    target_id VARCHAR(50),
    target_type VARCHAR(50),           -- game, comment, review, etc.
    content TEXT,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
GO

-- Diaries table
CREATE TABLE diaries (
    diary_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    game_id VARCHAR(50),
    is_public BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (game_id) REFERENCES games(game_id)
);
GO

-- User Follow Table
CREATE TABLE user_follows (
    follow_id VARCHAR(50) PRIMARY KEY,
    follower_id VARCHAR(50) NOT NULL,
    following_id VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (follower_id) REFERENCES users(user_id),
    FOREIGN KEY (following_id) REFERENCES users(user_id),
    CONSTRAINT UQ_Follow UNIQUE (follower_id, following_id),
    CHECK (follower_id != following_id)
);
GO

-- User Block Table
CREATE TABLE user_blocks (
    block_id VARCHAR(50) PRIMARY KEY,
    blocker_id VARCHAR(50) NOT NULL,
    blocked_id VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (blocker_id) REFERENCES users(user_id),
    FOREIGN KEY (blocked_id) REFERENCES users(user_id),
    CONSTRAINT UQ_Block UNIQUE (blocker_id, blocked_id),
    CHECK (blocker_id != blocked_id)
);
GO

-- Reactions table
CREATE TABLE reactions (
    reaction_id VARCHAR(50) PRIMARY KEY,
    user_id VARCHAR(50) NOT NULL,
    target_id VARCHAR(50) NOT NULL,
    target_type VARCHAR(50) NOT NULL,
    reaction_type VARCHAR(50) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    CONSTRAINT UQ_Reaction UNIQUE (user_id, target_id, target_type)
);
GO
