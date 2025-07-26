INSERT INTO reviews (
  review_id,
  game_id,
  user_id,
  content,
  rating,
  date_created,
  updated_at
)
VALUES (
  @ReviewId,
  @GameId,
  @UserId,
  @Content,
  @Rating,
  CURRENT_TIMESTAMP,
  CURRENT_TIMESTAMP
);
