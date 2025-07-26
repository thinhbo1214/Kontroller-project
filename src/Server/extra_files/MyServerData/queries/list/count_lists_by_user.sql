SELECT COUNT(*) AS total_lists
FROM lists
WHERE user_id = @UserId;
