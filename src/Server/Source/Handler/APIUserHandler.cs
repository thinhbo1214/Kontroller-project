using Microsoft.IdentityModel.Tokens;
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
    internal class APIUserHandler : HandlerBase
    {
        public override string Type => "/api/user";
        public override void GetHandle(HttpRequest request, HttpsSession session)
        {
            var useId = DecodeHelper.GetParamWithURL("useId", request.Url);

            if (string.IsNullOrEmpty(useId))
            {
                session.SendResponseAsync(ResponseHelper.MakeJsonResponse(session.Response, 400));
                return;
            }

            session.SendResponseAsync(ResponseHelper.MakeJsonResponse(session.Response, 404));

        }


        public override void PostHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            //Nếu đã đăng nhập và phiên còn hạn
            if (sessionManager.Authorization(request, out string id, session))
            {
                var response = ResponseHelper.MakeJsonResponse(session.Response, 200); // tạo response
                session.SendResponseAsync(response); // gửi response
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
