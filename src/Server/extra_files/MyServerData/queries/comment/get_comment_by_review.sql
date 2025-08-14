-- DECLARE @ReviewId UNIQUEIDENTIFIER = '753E0E2C-6B2C-46ED-A6C4-A7F0E4EC33AE';

SELECT C.commentId AS CommentId,
    C.content AS Content,
    C.created_at AS CreatedAt,
    C.numberReaction AS NumberReaction,
    U.username AS Username,
    U.avatar AS Avatar
FROM [Comments] C 
JOIN [Comment_User] CU ON C.commentId = CU.commentId
JOIN [Users] U ON U.userId = CU.author
JOIN [Comment_Review] CR ON CR.commentId = C.commentId
WHERE CR.reviewId = @ReviewId;