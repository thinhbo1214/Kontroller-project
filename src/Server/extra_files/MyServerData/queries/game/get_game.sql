-- DECLARE @GameId UNIQUEIDENTIFIER = 'A85E5BD2-71BD-4079-B194-03C727DF60F4';

SELECT G.gameId AS GameId,
		G.title AS Title,
		G.descriptions AS Descriptions,
		G.genre AS Genre, 
		G.avgRating AS AvgRating,
		G.poster AS Poster,
		G.backdrop AS Backdrop,
		G.details AS Details,
		G.numberReview AS NumberReview,
		ISNULL(STRING_AGG(GS.serviceName, ','), '') AS Services
FROM [Games] G
LEFT JOIN Game_Service GS ON G.gameId = GS.gameId
WHERE G.gameId = @GameId
GROUP BY 
    G.gameId, G.title, G.descriptions, G.genre, 
    G.avgRating, G.poster, G.backdrop, G.details, G.numberReview;