using Server.Source.Data;

namespace Server.Source.Database
{
    public class ReviewDatabase: BaseDatabase<Review>
    {
        private static ReviewDatabase _instance;
        private ReviewDatabase() { }

        public static ReviewDatabase Instance => _instance ??= new ReviewDatabase();

        protected override string TableName => "review";
    }
}
