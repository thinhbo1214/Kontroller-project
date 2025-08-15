using Server.Source.Data;
using Server.Source.Extra;
using Server.Source.Helper;

namespace Server.Source.Database
{
    public class ReactionDatabase: BaseDatabase<Reaction>
    {
        private static ReactionDatabase _instance;
        private ReactionDatabase() { }

        public static ReactionDatabase Instance => _instance ??= new ReactionDatabase();

        protected override string TableName => "reaction";

        public virtual int CreateReactionForComment(object data)
        {
            var sqlPath = $"{TableName}/create_reaction_comment";
            var result = ExecuteScalar<Reaction>(sqlPath, data);
            return DatabaseHelper.GetScalarValue<int>(result);
        }

        public virtual int CreateReactionForReview(object data)
        {
            var sqlPath = $"{TableName}/create_reaction_review";
            var result = ExecuteScalar<Reaction>(sqlPath, data);
            return DatabaseHelper.GetScalarValue<int>(result);
        }

        public virtual int DeleteReactionComment(object data)
        {
            var sqlPath = $"{TableName}/delete_reaction_comment";
            var result = ExecuteScalar<DeleteReactionCParams>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }

        public virtual int DeleteReactionReview(object data)
        {
            var sqlPath = $"{TableName}/delete_reaction_review";
            var result = ExecuteScalar<DeleteReactionRParams>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }

        public virtual int SetReactionComment(object data)
        {
            var sqlPath = $"{TableName}/set_reaction_comment";
            var result = ExecuteScalar<Reaction>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }

        public virtual List<Reaction> GetReactionByComment(object data)
        {
            var sqlPath = $"{TableName}/get_reaction_by_comment";
            var result = ExecuteQuery<Reaction, CommentIdParams>(sqlPath, data);

            return result;
        }

        public virtual List<Reaction> GetReactionByReview(object data)
        {
            var sqlPath = $"{TableName}/get_reaction_by_review";
            var result = ExecuteQuery<Reaction, ReviewIdParams>(sqlPath, data);

            return result;
        }

        public virtual List<Reaction> GetReactionByUser(object data)
        {
            var sqlPath = $"{TableName}/get_reaction_by_user";
            var result = ExecuteQuery<Reaction, UserIdParams>(sqlPath, data);

            return result;
        }

        public virtual int SetReactionReview(object data)
        {
            var sqlPath = $"{TableName}/set_reaction_review";
            var result = ExecuteScalar<Reaction>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }



    }
}
