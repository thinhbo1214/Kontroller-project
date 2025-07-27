SELECT *
FROM rates
WHERE user_id = @UserId AND game_id = @GameId;
