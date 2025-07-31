IF EXISTS (SELECT 1 FROM comments WHERE comment_id = @CommentId)
BEGIN
    -- Nếu tồn tại: Cập nhật chỉ các trường có giá trị mới
    UPDATE comments
    SET 
        review_id = COALESCE(@ReviewId, review_id),
        user_id = COALESCE(@UserId, user_id),
        content = COALESCE(@Content, content),
        parent_comment_id = COALESCE(@ParentCommentId, parent_comment_id),
        updated_at = GETDATE()
    WHERE comment_id = @CommentId;
END
ELSE
BEGIN
    -- Nếu chưa tồn tại: Thêm mới
    INSERT INTO comments (
        comment_id,
        review_id,
        user_id,
        content,
        parent_comment_id,
        created_at,
        updated_at
    )
    VALUES (
        @CommentId,
        @ReviewId,
        @UserId,
        @Content,
        @ParentCommentId,
        ISNULL(@CreatedAt, GETDATE()),
        GETDATE()
    );
END
