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
            GetRoutes["/api/game/pagination"] = GetGamePaginateHandle;
            GetRoutes["/api/game/user"] = GetGameByUserHandle;
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

        private void GetGamePaginateHandle(HttpRequest request, HttpsSession session)
        {
            var page = DecodeHelper.GetParamWithURL("page", request.Url);
            var limit = DecodeHelper.GetParamWithURL("limit", request.Url);

            var pagination = new PaginateParams { Page = int.Parse(page), Limit = int.Parse(limit) };

            var games = GameDatabase.Instance.GetGamePagination(pagination);

            OkHandle(session, games);
        }

        private void GetGameByUserHandle(HttpRequest request, HttpsSession session)
        {
            var userId = DecodeHelper.GetParamWithURL("userId", request.Url);

            var data = new UserIdParams(userId);

            var games = GameDatabase.Instance.GetGameByUser(data);

            OkHandle(session, games);
        }

    }
}
