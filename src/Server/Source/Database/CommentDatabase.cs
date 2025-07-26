using Server.Source.Data;

namespace Server.Source.Database
{
    public class CommentDatabase: BaseDatabase<Comment>
    {
        private static CommentDatabase _instance;
        private CommentDatabase() { }

        public static CommentDatabase Instance => _instance ??= new CommentDatabase();

        protected override string TableName => "comment";
    }
}
