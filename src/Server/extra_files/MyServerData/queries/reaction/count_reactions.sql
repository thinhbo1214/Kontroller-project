SELECT
  reaction_type,
  COUNT(*) AS total
FROM reactions
WHERE target_id = @TargetId AND target_type = @TargetType
GROUP BY reaction_type;
