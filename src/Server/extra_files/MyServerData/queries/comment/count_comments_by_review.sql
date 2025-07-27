SELECT COUNT(*) AS comment_count
FROM comments
WHERE review_id = @ReviewId;
