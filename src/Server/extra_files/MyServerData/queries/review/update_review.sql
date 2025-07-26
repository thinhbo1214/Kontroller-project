UPDATE reviews
SET content = @Content,
    rating = @Rating,
    updated_at = CURRENT_TIMESTAMP
WHERE review_id = @ReviewId AND user_id = @UserId;
