SELECT COUNT(*) AS total_entries
FROM diaries
WHERE user_id = @UserId;
