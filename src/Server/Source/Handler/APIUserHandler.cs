using Azure;
using Microsoft.IdentityModel.Tokens;
using Microsoft.VisualBasic.ApplicationServices;
using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Database;
using Server.Source.Extra;
using Server.Source.Helper;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using System.Reflection;

namespace Server.Source.Handler
{
    using User = Server.Source.Data.User;

    /// <summary>
    /// Xử lý các API liên quan đến người dùng, như đăng ký, đăng nhập, cập nhật email, avatar, username, v.v.
    /// </summary>
    internal class APIUserHandler : HandlerBase
    {
        /// <summary>
        /// Kiểu đường dẫn chính của handler. Dùng để xác định handler phù hợp khi routing.
        /// </summary>
        public override string Type => "/api/user";

        /// <summary>
        /// Khởi tạo và đăng ký các route PUT tương ứng với các chức năng người dùng.
        /// </summary>
        public APIUserHandler()
        {
            PutRoutes["/api/user/email"] = PutUserEmail;
            PutRoutes["/api/user/avatar"] = PutUserAvatar;
            PutRoutes["/api/user/username"] = PutUserUsername;
            PutRoutes["/api/user/password"] = PutUserPassword;
        }

        /// <summary>
        /// Xử lý yêu cầu GET để lấy thông tin người dùng theo userId hoặc token.
        /// </summary>
        protected override void GetHandle(HttpRequest request, HttpsSession session)
        {
            var userId = DecodeHelper.GetParamWithURL("userId", request.Url);
            if (string.IsNullOrEmpty(userId))
            {
                string token = TokenHelper.GetToken(request);
                if (TokenHelper.TryParseToken(token, out var sessionId))
                {
                    userId = Simulation.GetModel<SessionManager>().GetUserId(sessionId);
                }
            }
            if (string.IsNullOrEmpty(userId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin user!");
                return;
            }

            var userInfo = DatabaseHelper.GetData<User>(userId);
            OkHandle(session, userInfo);
        }

        /// <summary>
        /// Xử lý POST cho việc đăng ký tài khoản người dùng.
        /// </summary>
        protected override void PostHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            if (sessionManager.Authorization(request, out string id, session))
            {
                OkHandle(session);
                return;
            }

            var value = request.Body;
            var account = JsonHelper.Deserialize<Account>(value);
            if (account == null)
            {
                ErrorHandle(session);
                return;
            }

            string userId = AccountDatabase.Instance.CreateAccount(account);
            if (!userId.IsNullOrEmpty())
            {
                var response = ResponseHelper.NewUserSession(userId, session.Response);
                session.SendResponseAsync(response);
                return;
            }

            ErrorHandle(session);

        }
        /// <summary>
        /// Hàm tiện ích dùng chung cho các phương thức PUT để xác thực và gán thêm trường UserId.
        /// </summary>
        private T PutBase<T>(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                return default;
            }
            // Deserialize trực tiếp trước (để giữ nguyên casing từ JSON)
            Simulation.GetModel<LogManager>().Log(request.Body);
            var data = JsonHelper.Deserialize<T>(request.Body);
            if (data == null)
                return default;

            var newData = JsonHelper.AddPropertyAndDeserialize<T>(JsonHelper.Serialize(data), "UserId", userId);
            return newData;
        }

        /// <summary>Cập nhật email người dùng.</summary>
        private void PutUserEmail(HttpRequest request, HttpsSession session)
        {
            var data = PutBase<ChangeEmailParams>(request, session);
            if (data == null || UserDatabase.Instance.ChangeEmail(data) != 1)
            {
                ErrorHandle(session, "Đổi email không thành công");
                return;
            }
            OkHandle(session, "Đổi email thành công");
        }

        /// <summary>Cập nhật avatar người dùng.</summary>
        private void PutUserAvatar(HttpRequest request, HttpsSession session)
        {
            var data = PutBase<ChangeAvatarParams>(request, session);
            if (UserDatabase.Instance.ChangeAvatar(data) != 1)
            {
                ErrorHandle(session, "Đổi avatar không thành công!");
                return;
            }

            OkHandle(session, "Đổi avatar thành công!");
        }

        /// <summary>Cập nhật username người dùng.</summary>
        private void PutUserUsername(HttpRequest request, HttpsSession session)
        {
            var data = PutBase<ChangeUsernameParams>(request, session);
            if (data == null || AccountDatabase.Instance.ChangeUsername(data) != 1)
            {
                ErrorHandle(session, "Đổi username không thành công!");
                return;
            }
            OkHandle(session, "Đổi username thành công");
        }

        /// <summary>Cập nhật password người dùng.</summary>
        private void PutUserPassword(HttpRequest request, HttpsSession session)
        {
            var data = PutBase<ChangePasswordParams>(request, session);
            if (data == null || AccountDatabase.Instance.ChangePassword(data) != 1)
            {
                ErrorHandle(session, "Đổi mật khẩu không thành công!");
                return;
            }
            OkHandle(session, "Đổi mật khẩu thành công!");
        }

        /// <summary>
        /// Xử lý xóa tài khoản người dùng.
        /// </summary>
        protected override void DeleteHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, "Chưa đăng nhập, không thể xoá tài khoản!");
                return;
            }

            var data = JsonHelper.Deserialize<DeleteAccountParams>(request.Body);
            data.UserId = userId;

            if (DatabaseHelper.DeleteData<Account>(data) == 1)
            {
                OkHandle(session, "Đã xoá tài khoản thành công!");
                return;
            }

            ErrorHandle(session, "Xoá tài khoản không thành công!");
        }
    }
}

