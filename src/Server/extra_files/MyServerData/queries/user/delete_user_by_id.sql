DECLARE @Result INT;

BEGIN TRY
    BEGIN TRANSACTION;

    EXEC @Result = DBO.UP_DeleteUser @UserId, @Password;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    SET @Result = -1;  -- lỗi hệ thống, trả về -1
END CATCH;

RETURN @Result;
