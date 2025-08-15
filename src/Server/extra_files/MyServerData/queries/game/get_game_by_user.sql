-- DECLARE @UserId UNIQUEIDENTIFIER = '45B4C3C5-BEA0-4251-98C6-A81828CB0B9C';

SELECT G.gameId AS GameId,
		G.title AS Title,
		G.descriptions AS Descriptions,
		G.genre AS Genre, 
		G.avgRating AS AvgRating,
		G.poster AS Poster,
		G.backdrop AS Backdrop,
		G.details AS Details,
		G.numberReview AS NumberReview,
		R.rating AS Rating,
		ISNULL(STRING_AGG(GS.serviceName, ','), '') AS Services
FROM [Games] G 
	LEFT JOIN Game_Service GS ON G.gameId = GS.gameId
	JOIN [Game_Review] GR ON G.gameId = GR.gameId
	JOIN [Review_User] RU ON GR.reviewId = RU.reviewId
	JOIN [Reviews] R ON R.reviewId = RU.reviewId
WHERE RU.author = @UserId
GROUP BY 
    G.gameId, G.title, G.descriptions, G.genre, 
    G.avgRating, G.poster, G.backdrop, G.details, G.numberReview, R.rating;