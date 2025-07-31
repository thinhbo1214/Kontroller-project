SELECT *
FROM activities
WHERE user_id = @UserId
ORDER BY created_at DESC;
