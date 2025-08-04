using Newtonsoft.Json.Linq;
using Server.Source.Core;
using Server.Source.Helper;
using Server.Source.Interface;
using Server.Source.Manager;
using Server.Source.Extra;

namespace Server.Source.Database
{
    /// <summary>
    /// Lớp cơ sở trừu tượng cho các database cụ thể, cung cấp các thao tác chung như Get, Delete, và thực thi truy vấn SQL.
    /// </summary>
    /// <typeparam name="T">Kiểu dữ liệu bản ghi tương ứng với bảng.</typeparam>
    public abstract class BaseDatabase<T> : IDatabase where T : class, new()
    {
        /// <summary>
        /// Tên bảng tương ứng trong database. Mỗi class con phải override.
        /// </summary>
        protected abstract string TableName { get; }

        /// <summary>
        /// Trả về chính instance hiện tại (theo interface IDatabase).
        /// </summary>
        public IDatabase GetInstance() => this;

        /// <summary>
        /// Lấy bản ghi từ database theo ID.
        /// </summary>
        /// <param name="id">ID của bản ghi cần lấy.</param>
        /// <returns>Bản ghi đầu tiên tìm được, hoặc null nếu không có.</returns>
        public virtual object Get(string id)
        {
            ParamsId obj = new ParamsId { Id = id };
            var sqlPath = $"{TableName}/get_{TableName.ToLower()}";

            var list = ExecuteQuery<T, ParamsId>(sqlPath, obj);

            return list.FirstOrDefault();
        }

        /// <summary>
        /// Xóa một bản ghi khỏi database.
        /// </summary>
        /// <param name="data">Dữ liệu cần xóa, phải phù hợp với kiểu DeleteRequestBase.</param>
        /// <returns>Số lượng bản ghi bị xóa.</returns>
        public virtual int Delete(object data)
        {
            var sqlPath = $"{TableName}/delete_{TableName.ToLower()}";

            var result = ExecuteQuery<T, DeleteRequestBase>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }

        /// <summary>
        /// Thực thi truy vấn kiểu ExecuteScalar (trả về 1 giá trị duy nhất).
        /// </summary>
        /// <typeparam name="TParam">Kiểu của tham số đầu vào.</typeparam>
        /// <param name="sqlPath">Đường dẫn truy vấn SQL tương ứng.</param>
        /// <param name="data">Dữ liệu truyền vào (cần match kiểu TParam).</param>
        /// <returns>Giá trị trả về đầu tiên từ truy vấn hoặc null nếu lỗi.</returns>
        protected object? ExecuteScalar<TParam>(string sqlPath, object data)
        {
            if (data is not TParam model)
                return null;

            var db = Simulation.GetModel<DatabaseManager>();
            db.OpenConnection();

            var param = DatabaseHelper.ToDictionary(model);
            var result = db.ExecuteScalar(sqlPath, param);

            db.CloseConnection();

            return result;
        }

        /// <summary>
        /// Thực thi truy vấn kiểu ExecuteQuery (trả về danh sách bản ghi).
        /// </summary>
        /// <typeparam name="T">Kiểu bản ghi kết quả.</typeparam>
        /// <typeparam name="TParam">Kiểu tham số truyền vào.</typeparam>
        /// <param name="sqlPath">Đường dẫn file SQL.</param>
        /// <param name="data">Tham số truy vấn (nên đúng kiểu TParam).</param>
        /// <returns>Danh sách bản ghi kết quả hoặc danh sách rỗng nếu sai kiểu.</returns>
        protected List<T> ExecuteQuery<T, TParam>(string sqlPath, object data) where T : new()
        {
            if (data is not TParam model)
                return new List<T>();

            var db = Simulation.GetModel<DatabaseManager>();
            db.OpenConnection();

            var param = DatabaseHelper.ToDictionary(model);
            var dt = db.ExecuteQuery(sqlPath, param);

            db.CloseConnection();

            return DatabaseHelper.MapToList<T>(dt);
        }
    }
}
