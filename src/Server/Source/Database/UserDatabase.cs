using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Helper;
using Server.Source.Manager;
using System.Data;
using Server.Source.Extra;

namespace Server.Source.Database
{
    /// <summary>
    /// Lớp quản lý dữ liệu bảng <c>user</c> trong cơ sở dữ liệu.
    /// Cung cấp các chức năng cập nhật email và avatar của người dùng.
    /// </summary>
    public class UserDatabase : BaseDatabase<User>
    {
        /// <summary>
        /// Singleton instance của UserDatabase.
        /// </summary>
        private static UserDatabase _instance;

        /// <summary>
        /// Constructor riêng để ngăn tạo instance từ bên ngoài (singleton).
        /// </summary>
        private UserDatabase() { }

        /// <summary>
        /// Truy cập instance duy nhất của UserDatabase.
        /// </summary>
        public static UserDatabase Instance => _instance ??= new UserDatabase();

        /// <summary>
        /// Tên bảng trong cơ sở dữ liệu là "user".
        /// </summary>
        protected override string TableName => "user";

        /// <summary>
        /// Thay đổi email người dùng.
        /// </summary>
        /// <param name="data">Thông tin cần thiết để thay đổi email (kiểu ParamsChangeEmail).</param>
        /// <returns>1 nếu thành công, 0 nếu thất bại.</returns>
        public virtual int ChangeEmail(object data)
        {
            var sqlPath = $"{TableName}/change_email";
            var result = ExecuteScalar<ChangeEmailParams>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }

        /// <summary>
        /// Thay đổi avatar người dùng.
        /// </summary>
        /// <param name="data">Thông tin avatar mới (kiểu ParamsChangeAvatar).</param>
        /// <returns>1 nếu thành công, 0 nếu thất bại.</returns>
        public virtual int ChangeAvatar(object data)
        {
            var sqlPath = $"{TableName}/change_avatar";
            var result = ExecuteScalar<ChangeAvatarParams>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }
        public virtual int Follow(object data)
        {
            var sqlPath = $"{TableName}/follow_user";
            var result = ExecuteScalar<FollowParam>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }

        public virtual int UnFollow(object data)
        {
            var sqlPath = $"{TableName}/unfollow_user";
            var result = ExecuteScalar<FollowParam>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }
    }
}
