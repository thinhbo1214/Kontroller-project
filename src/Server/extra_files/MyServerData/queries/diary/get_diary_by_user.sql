-- DECLARE @UserId UNIQUEIDENTIFIER = '2d1f1b33-8d1e-4722-b566-125fca142750';

SELECT D.diaryId AS DiaryId,
        D.dateLogged AS DateLogged,
        D.numberGameLogged AS NumberGameLogged
FROM [Diaries] D JOIN [User_Diary] UD ON D.diaryId = UD.diaryId
WHERE UD.userId = @UserId ;