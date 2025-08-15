-- DECLARE @ReviewId UNIQUEIDENTIFIER = '753E0E2C-6B2C-46ED-A6C4-A7F0E4EC33AE';

SELECT  R.reactionId AS ReactionId,
        R.reactionType AS ReactionType,
        R.dateDo AS DateDo,
        U.username AS Username,
        U.avatar AS Avatar
FROM [Reactions] R 
    JOIN [Review_Reaction] RR ON RR.reactionId = R.reactionId
    JOIN [Reaction_User] RU ON RU.reactionId = R.reactionId
    JOIN [Users] U ON U.userId = RU.author
WHERE RR.reviewId = @ReviewId;