IF EXISTS (SELECT 1 FROM reactions WHERE reaction_id = @ReactionId)
BEGIN
    -- Nếu tồn tại: Cập nhật các trường có giá trị mới
    UPDATE reactions
    SET 
        user_id = COALESCE(@UserId, user_id),
        target_id = COALESCE(@TargetId, target_id),
        target_type = COALESCE(@TargetType, target_type),
        reaction_type = COALESCE(@ReactionType, reaction_type),
        created_at = COALESCE(@CreatedAt, created_at)
    WHERE reaction_id = @ReactionId;
END
ELSE
BEGIN
    -- Nếu chưa tồn tại: Thêm mới
    INSERT INTO reactions (
        reaction_id,
        user_id,
        target_id,
        target_type,
        reaction_type,
        created_at
    )
    VALUES (
        @ReactionId,
        @UserId,
        @TargetId,
        @TargetType,
        @ReactionType,
        ISNULL(@CreatedAt, GETDATE())
    );
END
