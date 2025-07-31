IF EXISTS (SELECT 1 FROM activities WHERE activity_id = @ActivityId)
BEGIN
    -- Nếu tồn tại: Cập nhật chỉ các trường có giá trị mới
    UPDATE activities
    SET 
        user_id = COALESCE(@UserId, user_id),
        activity_type = COALESCE(@ActivityType, activity_type),
        target_id = COALESCE(@TargetId, target_id),
        target_type = COALESCE(@TargetType, target_type),
        content = COALESCE(@Content, content),
        created_at = COALESCE(@CreatedAt, created_at) -- nếu không truyền, giữ nguyên
    WHERE activity_id = @ActivityId;
END
ELSE
BEGIN
    -- Nếu chưa tồn tại: Thêm mới
    INSERT INTO activities (
        activity_id,
        user_id,
        activity_type,
        target_id,
        target_type,
        content,
        created_at
    )
    VALUES (
        @ActivityId,
        @UserId,
        @ActivityType,
        @TargetId,
        @TargetType,
        @Content,
        ISNULL(@CreatedAt, GETDATE())
    );
END
