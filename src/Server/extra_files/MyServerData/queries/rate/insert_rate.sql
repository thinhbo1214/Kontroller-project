INSERT INTO Rate (rateID, value, userID, reviewID, gameID) VALUES (?, ?, ?, ?, ?)INSERT INTO rates (
    rate_id,
    user_id,
    game_id,
    rating,
    created_at,
    updated_at
)
VALUES (
    @RateId,
    @UserId,
    @GameId,
    @Rating,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);
