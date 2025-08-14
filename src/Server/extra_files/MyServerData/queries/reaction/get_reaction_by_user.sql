-- DECLARE @UserId UNIQUEIDENTIFIER = '45B4C3C5-BEA0-4251-98C6-A81828CB0B9C';

SELECT  R.reactionId AS ReactionId,
        R.reactionType AS ReactionType,
        R.dateDo AS DateDo,
        'Review' AS Type,
        RR.reviewId AS Id
FROM [Reactions] R 
    JOIN [Reaction_User] RU ON RU.reactionId = R.reactionId
    JOIN [Review_Reaction] RR ON RR.reactionId = RU.reactionId
WHERE RU.author = @UserId
UNION
SELECT  R.reactionId AS ReactionId,
        R.reactionType AS ReactionType,
        R.dateDo AS DateDo,
        'Comment' AS Type,
        CR.commentId AS Id
FROM [Reactions] R 
    JOIN [Reaction_User] RU ON RU.reactionId = R.reactionId
    JOIN Comment_Reaction CR ON CR.reactionId = RU.reactionId
WHERE RU.author = @UserId

ORDER BY DateDo DESC;

