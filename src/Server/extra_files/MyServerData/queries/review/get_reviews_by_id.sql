SELECT *
FROM reviews
WHERE user_id = @UserId
ORDER BY date_created DESC;
