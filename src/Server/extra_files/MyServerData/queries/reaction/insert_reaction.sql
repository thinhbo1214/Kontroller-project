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
  CURRENT_TIMESTAMP
);
