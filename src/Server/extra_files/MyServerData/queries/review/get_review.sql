-- DECLARE @ReviewId UNIQUEIDENTIFIER = '2d1f1b33-8d1e-4722-b566-125fca142750';

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