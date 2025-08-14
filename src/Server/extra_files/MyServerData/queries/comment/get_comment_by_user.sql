DECLARE @UserId UNIQUEIDENTIFIER = '45B4C3C5-BEA0-4251-98C6-A81828CB0B9C';

SELECT C.commentId AS CommentId,
    C.content AS Content,
    C.created_at AS CreatedAt,
    C.numberReaction AS NumberReaction,
    R.reviewId AS ReviewId
FROM [Comments] C 
JOIN [Comment_User] CU ON C.commentId = CU.commentId
JOIN [Comment_Review] CR ON CR.commentId = C.commentId
JOIN [Reviews] R ON R.reviewId = CR.reviewId
WHERE CU.author = @UserId;
