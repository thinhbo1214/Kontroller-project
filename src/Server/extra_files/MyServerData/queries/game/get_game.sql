-- DECLARE @GameId UNIQUEIDENTIFIER = 'cc5d9511-3128-4441-b329-023be8330e6b';

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
WHERE G.gameId = @GameId;