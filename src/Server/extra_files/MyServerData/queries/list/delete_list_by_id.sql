DELETE FROM lists
WHERE list_id = @ListId
  AND user_id = @UserId;
