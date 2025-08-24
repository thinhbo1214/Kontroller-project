-- DECLARE @ReviewId UNIQUEIDENTIFIER = '66a28bc7-73c5-4a1e-9973-b8c8ba96515d';

SELECT  R.reviewId AS ReviewId,
        R.content AS Content,
        R.rating AS Rating,
        R.dateCreated AS DateCreated,
        R.numberReaction AS NumberReaction,
        R.numberComment AS NumberComment,
        U.username Username,
        U.avatar Avatar,
        G.poster As Poster,
        G.title AS Title,
        G.gameId AS GameId,
        G.backdrop AS Backdrop
FROM [Review_User] RU
	JOIN [Reviews] R ON  R.reviewId = RU.reviewId
    JOIN [Users] U ON U.userId = RU.author
	JOIN [Game_Review] GR ON GR.reviewId = R.reviewId
	JOIN [Games] G ON G.gameId = GR.gameId
WHERE R.reviewId = @ReviewId;