IF EXISTS (SELECT 1 FROM reviews WHERE review_id = @ReviewId)
BEGIN
    -- Nếu tồn tại: Cập nhật các trường có giá trị mới
    UPDATE reviews
    SET 
        game_id = COALESCE(@GameId, game_id),
        user_id = COALESCE(@UserId, user_id),
        content = COALESCE(@Content, content),
        rating = COALESCE(@Rating, rating),
        updated_at = GETDATE()
    WHERE review_id = @ReviewId;
END
ELSE
BEGIN
    -- Nếu chưa tồn tại: Thêm mới
    INSERT INTO reviews (
        review_id,
        game_id,
        user_id,
        content,
        rating,
        date_created,
        updated_at
    )
    VALUES (
        @ReviewId,
        @GameId,
        @UserId,
        @Content,
        @Rating,
        ISNULL(@CreatedAt, GETDATE()),
        GETDATE()
    );
END
