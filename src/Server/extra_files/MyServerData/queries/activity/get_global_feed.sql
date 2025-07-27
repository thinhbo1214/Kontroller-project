SELECT a.*, u.username, g.title AS game_title
FROM activities a
LEFT JOIN users u ON a.user_id = u.user_id
LEFT JOIN games g ON a.target_type = 'game' AND a.target_id = g.game_id
ORDER BY a.created_at DESC
LIMIT 100;
