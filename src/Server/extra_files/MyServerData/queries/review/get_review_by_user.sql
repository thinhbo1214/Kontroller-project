-- DECLARE @UserId UNIQUEIDENTIFIER = '2d1f1b33-8d1e-4722-b566-125fca142750';

SELECT  G.gameId AS GameId,
		G.title AS Title,
        R.reviewId AS ReviewId,
        R.content AS Content,
        R.rating AS Rating,
        R.dateCreated AS DateCreated,
        R.numberReaction AS NumberReaction,
        R.numberComment AS NumberComment
FROM [Games] G 
	JOIN [Game_Review] GR ON G.gameId = GR.gameId
	JOIN [Reviews] R ON  R.reviewId = R.reviewId
    JOIN [Review_User] RU ON R.reviewId = RU.reviewId
    JOIN [Users] U ON U.userId = RU.author
WHERE U.userId = @UserId;