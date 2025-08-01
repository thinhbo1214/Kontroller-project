using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Helper;
using Server.Source.Manager;

namespace Server.Source.Database
{
    public class AccountDatabase : BaseDatabase<Account>
    {
        private static AccountDatabase _instance;
        private AccountDatabase() { }

        public static AccountDatabase Instance => _instance ??= new AccountDatabase();

        protected override string TableName => "user";

        public virtual string CreateAccount(object data)
        {
            if (data is not Account model)
                return null;

            var db = Simulation.GetModel<DatabaseManager>();
            db.OpenConnection();

            var param = DatabaseHelper.ToDictionary(model);
            var sqlPath = $"{TableName}/create_account";
            string usedId = db.ExecuteScalar(sqlPath, param).ToString();

            db.CloseConnection();

            return usedId;
        }

        public virtual string CheckLoginAccount(object data)
        {
            if (data is not Account model)
                return null;

            var db = Simulation.GetModel<DatabaseManager>();
            db.OpenConnection();

            var param = DatabaseHelper.ToDictionary(model);
            var sqlPath = $"{TableName}/check_login_account";
            string usedId = db.ExecuteScalar(sqlPath, param).ToString();


            db.CloseConnection();

            return usedId;
        }
    }
}
