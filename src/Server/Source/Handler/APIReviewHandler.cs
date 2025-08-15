using Microsoft.VisualBasic.ApplicationServices;
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
    internal class APIReviewHandler : HandlerBase
    {
        public override string Type => "/api/review";

        public APIReviewHandler() 
        {
            GetRoutes["/api/review/game"] = GetReviewByGameHandle;
            GetRoutes["/api/review/user"] = GetReviewByUsserHandle;
        }

        protected override void GetHandle(HttpRequest request, HttpsSession session)
        {
            var reviewId = DecodeHelper.GetParamWithURL("reviewId", request.Url);

            if (string.IsNullOrEmpty(reviewId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin review!");
                return;
            }

            var reviewInfo = DatabaseHelper.GetData<Review>(reviewId);
            OkHandle(session, reviewInfo);
        }

        private void GetReviewByGameHandle(HttpRequest request, HttpsSession session)
        {
            var gameId = DecodeHelper.GetParamWithURL("gameId", request.Url);
            if (string.IsNullOrEmpty(gameId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin!");
                return;
            }

            var gameIdParams = new GameIdParams(gameId);
            var userInfo = ReviewDatabase.Instance.GetReviewByGame(gameIdParams);
            OkHandle(session, userInfo);

        }

        private void GetReviewByUsserHandle(HttpRequest request, HttpsSession session)
        {
            var userId = DecodeHelper.GetUserIdFromRequest(request);

            if (string.IsNullOrEmpty(userId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin!");
                return;
            }

            var userIdParams = new UserIdParams(userId);
            var reviewInfo = ReviewDatabase.Instance.GetReviewByUser(userIdParams);
            OkHandle(session, reviewInfo);

        }

        protected override void PostHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            // Chưa đăng nhập
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<Review>(request.Body);
            var newData = JsonHelper.AddPropertyAndDeserialize<Review>(
                JsonHelper.Serialize(data), "UserId", userId
            );

            // Validate input
            if (newData == null)
            {
                ErrorHandle(session, "Dữ liệu follow không hợp lệ");
                return;
            }

            // DB insert
            if (ReviewDatabase.Instance.CreateReview(newData) < 1)
            {
                ErrorHandle(session, "Tạo review không thành công");
                return;
            }

            OkHandle(session, "Tạo review thành công");
        }

        protected override void PutHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            // Chưa đăng nhập
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<Review>(request.Body);
            var newData = JsonHelper.AddPropertyAndDeserialize<Review>(
                JsonHelper.Serialize(data), "UserId", userId
            );

            // DB update
            if (ReviewDatabase.Instance.SetReview(newData) < 1)
            {
                ErrorHandle(session, "Cập nhật review không thành công");
                return;
            }

            OkHandle(session, "Cập nhật review thành công");

        }

        protected override void DeleteHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();

            // Chưa đăng nhập
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<DeleteReviewParams>(request.Body);
            data.UserId = userId;

            if (DatabaseHelper.DeleteData<Review>(data) < 1)
            {
                ErrorHandle(session, "Xoá review không thành công!");
                return;
            }

            OkHandle(session, "Đã xoá review thành công!");
        }

    }
}
