IF EXISTS (SELECT 1 FROM rates WHERE rate_id = @RateId)
BEGIN
    -- Nếu tồn tại: Cập nhật các trường có giá trị mới
    UPDATE rates
    SET 
        game_id = COALESCE(@GameId, game_id),
        user_id = COALESCE(@UserId, user_id),
        rating = COALESCE(@Rating, rating),
        updated_at = GETDATE()
    WHERE rate_id = @RateId;
END
ELSE
BEGIN
    -- Nếu chưa tồn tại: Thêm mới
    INSERT INTO rates (
        rate_id,
        game_id,
        user_id,
        rating,
        created_at,
        updated_at
    )
    VALUES (
        @RateId,
        @GameId,
        @UserId,
        @Rating,
        ISNULL(@CreatedAt, GETDATE()),
        GETDATE()
    );
END
