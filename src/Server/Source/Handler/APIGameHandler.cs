using Microsoft.IdentityModel.Tokens;
using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Database;
using Server.Source.Extra;
using Server.Source.Helper;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Handler
{
    internal class APIGameHandler : HandlerBase
    {
        public override string Type => "/api/game";

        public APIGameHandler()
        {
            GetRoutes[Type] = GetHandle;
            PostRoutes[Type] = PostHandle;
            PutRoutes[Type] = PutHandle;
            DeleteRoutes[Type] = DeleteHandle;
        }

        public override void GetHandle(HttpRequest request, HttpsSession session)
        {
            var gameId = DecodeHelper.GetParamWithURL("gameId", request.Url);

            if (string.IsNullOrEmpty(gameId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin game!");
                return;
            }

            var gameInfo = DatabaseHelper.GetData<Game>(gameId);
            OkHandle(session, gameInfo);
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
            if (data == null || UserDatabase.Instance.ChangeAvatar(data) != 1)
            {
                ErrorHandle(session, "Đổi avatar không thành công");
                return;
            }
            OkHandle(session, "Đổi avatar thành công");
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
        public override void DeleteHandle(HttpRequest request, HttpsSession session)
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
