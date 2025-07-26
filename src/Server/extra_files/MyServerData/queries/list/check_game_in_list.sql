SELECT COUNT(*) AS exists_flag
FROM list_items
WHERE list_id = @ListId
  AND game_id = @GameId;
