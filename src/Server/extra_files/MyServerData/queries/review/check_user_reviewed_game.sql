SELECT COUNT(*) AS reviewed
FROM reviews
WHERE user_id = @UserId AND game_id = @GameId;
