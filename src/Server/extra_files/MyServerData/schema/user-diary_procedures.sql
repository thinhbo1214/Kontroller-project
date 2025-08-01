CREATE OR ALTER PROCEDURE UDP_AddUserDiary
@UserId UNIQUEIDENTIFIER,
@DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0 OR 
       DBO.DF_DiaryIdExists(@DiaryId) = 0 OR 
       DBO.UDF_UserDiaryExists(@UserId, @DiaryId) = 1
    BEGIN
        SELECT 0 AS UserDiaryAdded;
        RETURN;
    END

    INSERT INTO User_Diary (userId, diaryId)
    VALUES (@UserId, @DiaryId);

    IF DBO.UDF_UserDiaryExists(@UserId, @DiaryId) = 0
    BEGIN
        SELECT 0 AS UserDiaryAdded;
        RETURN;
    END;

    SELECT 1 AS UserDiaryAdded;
END;
GO

CREATE OR ALTER PROCEDURE UDP_DeleteUserDiary
@UserId UNIQUEIDENTIFIER,
@DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UDF_UserDiaryExists(@UserId, @DiaryId) = 0
    BEGIN
        SELECT 0 AS UserDiaryDeleted;
        RETURN;
    END

    DELETE FROM User_Diary WHERE userId = @UserId AND diaryId = @DiaryId;

    DECLARE @RowsAffected INT = @@ROWCOUNT;
    SELECT @RowsAffected AS UserDiaryDeleted;
END;
GO

CREATE OR ALTER PROCEDURE UDP_GetAllUserDiary
AS
BEGIN
    SELECT * FROM User_Diary;
END;
GO

CREATE OR ALTER PROCEDURE UDP_GetDiariesOfUser
@UserId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0
    BEGIN
        SELECT NULL AS DiaryId;
        RETURN;
    END

    SELECT diaryId FROM User_Diary WHERE userId = @UserId;
END;
GO

CREATE OR ALTER PROCEDURE UDP_GetUsersOfDiary
@DiaryId UNIQUEIDENTIFIER
AS
BEGIN
    IF DBO.DF_DiaryIdExists(@DiaryId) = 0
    BEGIN
        SELECT NULL AS UserId;
        RETURN;
    END

    SELECT userId FROM User_Diary WHERE diaryId = @DiaryId;
END;
GO

