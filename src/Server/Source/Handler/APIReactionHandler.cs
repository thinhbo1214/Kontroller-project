using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Database;
using Server.Source.Extra;
using Server.Source.Helper;
using Server.Source.Manager;
using Server.Source.NetCoreServer;
using System;

namespace Server.Source.Handler
{
    internal class APIReactionHandler : HandlerBase
    {
        public override string Type => "/api/reaction";

        public APIReactionHandler()
        {
            GetRoutes["/api/reaction/comment"] = GetByCommentHandle;
            GetRoutes["/api/reaction/review"] = GetByReviewHandle;

            PostRoutes["/api/reaction/comment"] = PostReactionForCommentHandle;
            PostRoutes["/api/reaction/review"] = PostReactionForReviewHandle;

            PutRoutes["/api/reaction/comment"] = PutReactionForCommentHandle;
            PutRoutes["/api/reaction/review"] = PutReactionForReviewHandle;

            DeleteRoutes["/api/reaction/comment"] = DeleteReactionForCommentHandle;
            DeleteRoutes["/api/reaction/review"] = DeleteReactionForReviewHandle;
        }

        // GET reactions by comment
        private void GetByCommentHandle(HttpRequest request, HttpsSession session)
        {
            var commentId = DecodeHelper.GetParamWithURL("commentId", request.Url);
            if (string.IsNullOrEmpty(commentId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin comment!");
                return;
            }

            var commentParams = new CommentIdParams(commentId);
            var reactions = ReactionDatabase.Instance.GetReactionByComment(commentParams);
            OkHandle(session, reactions);
        }

        // GET reactions by review
        private void GetByReviewHandle(HttpRequest request, HttpsSession session)
        {
            var reviewId = DecodeHelper.GetParamWithURL("reviewId", request.Url);
            if (string.IsNullOrEmpty(reviewId))
            {
                ErrorHandle(session, "Không tìm thấy thông tin review!");
                return;
            }

            var reviewParams = new ReviewIdParams(reviewId);
            var reactions = ReactionDatabase.Instance.GetReactionByReview(reviewParams);
            OkHandle(session, reactions);
        }

        // POST reaction for comment
        private void PostReactionForCommentHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<Reaction>(request.Body);
            data.UserId = Guid.Parse(userId);
            data.Type = "Comment";

            if (ReactionDatabase.Instance.CreateReactionForComment(data) < 1)
            {
                ErrorHandle(session, "Tạo reaction không thành công");
                return;
            }

            OkHandle(session, "Tạo reaction thành công");
        }

        // POST reaction for review
        private void PostReactionForReviewHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<Reaction>(request.Body);
            data.UserId = Guid.Parse(userId);
            data.Type = "Review";

            if (ReactionDatabase.Instance.CreateReactionForReview(data) < 1)
            {
                ErrorHandle(session, "Tạo reaction không thành công");
                return;
            }

            OkHandle(session, "Tạo reaction thành công");
        }

        // PUT reaction for comment
        private void PutReactionForCommentHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<Reaction>(request.Body);
            data.UserId = Guid.Parse(userId);

            if (ReactionDatabase.Instance.SetReactionComment(data) < 1)
            {
                ErrorHandle(session, "Cập nhật reaction không thành công");
                return;
            }

            OkHandle(session, "Cập nhật reaction  thành công");
        }

        // PUT reaction for review
        private void PutReactionForReviewHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<Reaction>(request.Body);
            data.UserId = Guid.Parse(userId);

            if (ReactionDatabase.Instance.SetReactionReview(data) < 1)
            {
                ErrorHandle(session, "Cập nhật reaction không thành công");
                return;
            }

            OkHandle(session, "Cập nhật reaction  thành công");
        }

    

        // DELETE reaction by comment
        private void DeleteReactionForCommentHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }


            var data = JsonHelper.Deserialize<DeleteReactionCParams>(request.Body);
            data.UserId = userId;


            if (ReactionDatabase.Instance.DeleteReactionComment(data) < 1)
            {
                ErrorHandle(session, "Xoá reaction không thành công");
                return;
            }

            OkHandle(session, "Đã xoá reaction thành công!");
        }

        // DELETE reaction by review
        private void DeleteReactionForReviewHandle(HttpRequest request, HttpsSession session)
        {
            var sessionManager = Simulation.GetModel<SessionManager>();
            if (!sessionManager.Authorization(request, out string userId, session))
            {
                ErrorHandle(session, status: 401);
                return;
            }

            var data = JsonHelper.Deserialize<DeleteReactionRParams>(request.Body);
            data.UserId = userId;

            if (ReactionDatabase.Instance.DeleteReactionReview(data) < 1)
            {
                ErrorHandle(session, "Xoá reaction không thành công");
                return;
            }

            OkHandle(session, "Đã xoá reaction thành công!");
        }
    }
}
