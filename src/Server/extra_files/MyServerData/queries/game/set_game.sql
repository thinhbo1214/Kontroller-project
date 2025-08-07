F EXISTS (SELECT 1 FROM games WHERE game_id = @GameId)
BEGIN
    -- Nếu tồn tại: Cập nhật các trường có giá trị mới
    UPDATE games
    SET 
        title = COALESCE(@Title, title),
        description = COALESCE(@Description, description),
        genre = COALESCE(@Genre, genre),
        poster = COALESCE(@Poster, poster),
        backdrop = COALESCE(@Backdrop, backdrop),
        details = COALESCE(@Details, details),
        services = COALESCE(@Services, services),
        avg_rating = COALESCE(@AvgRating, avg_rating),
        updated_at = GETDATE()
    WHERE game_id = @GameId;
END
ELSE
BEGIN
    -- Nếu chưa tồn tại: Thêm mới
    INSERT INTO games (
        game_id,
        title,
        description,
        genre,
        poster,
        backdrop,
        details,
        services,
        avg_rating,
        created_at,
        updated_at
    )
    VALUES (
        @GameId,
        @Title,
        @Description,
        @Genre,
        @Poster,
        @Backdrop,
        @Details,
        @Services,
        ISNULL(@AvgRating, 0.00),
        ISNULL(@CreatedAt, GETDATE()),
        GETDATE()
    );
END
