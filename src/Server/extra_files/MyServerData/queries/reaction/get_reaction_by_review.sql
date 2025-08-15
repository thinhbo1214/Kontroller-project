-- DECLARE @ReviewId UNIQUEIDENTIFIER = '84533798-d2f1-4d0b-97d3-9f5eab17b06e';

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