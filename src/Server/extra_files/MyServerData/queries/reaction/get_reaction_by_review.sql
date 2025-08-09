-- DECLARE @ReviewId UNIQUEIDENTIFIER = '2d1f1b33-8d1e-4722-b566-125fca142750';

SELECT  R.reactionId AS ReactionId,
        R.reactionType AS ReactionType,
        R.dateDo AS DateDo
FROM [Reactions] R 
    JOIN [Review_Reaction] RR ON RR.reactionId = R.reactionId
WHERE RR.reviewId = @ReviewId;