-- DECLARE @UserId UNIQUEIDENTIFIER = '2d1f1b33-8d1e-4722-b566-125fca142750';

SELECT G.gameId AS GameId,
		G.title AS Title,
		G.descriptions AS Descriptions,
		G.genre AS Genre, 
		G.avgRating AS AvgRating,
		G.poster AS Poster,
		G.backdrop AS Backdrop,
		G.details AS Details,
		G.numberReview AS NumberReview
FROM [Games] G 
	JOIN [Game_Review] GR ON G.gameId = GR.gameId
	JOIN [Review_User] RU ON GR.reviewId = RU.reviewId
	JOIN [Users] U ON RU.author = U.userId
WHERE U.userId = @UserId ;