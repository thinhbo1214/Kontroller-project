-- DECLARE @CommentId UNIQUEIDENTIFIER = '225EE596-2873-4B4F-AA56-25A998F9B7ED';

SELECT  R.reactionId AS ReactionId,
        R.reactionType AS ReactionType,
        R.dateDo AS DateDo,
        U.userId AS UserId,
        U.username AS Username,
        U.avatar AS Avatar
FROM [Reactions] R 
    JOIN [Comment_Reaction] CR ON CR.reactionId = R.reactionId
    JOIN [Reaction_User] RU ON RU.reactionId = R.reactionId
    JOIN [Users] U ON U.userId = RU.author
WHERE CR.commentId = @CommentId;