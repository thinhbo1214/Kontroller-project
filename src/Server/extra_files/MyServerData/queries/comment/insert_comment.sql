INSERT INTO comments (
    comment_id,
    review_id,
    user_id,
    content,
    parent_comment_id,
    created_at
)
VALUES (
    @CommentId,
    @ReviewId,
    @UserId,
    @Content,
    @ParentCommentId,
    CURRENT_TIMESTAMP
);
