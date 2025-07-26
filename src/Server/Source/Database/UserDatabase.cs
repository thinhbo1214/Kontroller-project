using Server.Source.Data;

namespace Server.Source.Database
{
    public class UserDatabase: BaseDatabase<User>
    {
        private static UserDatabase _instance;
        private UserDatabase() { }

        public static UserDatabase Instance => _instance ??= new UserDatabase();

        protected override string TableName => "user";
    }
}
