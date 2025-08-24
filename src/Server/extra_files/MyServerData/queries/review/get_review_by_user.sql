-- DECLARE @UserId UNIQUEIDENTIFIER = '45B4C3C5-BEA0-4251-98C6-A81828CB0B9C';

SELECT  G.gameId AS GameId,
		G.title AS Title,
        G.poster AS Poster,
        G.avgRating AS AvgRating,
        R.reviewId AS ReviewId,
        R.content AS Content,
        R.rating AS Rating,
        R.dateCreated AS DateCreated,
        R.numberReaction AS NumberReaction,
        R.numberComment AS NumberComment
FROM [Games] G 
	JOIN [Game_Review] GR ON G.gameId = GR.gameId
	JOIN [Reviews] R ON  R.reviewId = GR.reviewId
    JOIN [Review_User] RU ON R.reviewId = RU.reviewId
    JOIN [Users] U ON U.userId = RU.author
WHERE U.userId = @UserId;