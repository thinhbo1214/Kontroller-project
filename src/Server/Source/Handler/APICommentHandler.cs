using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Database;
using Server.Source.Extra;
using Server.Source.Helper;
using Server.Source.Manager;
using Server.Source.NetCoreServer;

namespace Server.Source.Handler
{
    internal class APICommentHandler : HandlerBase
    {
        public override string Type => "/api/comment";

        public APICommentHandler()
        {
            GetRoutes["/api/comment/review"] = GetCommentByReviewHandle;
            GetRoutes["/api/comment/user"] = GetCommentByUserHandle;
        }

        protected override void GetHandle(HttpRequest request, HttpsSession session)
        {
            var commentId = DecodeHelper.GetParamWithURL("commentId", request.Url);

            if (string.IsNullOrEmpty(commentId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin comment!");
                return;
            }

            var commentInfo = DatabaseHelper.GetData<Comment>(commentId);
            OkHandle(session, commentInfo);
        }

        private void GetCommentByReviewHandle(HttpRequest request, HttpsSession session)
        {
            var reviewId = DecodeHelper.GetParamWithURL("reviewId", request.Url);
            if (string.IsNullOrEmpty(reviewId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin!");
                return;
            }

            var reviewParams = new ReviewIdParams(reviewId);
            var commentList = CommentDatabase.Instance.GetCommentByReview(reviewParams);
            OkHandle(session, commentList);
        }

        private void GetCommentByUserHandle(HttpRequest request, HttpsSession session)
        {
            var userId = DecodeHelper.GetUserIdFromRequest(request);
            if (string.IsNullOrEmpty(userId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin!");
                return;
            }

            var userParams = new UserIdParams(userId);
            var commentList = CommentDatabase.Instance.GetCommentByUser(userParams);
            OkHandle(session, commentList);
        }

        protected override void PostHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<Comment>(request.Body);
            var newData = JsonHelper.AddPropertyAndDeserialize<Comment>(
                JsonHelper.Serialize(data), "UserId", userId
            );

            if (newData == null)
            {
                ErrorHandle(session, "Dữ liệu comment không hợp lệ");
                return;
            }

            if (CommentDatabase.Instance.CreateComment(newData) < 1)
            {
                ErrorHandle(session, "Tạo comment không thành công");
                return;
            }

            OkHandle(session, "Tạo comment thành công");
        }

        protected override void PutHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<Comment>(request.Body);
            var newData = JsonHelper.AddPropertyAndDeserialize<Comment>(
                JsonHelper.Serialize(data), "UserId", userId
            );

            if (CommentDatabase.Instance.SetComment(newData) < 1)
            {
                ErrorHandle(session, "Cập nhật comment không thành công");
                return;
            }

            OkHandle(session, "Cập nhật comment thành công");
        }

        protected override void DeleteHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<DeleteCommentParams>(request.Body);
            data.UserId = userId;

            if (DatabaseHelper.DeleteData<Comment>(data) < 1)
            {
                ErrorHandle(session, "Xoá comment không thành công!");
                return;
            }

            OkHandle(session, "Đã xoá comment thành công!");
        }
    }
}
