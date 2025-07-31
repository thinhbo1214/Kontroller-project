DELETE FROM reactions
WHERE user_id = @UserId AND target_id = @TargetId AND target_type = @TargetType;
