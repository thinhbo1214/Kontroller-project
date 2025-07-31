-- set_user.sql
IF EXISTS (SELECT 1 FROM users WHERE user_id = @UserId)
BEGIN
    -- Nếu tồn tại, cập nhật các trường có giá trị truyền vào
    UPDATE users
    SET 
        username = COALESCE(@Username, username),
        email = COALESCE(@Email, email),
        password_hash = COALESCE(@PasswordHash, password_hash),
        avatar = COALESCE(@Avatar, avatar),
        is_logged_in = COALESCE(@IsLoggedIn, is_logged_in),
        updated_at = GETDATE()
    WHERE user_id = @UserId;
END
ELSE
BEGIN
    -- Nếu chưa tồn tại, tạo mới
    INSERT INTO users (user_id, username, email, password_hash, avatar, is_logged_in, created_at, updated_at)
    VALUES (
        @UserId,
        @Username,
        @Email,
        @PasswordHash,
        @Avatar,
        ISNULL(@IsLoggedIn, 0),
        GETDATE(),
        GETDATE()
    );
END
