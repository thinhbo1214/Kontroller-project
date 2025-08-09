-- DECLARE @UserId UNIQUEIDENTIFIER = 'cc5d9511-3128-4441-b329-023be8330e6b';

SELECT  R.reactionId AS ReactionId,
        R.reactionType AS ReactionType,
        R.dateDo AS DateDo
FROM [Reactions] R 
    JOIN [Reaction_User] RU ON RU.reactionId = R.reactionId
WHERE RU.author = @UserId