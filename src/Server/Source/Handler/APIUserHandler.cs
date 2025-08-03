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
    internal class APIUserHandler : HandlerBase
    {
        public override string Type => "/api/user";
        public override void GetHandle(HttpRequest request, HttpsSession session)
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

                return;
            }

            var userInfo = DatabaseHelper.GetData<User>(userId);
            var response = ResponseHelper.MakeJsonResponse(session.Response, userInfo, 200); // tạo response
            session.SendResponseAsync(response);

        }
        public override void PostHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            //Nếu đã đăng nhập và phiên còn hạn
            if (sessionManager.Authorization(request, out string id, session))
            {
                OkHandle(session);
                return;
            }

            var value = request.Body;
            var account = JsonHelper.Deserialize<Account>(value);
            // Gưi dữ liệu ko đủ
            if (account == null)
            {
                var errorResponse = ResponseHelper.MakeJsonResponse(session.Response, 400);
                session.SendResponseAsync(errorResponse);
                return;
            }

            // Đăng ký thành công:
            string userId = AccountDatabase.Instance.CreateAccount(account);
            if (!userId.IsNullOrEmpty())
            {
                var response = ResponseHelper.NewUserSession(userId, session.Response);

                session.SendResponseAsync(response); // gửi response
            }
            else
            {
                var errorResponse = ResponseHelper.MakeJsonResponse(session.Response, 400);
                session.SendResponseAsync(errorResponse);
            }
        }
        public override void PutHandle(HttpRequest request, HttpsSession session)
        {
            var key = DecodeHelper.GetParamWithURL("key", request.Url);
            var value = request.Body;

            // Put the cache value
            CommonCache.GetInstance().PutCacheValue(key, value);

            // Lưu vào ổ đĩa
            //DatabaseManager.SaveFile(key, value);

            // Response with the cache value
            session.SendResponseAsync(session.Response.MakeOkResponse());
        }
        public override void DeleteHandle(HttpRequest request, HttpsSession session)
        {
            var key = DecodeHelper.GetParamWithURL("key", request.Url);

            // Delete the cache value
            if (CommonCache.GetInstance().DeleteCacheValue(key, out var value))
            {
                //DatabaseManager.DeleteFile(key, out _); // xóa luôn file gốc
                // Response with the cache value
                session.SendResponseAsync(session.Response.MakeGetResponse(value));
            }
            //else if (DatabaseManager.DeleteFile(key, out var fileContent))
            //{
            //    session.SendResponseAsync(session.Response.MakeGetResponse(fileContent));
            //}
            else
                session.SendResponseAsync(session.Response.MakeErrorResponse(404, "Deleted cache value was not found for the key: " + key));
        }
    }
}
