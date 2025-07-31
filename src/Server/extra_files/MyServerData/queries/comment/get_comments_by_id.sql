SELECT c.*, u.username
FROM comments c
JOIN users u ON c.user_id = u.user_id
WHERE c.review_id = @ReviewId
  AND c.parent_comment_id IS NULL
ORDER BY c.created_at ASC;
