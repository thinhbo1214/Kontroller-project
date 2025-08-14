-- DECLARE @UserId UNIQUEIDENTIFIER = '45B4C3C5-BEA0-4251-98C6-A81828CB0B9C';
-- DECLARE @ReviewId UNIQUEIDENTIFIER = '3D0A6A38-2B2B-4670-9260-AFB2CF4AD698';
-- DECLARE @CommentId UNIQUEIDENTIFIER = 'FB6D39AB-C2EA-430B-9BD7-91701E614857';
-- DECLARE @Content NVARCHAR(MAX) = N'Bình luận đã được chỉnh sửa!';
DECLARE @Result INT = 1;
DECLARE @Temp INT = 1;

BEGIN TRY
    BEGIN TRANSACTION;

        -- Kiểm tra xem user có sở hữu comment không
        IF DBO.CUF_CommentUserExists(@CommentId, @UserId) = 0
            RAISERROR('User không sở hữu comment!', 16, 1);

        -- Cập nhật nội dung comment
        EXEC DBO.CP_UpdateCommentContent @CommentId, @Content, @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        IF @Result = 0
            RAISERROR('Cập nhật comment không thành công!', 16, 1);

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SELECT 
         ERROR_MESSAGE(),
         ERROR_SEVERITY(),
         ERROR_STATE();

    SET @Result = 0;
END CATCH

SELECT @Result;