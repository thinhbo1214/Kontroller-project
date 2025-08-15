using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Database;
using Server.Source.Interface;
using Server.Source.Manager;
using System.Data;
using System.Reflection;

namespace Server.Source.Helper
{
    /// <summary>
    /// Cung cấp các hàm trợ giúp chuẩn hóa thao tác với database:
    /// - Truy xuất/xóa dữ liệu theo kiểu
    /// - Chuyển đổi object sang Dictionary phục vụ cho SQL
    /// - Map DataTable về List hoặc object
    /// - Chuyển đổi giá trị đơn kiểu an toàn
    /// </summary>
    public class DatabaseHelper
    {
        /// <summary>
        /// Map giữa kiểu dữ liệu và instance database tương ứng
        /// </summary>
        private readonly static Dictionary<Type, IDatabase> databaseMap = new()
        {
            { typeof(Account),  AccountDatabase.Instance },
            { typeof(Comment), CommentDatabase.Instance },
            { typeof(Game), GameDatabase.Instance },
            { typeof(Reaction), ReactionDatabase.Instance },
            { typeof(Review), ReviewDatabase.Instance },
            { typeof(User), UserDatabase.Instance },
        };

        /// <summary>
        /// Lấy dữ liệu từ database theo id và kiểu dữ liệu
        /// </summary>
        public static T GetData<T>(string id)
        {
            T result = default;
            if (databaseMap.TryGetValue(typeof(T), out var database))
            {
                var data = database.Get(id);
                if (data is T typedData)
                {
                    result = typedData;
                }
            }
            return result;
        }

        /// <summary>
        /// Xóa dữ liệu từ database theo id và kiểu dữ liệu
        /// </summary>
        public static int DeleteData<T>(object data)
        {
            if (databaseMap.TryGetValue(typeof(T), out var database))
            {
                return database.Delete(data);
            }

            return 0;
        }

        /// <summary>
        /// Chuyển object thành Dictionary với tên cột và giá trị (hỗ trợ prefix @ cho tên)
        /// </summary>
        //public static Dictionary<string, object> ToDictionary<T>(T obj)
        //{
        //    var dict = new Dictionary<string, object>();
        //    foreach (var prop in typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance))
        //    {
        //        dict[prop.Name.StartsWith("@") ? prop.Name : "@" + prop.Name] = prop.GetValue(obj) ?? DBNull.Value;
        //    }
        //    return dict;
        //}
        public static Dictionary<string, object> ToDictionary<T>(T obj)
        {
            var dict = new Dictionary<string, object>();
            foreach (var prop in obj.GetType().GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                dict[prop.Name.StartsWith("@") ? prop.Name : "@" + prop.Name] = prop.GetValue(obj) ?? DBNull.Value;
            }
            return dict;
        }

        /// <summary>
        /// Chuyển JSON thành Dictionary với tên cột có prefix @ và xử lý null
        /// </summary>
        public static Dictionary<string, object> JsonToParameterDictionary(string json, string parameterName = "@JsonData")
        {
            var dict = new Dictionary<string, object>();
            dict[parameterName] = string.IsNullOrEmpty(json) ? DBNull.Value : json;
            return dict;
        }

        /// <summary>
        /// Chuyển mảng tham số (tuple name-value) thành Dictionary có prefix @
        /// </summary>
        public static Dictionary<string, object> ToParameterDictionary(params (string name, object value)[] parameters)
        {
            var dict = new Dictionary<string, object>();
            foreach (var (name, value) in parameters)
            {
                dict[name.StartsWith("@") ? name : "@" + name] = value ?? DBNull.Value;
            }
            return dict;
        }

        /// <summary>
        /// Chuyển Dictionary input thành Dictionary có prefix @ và xử lý null
        /// </summary>
        public static Dictionary<string, object> ToParameterDictionary(Dictionary<string, object> input)
        {
            return input.ToDictionary(
                kvp => kvp.Key.StartsWith("@") ? kvp.Key : "@" + kvp.Key,
                kvp => kvp.Value ?? DBNull.Value
            );
        }

        /// <summary>
        /// Chuyển đổi DataTable thành danh sách đối tượng T
        /// </summary>
        public static List<T> MapToList<T>(DataTable dt) where T : new()
        {
            var properties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            var list = new List<T>();

            foreach (DataRow row in dt.Rows)
            {
                T obj = new T();

                foreach (var prop in properties)
                {
                    if (dt.Columns.Contains(prop.Name) && row[prop.Name] != DBNull.Value)
                    {
                        prop.SetValue(obj, Convert.ChangeType(row[prop.Name], prop.PropertyType));
                    }
                }

                list.Add(obj);
            }

            return list;
        }

        /// <summary>
        /// Lấy giá trị đơn từ object đầu vào, trả về kiểu T hoặc giá trị mặc định nếu lỗi
        /// </summary>
        public static T? GetScalarValue<T>(object? value, T? defaultValue = default)
        {
            try
            {
                if (value == null || value == DBNull.Value) return defaultValue;

                if (typeof(T) == typeof(string))
                    return (T)(object)value.ToString();

                return (T)Convert.ChangeType(value, typeof(T));
            }
            catch
            {
                return defaultValue;
            }
        }

        /// <summary>
        /// Lấy phần tử đầu tiên từ DataTable đã map về kiểu T (hoặc null nếu không có)
        /// </summary>
        public static T? MapToSingle<T>(DataTable dt) where T : new()
        {
            return MapToList<T>(dt).FirstOrDefault();
        }

        public static List<T> MapPrimitiveList<T>(DataTable table)
        {
            List<T> list = new List<T>();
            foreach (DataRow row in table.Rows)
            {
                if (row[0] != DBNull.Value)
                {
                    list.Add((T)Convert.ChangeType(row[0], typeof(T)));
                }
            }
            return list;
        }
    }
}
