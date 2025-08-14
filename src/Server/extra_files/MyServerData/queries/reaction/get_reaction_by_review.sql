-- DECLARE @ReviewId UNIQUEIDENTIFIER = '3D0A6A38-2B2B-4670-9260-AFB2CF4AD698';

SELECT  R.reactionId AS ReactionId,
        R.reactionType AS ReactionType,
        R.dateDo AS DateDo
FROM [Reactions] R 
    JOIN [Review_Reaction] RR ON RR.reactionId = R.reactionId
WHERE RR.reviewId = @ReviewId;