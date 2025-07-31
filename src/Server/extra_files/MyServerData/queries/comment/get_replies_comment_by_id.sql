SELECT c.*, u.username
FROM comments c
JOIN users u ON c.user_id = u.user_id
WHERE c.parent_comment_id = @CommentId
ORDER BY c.created_at ASC;
