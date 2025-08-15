using Server.Source.Data;
using Server.Source.Extra;
using Server.Source.Helper;

namespace Server.Source.Database
{
    public class ReviewDatabase: BaseDatabase<Review>
    {
        private static ReviewDatabase _instance;
        private ReviewDatabase() { }

        public static ReviewDatabase Instance => _instance ??= new ReviewDatabase();

        protected override string TableName => "review";

        public virtual int CreateReview(object data)
        {
            var sqlPath = $"{TableName}/create_review";
            var result = ExecuteScalar<Review>(sqlPath, data);
            return DatabaseHelper.GetScalarValue<int>(result);
        }

        public virtual List<Review> GetReviewByUser(object data)
        {
            var sqlPath = $"{TableName}/get_review_by_user";
            var result = ExecuteQuery<Review, UserIdParams>(sqlPath, data);

            return result;
        }

        public virtual List<Review> GetReviewByGame(object data)
        {
            var sqlPath = $"{TableName}/get_review_by_game";
            var result = ExecuteQuery<Review, GameIdParams>(sqlPath, data);

            return result;
        }

        public virtual int SetReview(object data)
        {
            var sqlPath = $"{TableName}/set_review";
            var result = ExecuteScalar<Review>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }
    }
}
