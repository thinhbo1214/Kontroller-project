UPDATE diaries
SET
    title = @Title,
    content = @Content,
    game_id = @GameId,
    is_public = @IsPublic,
    updated_at = CURRENT_TIMESTAMP
WHERE diary_id = @DiaryId
  AND user_id = @UserId;
