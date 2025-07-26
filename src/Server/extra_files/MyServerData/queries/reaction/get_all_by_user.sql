SELECT *
FROM reactions
WHERE user_id = @UserId
ORDER BY created_at DESC;
