using Server.Source.Event;
using Server.Source.Extra;
using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Handler
{
    internal class APICacheHandler : HandlerBase
    {
        public override string Type => "/api/cache";

        public override void HeadHandle(HttpsSession session)
        {
            session.SendResponseAsync(session.Response.MakeHeadResponse());
        }
        public override void GetHandle(HttpRequest request, HttpsSession session)
        {
            var key = DecodeHelper.GetParamWithURL("key", request.Url);

            if (string.IsNullOrEmpty(key))
            {
                // Response with all cache values
                session.SendResponseAsync(session.Response.MakeGetResponse(CommonCache.GetInstance().GetAllCache(), "application/json; charset=UTF-8"));
            }
            // Get the cache value by the given key
            else if (CommonCache.GetInstance().GetCacheValue(key, out var value))
            {
                // Response with the cache value
                session.SendResponseAsync(session.Response.MakeGetResponse(value));
            }
            //else if (DatabaseManager.TryGetFile(key, out var fileContent))
            //{
            //    // Nếu file tồn tại trong máy chủ, đưa vào cache rồi trả ra
            //    CommonCache.GetInstance().PutCacheValue(key, fileContent);
            //    session.SendResponseAsync(session.Response.MakeGetResponse(fileContent));
            //}
            else
                session.SendResponseAsync(session.Response.MakeErrorResponse(404, "Required cache value was not found for the key: " + key));

        }
        public override void PostHandle(HttpRequest request, HttpsSession session)
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
