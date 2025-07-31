IF EXISTS (SELECT 1 FROM diaries WHERE diary_id = @DiaryId)
BEGIN
    -- Nếu tồn tại: Cập nhật các trường có giá trị mới
    UPDATE diaries
    SET 
        user_id = COALESCE(@UserId, user_id),
        title = COALESCE(@Title, title),
        content = COALESCE(@Content, content),
        game_id = COALESCE(@GameId, game_id),
        is_public = COALESCE(@IsPublic, is_public),
        updated_at = GETDATE()
    WHERE diary_id = @DiaryId;
END
ELSE
BEGIN
    -- Nếu chưa tồn tại: Thêm mới
    INSERT INTO diaries (
        diary_id,
        user_id,
        title,
        content,
        game_id,
        is_public,
        created_at,
        updated_at
    )
    VALUES (
        @DiaryId,
        @UserId,
        @Title,
        @Content,
        @GameId,
        ISNULL(@IsPublic, 0),
        ISNULL(@CreatedAt, GETDATE()),
        GETDATE()
    );
END
