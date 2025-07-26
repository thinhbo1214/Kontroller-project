using Server.Source.Data;
using Server.Source.Database;
using Server.Source.Interface;
using System.Data;
using System.Reflection;

namespace Server.Source.Helper
{
    public class DatabaseHelper
    {
        // Trả về IApiEvent thay vì Event gốc
        private readonly static Dictionary<Type, IDatabase> databaseMap = new()
        {
            { typeof(Account),  AccountDatabase.Instance },
            { typeof(Activity), ActivityDatabase.Instance },
            { typeof(Comment), CommentDatabase.Instance },
            { typeof(Diary), DiaryDatabase.Instance },
            { typeof(Game), GameDatabase.Instance },
            { typeof(List), ListDatabase.Instance },
            { typeof(Rate), RateDatabase.Instance },
            { typeof(Reaction), ReactionDatabase.Instance },
            { typeof(Review), ReviewDatabase.Instance },
            { typeof(User), UserDatabase.Instance },
        };
        public static T GetData<T>(string id)
        {
            T result = default;
            if (databaseMap.TryGetValue(typeof(T), out var database))
            {
                var data = database.Open(id);
                if (data is T typedData)
                {
                    result = typedData;
                }
            }
            return result;
        }
        public static void SetData<T>(T data)
        {
            if (databaseMap.TryGetValue(typeof(T), out var database))
            {
                database.Save(data);
            }
        }

        public static void DeleteData<T>(string id)
        {
            if (databaseMap.TryGetValue(typeof(T), out var database))
            {
                database.Delete(id);
            }
        }

        // Convert object (DTO, Model) => Dictionary<string, object>
        public static Dictionary<string, object> ToDictionary<T>(T obj)
        {
            var dict = new Dictionary<string, object>();
            foreach (var prop in typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance))
            {
                dict[prop.Name.StartsWith("@") ? prop.Name : "@" + prop.Name] = prop.GetValue(obj) ?? DBNull.Value;
            }
            return dict;
        }

        // Convert DataTable => List<T>
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
    }


}
/*
 Cách dùng:
1/🔍 Truy vấn dữ liệu
var dbManager = new DatabaseManager();
dbManager.OpenConnection();

var dataTable = dbManager.ExecuteQuery("users/get_all_users");
var userList = DatabaseHelper.MapToList<User>(dataTable); // Convert về List<User>

dbManager.CloseConnection();


2/💾 Insert/Update với object thay vì Dictionary

var dbManager = new DatabaseManager();
dbManager.OpenConnection();

var user = new User { UserName = "Minh Thuan", Age = 22 };
var param = DatabaseHelper.ToDictionary(user);

dbManager.ExecuteNonQuery("users/insert_user", param);

dbManager.CloseConnection();
 
 */

