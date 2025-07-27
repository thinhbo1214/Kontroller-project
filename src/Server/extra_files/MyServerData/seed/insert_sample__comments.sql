INSERT INTO comments (comment_id, review_id, user_id, content, parent_comment_id, created_at, updated_at)
VALUES 
('c001', 'r001', 'u002', 'Totally agree!', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('c002', 'r002', 'u001', 'Thanks for the review.', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
