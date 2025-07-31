DELETE FROM diaries
WHERE diary_id = @DiaryId
  AND user_id = @UserId;
