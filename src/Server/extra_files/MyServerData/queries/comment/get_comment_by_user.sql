-- DECLARE @UserId UNIQUEIDENTIFIER = '2d1f1b33-8d1e-4722-b566-125fca142750';

SELECT C.commentId AS CommentId,
    C.content AS Content,
    C.created_at AS CreatedAt,
    C.numberReaction AS NumberReaction
FROM [Comments] C JOIN [Comment_User] CU ON C.commentId = CU.commentId
WHERE CU.author = @UserId ;
