-- DECLARE @GameId UNIQUEIDENTIFIER = '96BD943E-D105-409C-9F1E-05F207A4C7D60';

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