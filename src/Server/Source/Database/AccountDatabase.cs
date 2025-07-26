using Server.Source.Data;

namespace Server.Source.Database
{
    public class AccountDatabase : BaseDatabase<Account>
    {
        private static AccountDatabase _instance;
        private AccountDatabase() { }

        public static AccountDatabase Instance => _instance ??= new AccountDatabase();

        protected override string TableName => "account";

    }
}
