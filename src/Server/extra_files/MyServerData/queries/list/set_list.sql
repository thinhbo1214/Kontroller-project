IF EXISTS (SELECT 1 FROM lists WHERE list_id = @ListId)
BEGIN
    -- Nếu tồn tại: Cập nhật các trường có giá trị mới
    UPDATE lists
    SET 
        user_id = COALESCE(@UserId, user_id),
        title = COALESCE(@Title, title),
        description = COALESCE(@Description, description),
        is_public = COALESCE(@IsPublic, is_public),
        updated_at = GETDATE()
    WHERE list_id = @ListId;
END
ELSE
BEGIN
    -- Nếu chưa tồn tại: Thêm mới
    INSERT INTO lists (
        list_id,
        user_id,
        title,
        description,
        is_public,
        created_at,
        updated_at
    )
    VALUES (
        @ListId,
        @UserId,
        @Title,
        @Description,
        ISNULL(@IsPublic, 1), -- Mặc định là công khai nếu không truyền
        ISNULL(@CreatedAt, GETDATE()),
        GETDATE()
    );
END
