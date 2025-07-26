DELETE FROM reviews
WHERE review_id = @ReviewId AND user_id = @UserId;
