using Newtonsoft.Json.Linq;
using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Helper;
using Server.Source.Manager;
using System.Reflection;
using Server.Source.Extra;

namespace Server.Source.Database
{
    public class AccountDatabase : BaseDatabase<Account>
    {
        private static AccountDatabase _instance;
        private AccountDatabase() { }

        public static AccountDatabase Instance => _instance ??= new AccountDatabase();

        protected override string TableName => "account";


        public virtual string CreateAccount(object data)
        {
            var sqlPath = $"{TableName}/create_account";
            var result = ExecuteScalar<Account>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<string>(result);
        }

        public virtual string CheckLoginAccount(object data)
        {
            var sqlPath = $"{TableName}/check_login_account";
            var result = ExecuteScalar<Account>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<string>(result);
        }
        public virtual int ChangeUsername(object data)
        {
            var sqlPath = $"{TableName}/change_username";
            var result = ExecuteScalar<ParamsChangeUsername>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }
        public virtual int ChangePassword(object data)
        {
            var sqlPath = $"{TableName}/change_password";
            var result = ExecuteScalar<ParamsChangePassword>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }

        public virtual int ForgetPassword(object data)
        {
            var sqlPath = $"{TableName}/forget_password";
            var result = ExecuteScalar<ParamsForgetPassword>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }





    }
}
