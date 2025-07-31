SELECT *
FROM lists
WHERE user_id = @UserId
ORDER BY created_at DESC;
