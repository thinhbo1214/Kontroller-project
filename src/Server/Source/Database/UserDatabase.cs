using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Helper;
using Server.Source.Manager;
using System.Data;

namespace Server.Source.Database
{
    public class UserDatabase : BaseDatabase<User>
    {
        private static UserDatabase _instance;
        private UserDatabase() { }

        public static UserDatabase Instance => _instance ??= new UserDatabase();

        protected override string TableName => "user";

        protected class ParamsChangeEmail
        {
            public string UserId { get; set; }
            public string Email { get; set; }
        }

        protected class ParamsChangeAvatar
        {
            public string UserId { get; set; }
            public string Avatar { get; set; }
        }

        public virtual int ChangeEmail(object data)
        {
            var sqlPath = $"{TableName}/change_email";
            var result = ExecuteScalar<ParamsChangeEmail>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }

        public virtual int ChangeAvatar(object data)
        {
            var sqlPath = $"{TableName}/change_avatar";
            var result = ExecuteScalar<ParamsChangeAvatar>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }
    }
}
