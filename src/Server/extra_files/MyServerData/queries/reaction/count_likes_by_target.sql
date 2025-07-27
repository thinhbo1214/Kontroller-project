SELECT COUNT(*) AS like_count
FROM reactions
WHERE target_id = @TargetId
  AND target_type = @TargetType
  AND reaction_type = 'like';
