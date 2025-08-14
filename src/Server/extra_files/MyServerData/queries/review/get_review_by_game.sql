-- DECLARE @GameId UNIQUEIDENTIFIER = '96BD943E-D105-409C-9F1E-05F207A4C7D60';

SELECT  R.reviewId AS ReviewId,
        R.content AS Content,
        R.rating AS Rating,
        R.dateCreated AS DateCreated,
        R.numberReaction AS NumberReaction,
        R.numberComment AS NumberComment,
        U.username Username,
        U.avatar Avatar
FROM [Games] G 
	JOIN [Game_Review] GR ON G.gameId = GR.gameId
	JOIN [Reviews] R ON  R.reviewId = GR.reviewId
    JOIN [Review_User] RU ON R.reviewId = RU.reviewId
    JOIN [Users] U ON U.userId = RU.author
WHERE G.gameId = @GameId;