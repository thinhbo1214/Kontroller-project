using Server.Source.Data;

namespace Server.Source.Database
{
    public class ListDatabase: BaseDatabase<List>
    {
        private static ListDatabase _instance;
        private ListDatabase() { }

        public static ListDatabase Instance => _instance ??= new ListDatabase();

        protected override string TableName => "list";
    }
}
