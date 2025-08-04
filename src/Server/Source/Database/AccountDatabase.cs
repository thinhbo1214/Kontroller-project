using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Extra;
using Server.Source.Helper;
using Server.Source.Manager;
using System.Reflection;

namespace Server.Source.Database
{
    /// <summary>
    /// Lớp quản lý truy xuất dữ liệu bảng <c>account</c> trong cơ sở dữ liệu.
    /// Cung cấp các chức năng tạo tài khoản, đăng nhập, thay đổi thông tin và khôi phục mật khẩu.
    /// </summary>
    public class AccountDatabase : BaseDatabase<Account>
    {
        /// <summary>
        /// Singleton instance của AccountDatabase.
        /// </summary>
        private static AccountDatabase _instance;

        /// <summary>
        /// Constructor riêng để ngăn tạo instance từ bên ngoài (singleton).
        /// </summary>
        private AccountDatabase() { }

        /// <summary>
        /// Truy cập instance duy nhất của AccountDatabase.
        /// </summary>
        public static AccountDatabase Instance => _instance ??= new AccountDatabase();

        /// <summary>
        /// Tên bảng trong cơ sở dữ liệu là "account".
        /// </summary>
        protected override string TableName => "account";

        /// <summary>
        /// Tạo tài khoản mới trong hệ thống.
        /// </summary>
        /// <param name="data">Dữ liệu tài khoản cần tạo (kiểu Account).</param>
        /// <returns>Chuỗi kết quả trả về từ truy vấn (có thể là ID, trạng thái, v.v.).</returns>
        public virtual string CreateAccount(object data)
        {
            var sqlPath = $"{TableName}/create_account";
            var result = ExecuteScalar<Account>(sqlPath, data);
            return DatabaseHelper.GetScalarValue<string>(result);
        }

        /// <summary>
        /// Kiểm tra thông tin đăng nhập.
        /// </summary>
        /// <param name="data">Thông tin đăng nhập (username/email và password).</param>
        /// <returns>Chuỗi ID người dùng nếu thành công, null hoặc chuỗi rỗng nếu thất bại.</returns>
        public virtual string CheckLoginAccount(object data)
        {
            var sqlPath = $"{TableName}/check_login_account";
            var result = ExecuteScalar<Account>(sqlPath, data);
            return DatabaseHelper.GetScalarValue<string>(result);
        }

        /// <summary>
        /// Thay đổi tên người dùng (username).
        /// </summary>
        /// <param name="data">Thông tin thay đổi (kiểu ParamsChangeUsername).</param>
        /// <returns>1 nếu thành công, 0 nếu thất bại.</returns>
        public virtual int ChangeUsername(object data)
        {
            var sqlPath = $"{TableName}/change_username";
            var result = ExecuteScalar<ParamsChangeUsername>(sqlPath, data);
            return DatabaseHelper.GetScalarValue<int>(result);
        }

        /// <summary>
        /// Thay đổi mật khẩu tài khoản.
        /// </summary>
        /// <param name="data">Thông tin thay đổi (kiểu ParamsChangePassword).</param>
        /// <returns>1 nếu thành công, 0 nếu thất bại.</returns>
        public virtual int ChangePassword(object data)
        {
            var sqlPath = $"{TableName}/change_password";
            var result = ExecuteScalar<ParamsChangePassword>(sqlPath, data);
            return DatabaseHelper.GetScalarValue<int>(result);
        }

        /// <summary>
        /// Xử lý yêu cầu quên mật khẩu.
        /// </summary>
        /// <param name="data">Thông tin người dùng để xác minh (ParamsForgetPassword).</param>
        /// <returns>1 nếu gửi thành công, 0 nếu không hợp lệ.</returns>
        public virtual int ForgetPassword(object data)
        {
            var sqlPath = $"{TableName}/forget_password";
            var result = ExecuteScalar<ParamsForgetPassword>(sqlPath, data);
            return DatabaseHelper.GetScalarValue<int>(result);
        }
    }
}
