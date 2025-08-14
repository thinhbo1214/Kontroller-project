-- DECLARE @ReviewId UNIQUEIDENTIFIER = 'A3C1CC6C-64DA-4703-B857-BB2ECE99B35E';

SELECT  R.reviewId AS ReviewId,
        R.content AS Content,
        R.rating AS Rating,
        R.dateCreated AS DateCreated,
        R.numberReaction AS NumberReaction,
        R.numberComment AS NumberComment,
        U.username Username,
        U.avatar Avatar
FROM [Review_User] RU
	JOIN [Reviews] R ON  R.reviewId = RU.reviewId
    JOIN [Users] U ON U.userId = RU.author
WHERE R.reviewId = @ReviewId;