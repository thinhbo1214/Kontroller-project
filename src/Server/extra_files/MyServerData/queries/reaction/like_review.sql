INSERT INTO Likes (userID, targetType, likedDate, reviewID) VALUES (?, 'review', ?, ?)INSERT INTO reactions (
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
  @ReviewId,
  'review',
  'like',
  CURRENT_TIMESTAMP
);
