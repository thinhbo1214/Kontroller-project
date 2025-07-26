UPDATE reactions
SET reaction_type = @ReactionType,
    created_at = CURRENT_TIMESTAMP
WHERE user_id = @UserId AND target_id = @TargetId AND target_type = @TargetType;
