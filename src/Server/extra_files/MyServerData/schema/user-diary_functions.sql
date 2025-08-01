CREATE OR ALTER FUNCTION UDF_UserDiaryExists (
    @UserId UNIQUEIDENTIFIER,
    @DiaryId UNIQUEIDENTIFIER
)
RETURNS BIT
AS
BEGIN
    IF DBO.UF_UserIdExists(@UserId) = 0 OR DBO.DF_DiaryIdExists(@DiaryId) = 0
        RETURN 0;

    RETURN (
        SELECT CASE 
            WHEN EXISTS (
                SELECT 1 FROM User_Diary 
                WHERE userId = @UserId AND diaryId = @DiaryId
            ) THEN 1 ELSE 0 
        END
    );
END;
GO
