DELETE FROM comments
WHERE comment_id = @CommentId
  AND user_id = @UserId;
