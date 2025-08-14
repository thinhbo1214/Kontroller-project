-- DECLARE @UserId UNIQUEIDENTIFIER = '45B4C3C5-BEA0-4251-98C6-A81828CB0B9C';
-- DECLARE @ReviewId UNIQUEIDENTIFIER = '3D0A6A38-2B2B-4670-9260-AFB2CF4AD698';
-- DECLARE @ReactionId UNIQUEIDENTIFIER = '25B780E1-BC24-4B74-B74B-D35D21193484';
DECLARE @Result INT = 1;
DECLARE @Temp INT = 1;

BEGIN TRY
    BEGIN TRANSACTION;

        -- Kiểm tra xem user có sở hữu reaction không
        IF DBO.RUF_ReactionUserExists(@ReactionId, @UserId) = 0
            RAISERROR('User không sở hữu reaction!', 16, 1);

        -- Xóa liên kết giữa reaction và review
        EXEC DBO.RRP_DeleteReviewReaction
            @ReviewId = @ReviewId, 
            @ReactionId = @ReactionId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xóa liên kết giữa reaction và user
        EXEC DBO.RUP_DeleteReactionUser
            @Author = @UserId, 
            @ReactionId = @ReactionId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Xóa reaction
        EXEC DBO.RP_DeleteReaction 
            @ReactionId = @ReactionId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        -- Cập nhật số lượng reaction của review
        EXEC DBO.RP_UpdateReviewDecreaseReaction 
            @ReviewId = @ReviewId, 
            @Result = @Temp OUTPUT;
        SET @Result *= @Temp;

        IF @Result = 0
            RAISERROR('Xóa reaction không thành công!', 16, 1);

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