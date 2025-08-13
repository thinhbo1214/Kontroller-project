-- DECLARE @UserId UNIQUEIDENTIFIER = 'cc5d9511-3128-4441-b329-023be8330e6b';

SELECT C.commentId AS CommentId,
    C.content AS Content,
    C.created_at AS CreatedAt,
    C.numberReaction AS NumberReaction
FROM [Comments] C 
JOIN [Comment_User] CU ON C.commentId = CU.commentId
WHERE CU.author = @UserId;
