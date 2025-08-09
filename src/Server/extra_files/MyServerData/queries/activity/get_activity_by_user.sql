--  DECLARE @UserId UNIQUEIDENTIFIER = '2d1f1b33-8d1e-4722-b566-125fca142750';

SELECT  A.activityId AS ActivityId,
        A.content AS Content,
        A.dateDo AS DateDo
FROM [Activities] A JOIN [User_Activity] UA ON A.activityId = UA.activityId
WHERE UA.userId = @UserId ;
