DECLARE @UserId UNIQUEIDENTIFIER = 'b31d439e-a8f3-47c0-968c-071333d23a96';

SELECT  R.reactionId AS ReactionId,
        R.reactionType AS ReactionType,
        R.dateDo AS DateDo
FROM [Reactions] R 
    JOIN [Reaction_User] RU ON RU.reactionId = R.reactionId
WHERE RU.author = @UserId