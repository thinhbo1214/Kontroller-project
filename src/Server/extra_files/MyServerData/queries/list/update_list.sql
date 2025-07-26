UPDATE lists
SET
    title = @Title,
    description = @Description,
    is_public = @IsPublic,
    updated_at = CURRENT_TIMESTAMP
WHERE list_id = @ListId
  AND user_id = @UserId;
