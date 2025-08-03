using Newtonsoft.Json.Linq;
using Server.Source.Core;
using Server.Source.Helper;
using Server.Source.Interface;
using Server.Source.Manager;
using Server.Source.Extra;

namespace Server.Source.Database
{
    public abstract class BaseDatabase<T> : IDatabase where T : class, new()
    {
        protected abstract string TableName { get; }

        public IDatabase GetInstance() => this;


        public virtual object Get(string id)
        {

            ParamsId obj = new ParamsId { Id = id };
            var sqlPath = $"{TableName}/get_{TableName.ToLower()}";

            var list = ExecuteQuery<T, ParamsId>(sqlPath, obj);

            return list.FirstOrDefault();
        }

        public virtual int Delete(object data)
        {
            var sqlPath = $"{TableName}/delete_{TableName.ToLower()}";

            var result = ExecuteQuery<T, DeleteRequestBase>(sqlPath, data);

            return DatabaseHelper.GetScalarValue<int>(result);
        }

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

        protected List<T> ExecuteQuery<T, TParam>(string sqlPath, object data) where T : new()
        {
            if (data is not TParam model)
                return new List<T>(); // hoặc return null tùy bạn muốn an toàn thế nào

            var db = Simulation.GetModel<DatabaseManager>();
            db.OpenConnection();

            var param = DatabaseHelper.ToDictionary(model);
            var dt = db.ExecuteQuery(sqlPath, param);

            db.CloseConnection();

            return DatabaseHelper.MapToList<T>(dt);
        }
    }

 }
