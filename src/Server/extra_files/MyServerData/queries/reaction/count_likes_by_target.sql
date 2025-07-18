SELECT COUNT(*) 
FROM Likes 
WHERE targetType = ? AND (reviewID = ? OR commentID = ?)