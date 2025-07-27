SELECT *
FROM reviews
WHERE game_id = @GameId
ORDER BY date_created DESC;
