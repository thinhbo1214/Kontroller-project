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

    /// <summary>
    /// Yêu cầu gửi email, chứa đầy đủ thông tin người gửi, người nhận và nội dung.
    /// </summary>
    public class EmailSendRequest
    {
        /// <summary>
        /// Email dùng để đăng nhập SMTP (sẽ kết hợp với mật khẩu từ cấu hình NotifyManager).
        /// </summary>
        public string SmtpUser { get; set; } = default!;

        /// <summary>
        /// Email hiển thị là người gửi.
        /// </summary>
        public string FromEmail { get; set; } = default!;

        /// <summary>
        /// Email người nhận.
        /// </summary>
        public string ToEmail { get; set; } = default!;

        /// <summary>
        /// Tiêu đề email.
        /// </summary>
        public string Subject { get; set; } = default!;

        /// <summary>
        /// Nội dung email.
        /// </summary>
        public string Body { get; set; } = default!;

        /// <summary>
        /// Cho biết nội dung email có phải là HTML hay không.
        /// </summary>
        public bool IsHtml { get; set; } = false;

        /// <summary>
        /// Danh sách đường dẫn tuyệt đối tới các tệp đính kèm.
        /// </summary>
        public List<string> Attachments { get; set; } = new();
    }

}
