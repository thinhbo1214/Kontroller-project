INSERT INTO Likes (userID, targetType, likedDate, commentID) VALUES (?, 'comment', ?, ?)INSERT INTO reactions (
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
  @CommentId,
  'comment',
  'like',
  CURRENT_TIMESTAMP
);
