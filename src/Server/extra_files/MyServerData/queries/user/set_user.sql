DECLARE @Result INT;

BEGIN TRY
    BEGIN TRANSACTION
    
        EXEC DBO.UP_UpdateUserAll @UserId, @Username, @Password,  @Email, @Avatar, @IsUserLoggedIn, @Result = @Result OUTPUT;

        
        IF @Result = 0
            RAISERROR('Cập nhật thông tin user không thành công!', 16, 1);

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 
        ROLLBACK TRANSACTION;

    SET @Result = 0;
END CATCH

SELECT @Result;