-- DECLARE @CommentId UNIQUEIDENTIFIER = '8BF84BBD-EC6F-40DD-969D-9EE2AF9DB169';

SELECT  R.reactionId AS ReactionId,
        R.reactionType AS ReactionType,
        R.dateDo AS DateDo
FROM [Reactions] R 
    JOIN [Comment_Reaction] CR ON CR.reactionId = R.reactionId
WHERE CR.commentId = @CommentId;