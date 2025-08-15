using Server.Source.Data;
using Server.Source.Extra;
using Server.Source.Helper;

namespace Server.Source.Database
{
    public class CommentDatabase: BaseDatabase<Comment>
    {
        private static CommentDatabase _instance;
        private CommentDatabase() { }

        public static CommentDatabase Instance => _instance ??= new CommentDatabase();

        protected override string TableName => "comment";

        public virtual int CreateComment(object data)
        {
            var sqlPath = $"{TableName}/create_comment";
            var result = ExecuteScalar<Comment>(sqlPath, data);
            return DatabaseHelper.GetScalarValue<int>(result);
        }

        public virtual List<Comment> GetCommentByUser(object data)
        {
            var sqlPath = $"{TableName}/get_comment_by_user";
            var result = ExecuteQuery<Comment, UserIdParams>(sqlPath, data);

            return result;
        }

        public virtual List<Comment> GetCommentByReview(object data)
        {
            var sqlPath = $"{TableName}/get_comment_by_review";
            var result = ExecuteQuery<Comment, ReviewIdParams>(sqlPath, data);

            return result;
        }

        public virtual int SetComment(object data)
        {
            var sqlPath = $"{TableName}/set_comment";
            var result = ExecuteScalar<Comment>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }
    }
}
