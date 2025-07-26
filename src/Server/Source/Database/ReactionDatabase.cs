using Server.Source.Data;

namespace Server.Source.Database
{
    public class ReactionDatabase: BaseDatabase<Reaction>
    {
        private static ReactionDatabase _instance;
        private ReactionDatabase() { }

        public static ReactionDatabase Instance => _instance ??= new ReactionDatabase();

        protected override string TableName => "reaction";
    }
}
