SELECT COUNT(*) AS total_reviews
FROM reviews
WHERE game_id = @GameId;
