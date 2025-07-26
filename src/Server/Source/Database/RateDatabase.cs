using Server.Source.Data;

namespace Server.Source.Database
{
    public class RateDatabase: BaseDatabase<Rate>
    {
        private static RateDatabase _instance;
        private RateDatabase() { }

        public static RateDatabase Instance => _instance ??= new RateDatabase();

        protected override string TableName => "rate";
    }
}
