-- DECLARE @CommentId UNIQUEIDENTIFIER = '2d1f1b33-8d1e-4722-b566-125fca142750';

SELECT  R.reactionId AS ReactionId,
        R.reactionType AS ReactionType,
        R.dateDo AS DateDo
FROM [Reactions] R 
    JOIN [Comment_Reaction] CR ON CR.reactionId = R.reactionId
WHERE CR.commentId = @CommentId;