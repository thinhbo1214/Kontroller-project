SELECT r.*, a.userName
FROM Review r JOIN Account a ON r.userID = a.userID
WHERE r.gameID = ?;