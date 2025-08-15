using Microsoft.IdentityModel.Tokens;
using Microsoft.VisualBasic.ApplicationServices;
using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Database;
using Server.Source.Extra;
using Server.Source.Helper;
using Server.Source.Manager;
using Server.Source.NetCoreServer;

namespace Server.Source.Handler
{
    using static System.Runtime.InteropServices.JavaScript.JSType;
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
            GetRoutes["/api/user/follower"] = GetFollowerHandle;
            GetRoutes["/api/user/following"] = GetFollowingHandle;
            PutRoutes["/api/user/email"] = PutUserEmail;
            PutRoutes["/api/user/avatar"] = PutUserAvatar;
            PutRoutes["/api/user/username"] = PutUserUsername;
            PutRoutes["/api/user/password"] = PutUserPassword;
            PostRoutes["/api/user/follow"] = PostFollowHandle;
            DeleteRoutes["/api/user/follow"] = DeleteFollowHandle;
        }

        /// <summary>
        /// Xử lý yêu cầu GET để lấy thông tin người dùng theo userId hoặc token.
        /// </summary>
        protected override void GetHandle(HttpRequest request, HttpsSession session)
        {
            var userId = ResolveUserId(request);
            if (string.IsNullOrEmpty(userId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin user!");
                return;
            }

            var userInfo = DatabaseHelper.GetData<User>(userId);
            OkHandle(session, userInfo);
        }
        private string ResolveUserId(HttpRequest request)
        {
            var userId = DecodeHelper.GetParamWithURL("userId", request.Url);
            if (!string.IsNullOrEmpty(userId)) return userId;

            var username = DecodeHelper.GetParamWithURL("username", request.Url);
            if (!string.IsNullOrEmpty(username))
            {
                return UserDatabase.Instance.GetUserIdByUsername(new UsernameParams { Username = username });
            }

            string token = TokenHelper.GetToken(request);
            if (TokenHelper.TryParseToken(token, out var sessionId))
            {
                return Simulation.GetModel<SessionManager>().GetUserId(sessionId);
            }

            return null;
        }

        private void GetFollowerHandle(HttpRequest request, HttpsSession session)
        {
            var page = DecodeHelper.GetParamWithURL("page", request.Url);
            var limit = DecodeHelper.GetParamWithURL("limit", request.Url);
            var userId = DecodeHelper.GetUserIdFromRequest(request);

            var data = new UserPaginateParams { Page = int.Parse(page), Limit = int.Parse(limit), UserId = userId };

            if (string.IsNullOrEmpty(data.UserId))
            {
                string token = TokenHelper.GetToken(request);
                if (TokenHelper.TryParseToken(token, out var sessionId))
                {
                    data.UserId = Simulation.GetModel<SessionManager>().GetUserId(sessionId);
                }

            }
            if (string.IsNullOrEmpty(data.UserId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin user!");
                return;
            }
            ObjectHelper.LogObjectProperties(data);
            var userFollower = UserDatabase.Instance.GetUserFollower(data);
            OkHandle(session, userFollower);
        }

        private void GetFollowingHandle(HttpRequest request, HttpsSession session)
        {
            var page = DecodeHelper.GetParamWithURL("page", request.Url);
            var limit = DecodeHelper.GetParamWithURL("limit", request.Url);
            var userId = DecodeHelper.GetUserIdFromRequest(request);

            var data = new UserPaginateParams { Page = int.Parse(page), Limit = int.Parse(limit), UserId = userId };

            if (string.IsNullOrEmpty(data.UserId))
            {
                string token = TokenHelper.GetToken(request);
                if (TokenHelper.TryParseToken(token, out var sessionId))
                {
                    data.UserId = Simulation.GetModel<SessionManager>().GetUserId(sessionId);
                }

            }
            if (string.IsNullOrEmpty(data.UserId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin user!");
                return;
            }

            var userFollower = UserDatabase.Instance.GetUserFollowing(data);
            OkHandle(session, userFollower);
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
                ErrorHandle(session, "Thông tin đăng ký không có giá trị hoặc được sử dụng bởi người khác");
                return;
            }

            string userId = AccountDatabase.Instance.CreateAccount(account);
            if (!userId.IsNullOrEmpty())
            {
                var response = ResponseHelper.NewUserSession(userId, session.Response);
                session.SendResponseAsync(response);
                return;
            }

            ErrorHandle(session, "Đăng ký không thành công");

        }

        private void PostFollowHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            // Chưa đăng nhập
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<FollowParam>(request.Body);
            var newData = JsonHelper.AddPropertyAndDeserialize<FollowParam>(
                JsonHelper.Serialize(data), "UserId", userId
            );

            // Validate input
            if (newData == null || string.IsNullOrWhiteSpace(newData.Target) || newData.Target == userId)
            {
                ErrorHandle(session, "Dữ liệu follow không hợp lệ");
                return;
            }

            // DB insert
            if (UserDatabase.Instance.Follow(newData) < 1)
            {
                ErrorHandle(session, "Follow không thành công");
                return;
            }

            OkHandle(session, "Follow thành công");
        }


        /// <summary>
        /// Hàm tiện ích dùng chung cho các phương thức PUT để xác thực và gán thêm trường UserId.
        /// </summary>
        private T PutBase<T>(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return default;
            }
            // Deserialize trực tiếp trước (để giữ nguyên casing từ JSON)
            var data = JsonHelper.Deserialize<T>(request.Body);
            if (data == null)
                return default;

            var newData = JsonHelper.AddPropertyAndDeserialize<T>(JsonHelper.Serialize(data), "UserId", userId);
            return newData;
        }
        protected override void PutHandle(HttpRequest request, HttpsSession session)
        {
            var data = PutBase<User>(request, session);
            if (data == null)
            {
                return;
            }
            if (UserDatabase.Instance.SetUser(data) != 1)
            {
                ErrorHandle(session, "Cập nhật thông tin user không thành công");
                return;
            }
            OkHandle(session, "Cập nhật thông tin user thành công");
        }

        /// <summary>Cập nhật email người dùng.</summary>
        private void PutUserEmail(HttpRequest request, HttpsSession session)
        {
            var data = PutBase<ChangeEmailParams>(request, session);

            if (data == null)
            {
                return;
            }

            if (UserDatabase.Instance.ChangeEmail(data) != 1)
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
            if (data == null || UserDatabase.Instance.ChangeAvatar(data) != 1)
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

            if (data == null)
            {
                return;
            }

            if (AccountDatabase.Instance.ChangeUsername(data) != 1)
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

            if (data == null)
            {
                return;
            }

            if (AccountDatabase.Instance.ChangePassword(data) != 1)
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
                ErrorHandle(session, "Chưa đăng nhập, không thể xoá tài khoản!", 401);
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

        private void DeleteFollowHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            // Chưa đăng nhập
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<FollowParam>(request.Body);
            var newData = JsonHelper.AddPropertyAndDeserialize<FollowParam>(
                JsonHelper.Serialize(data), "UserId", userId
            );

            // Validate input
            if (newData == null || string.IsNullOrWhiteSpace(newData.Target) || newData.Target == userId)
            {
                ErrorHandle(session, "Dữ liệu unfollow không hợp lệ");
                return;
            }

            if (UserDatabase.Instance.UnFollow(newData) < 1)
            {
                ErrorHandle(session, "UnFollow không thành công");
                return;
            }

            OkHandle(session, "UnFollow thành công");
        }

    }
}

