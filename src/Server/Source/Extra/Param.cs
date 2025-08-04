namespace Server.Source.Extra
{
    /// <summary>
    /// Lớp cơ sở cho các yêu cầu xóa, chứa UserId của người gửi yêu cầu.
    /// </summary>
    public class DeleteRequestBase
    {
        public string UserId { get; set; }
    }

    /// <summary>
    /// Yêu cầu xóa tài khoản, bao gồm UserId và mật khẩu xác minh.
    /// </summary>
    public class DeleteAccountRequest : DeleteRequestBase
    {
        public string Password { get; set; }
    }

    /// <summary>
    /// Yêu cầu xóa một mục tiêu cụ thể (ví dụ bài viết, bình luận,...), bao gồm UserId và TargetId.
    /// </summary>
    public class DeleteTargetRequest : DeleteRequestBase
    {
        public string TargetId { get; set; }
    }

    /// <summary>
    /// Đối tượng mang theo một giá trị Id đơn giản.
    /// </summary>
    public class ParamsId
    {
        public string Id { get; set; }
    }

    /// <summary>
    /// Yêu cầu thay đổi mật khẩu, bao gồm mật khẩu cũ và mật khẩu mới.
    /// </summary>
    public class ParamsChangePassword
    {
        public string UserId { get; set; }
        public string OldPassword { get; set; }
        public string NewPassword { get; set; }
    }

    /// <summary>
    /// Yêu cầu thay đổi tên người dùng (username).
    /// </summary>
    public class ParamsChangeUsername
    {
        public string UserId { get; set; }
        public string Username { get; set; }
    }

    /// <summary>
    /// Yêu cầu quên mật khẩu, cần xác minh UserId và Email.
    /// </summary>
    public class ParamsForgetPassword
    {
        public string UserId { get; set; }
        public string Email { get; set; }
    }

    /// <summary>
    /// Yêu cầu thay đổi địa chỉ email.
    /// </summary>
    public class ParamsChangeEmail
    {
        public string UserId { get; set; }
        public string Email { get; set; }
    }

    /// <summary>
    /// Yêu cầu thay đổi ảnh đại diện (avatar).
    /// </summary>
    public class ParamsChangeAvatar
    {
        public string UserId { get; set; }
        public string Avatar { get; set; }
    }

    /// <summary>
    /// Yêu cầu khôi phục mật khẩu chỉ dựa trên email.
    /// </summary>
    public class ForgetPasswordRequest
    {
        public string Email { get; set; }
    }
}
