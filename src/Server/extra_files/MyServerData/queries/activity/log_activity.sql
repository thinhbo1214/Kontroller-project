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
    CURRENT_TIMESTAMP
);
