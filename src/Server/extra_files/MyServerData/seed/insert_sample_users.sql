INSERT INTO users (user_id, username, email, password_hash, avatar, is_logged_in, created_at, updated_at)
VALUES 
('u001', 'admin', 'admin@example.com', 'hashed_pass1', 'https://example.com/avatar1.jpg', 0, GETDATE(), GETDATE()),
('u002', 'player1', 'player1@example.com', 'hashed_pass2', 'https://example.com/avatar2.jpg', 0, GETDATE(), GETDATE());
