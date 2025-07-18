INSERT INTO Account (userID, userName, password, email, stat, player_list)
    VALUES (1, 'alice', 'hashed_pass_1', 'alice@example.com', 'active', '["game1", "game2"]'),
           (2, 'bob', 'hashed_pass_2', 'bob@example.com', 'active', '["game3"]'),
           (3, 'charlie', 'hashed_pass_3', 'charlie@example.com', 'inactive', '[]');
