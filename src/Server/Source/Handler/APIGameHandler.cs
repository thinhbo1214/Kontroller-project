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
            GetRoutes["/api/game/Service"] = GetServiceHandle;
            GetRoutes["/api/game/Review"] = GetReviewHandle;
        }
        protected override void GetHandle(HttpRequest request, HttpsSession session)
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

        private void GetServiceHandle(HttpRequest request, HttpsSession session)
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

        private void GetReviewHandle(HttpRequest request, HttpsSession session)
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

    }
}
