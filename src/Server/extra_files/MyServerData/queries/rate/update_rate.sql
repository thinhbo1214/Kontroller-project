UPDATE rates
SET
    rating = @Rating,
    updated_at = CURRENT_TIMESTAMP
WHERE user_id = @UserId AND game_id = @GameId;
