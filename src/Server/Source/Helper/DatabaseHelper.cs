using Server.Source.Core;
using Server.Source.Data;
using Server.Source.Database;
using Server.Source.Interface;
using Server.Source.Manager;
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
                var data = database.Get(id);
                if (data is T typedData)
                {
                    result = typedData;
                }
            }
            return result;
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

        //public static Dictionary<string, object> ToDictionary(object obj)
        //{
        //    var dict = new Dictionary<string, object>();
        //    var type = obj.GetType();

        //    foreach (var prop in type.GetProperties(BindingFlags.Public | BindingFlags.Instance))
        //    {
        //        dict[prop.Name.StartsWith("@") ? prop.Name : "@" + prop.Name] = prop.GetValue(obj) ?? DBNull.Value;
        //    }

        //    return dict;
        //}


        /*Cách dùng VD: 
         var parameters = ToParameterDictionary(
            ("Username", "admin"),
            ("Password", "123456"),
            ("Email", DBNull.Value)
        );
         */
        public static Dictionary<string, object> ToParameterDictionary(params (string name, object value)[] parameters)
        {
            var dict = new Dictionary<string, object>();
            foreach (var (name, value) in parameters)
            {
                dict[name.StartsWith("@") ? name : "@" + name] = value ?? DBNull.Value;
            }
            return dict;
        }


        /* Cách dùng VD:
         var parameters = ToParameterDictionary(new Dictionary<string, object>
        {
            ["Username"] = "admin",
            ["Password"] = "123456"
        });
         */
        public static Dictionary<string, object> ToParameterDictionary(Dictionary<string, object> input)
        {
            return input.ToDictionary(
                kvp => kvp.Key.StartsWith("@") ? kvp.Key : "@" + kvp.Key,
                kvp => kvp.Value ?? DBNull.Value
            );
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


        public static T? MapToSingle<T>(DataTable dt) where T : new()
        {
            return MapToList<T>(dt).FirstOrDefault();
        }


    }


}

