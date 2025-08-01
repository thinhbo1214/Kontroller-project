using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Helper;
using Server.Source.Manager;
using System.Data;

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
