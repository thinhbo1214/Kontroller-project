SELECT *
FROM reactions
WHERE target_id = @TargetId AND target_type = @TargetType;
