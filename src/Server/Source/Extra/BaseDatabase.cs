using Server.Source.Core;
using Server.Source.Helper;
using Server.Source.Interface;
using Server.Source.Manager;

namespace Server.Source.Database
{
    public abstract class BaseDatabase<T> : IDatabase where T : class, new()
    {
        protected abstract string TableName { get; }

        public IDatabase GetInstance() => this;

        public virtual object Open(string id)
        {
            var db = Simulation.GetModel<DatabaseManager>();
            db.OpenConnection();

            var param = DatabaseHelper.ToDictionary(new { Id = id });
            var sqlPath = $"{TableName}/get_{TableName.ToLower()}_by_id";
            var dataTable = db.ExecuteQuery(sqlPath, param);

            db.CloseConnection();

            var list = DatabaseHelper.MapToList<T>(dataTable);
            return list.FirstOrDefault();
        }

        public virtual void Save(object data)
        {
            if (data is not T model)
                return;

            var db = Simulation.GetModel<DatabaseManager>();
            db.OpenConnection();

            var param = DatabaseHelper.ToDictionary(model);
            var sqlPath = $"{TableName}/save_{TableName.ToLower()}";
            db.ExecuteNonQuery(sqlPath, param);

            db.CloseConnection();
        }

        public virtual void Delete(string id)
        {
            var db = Simulation.GetModel<DatabaseManager>();
            db.OpenConnection();

            var param = DatabaseHelper.ToDictionary(new { Id = id });
            var sqlPath = $"{TableName}/delete_{TableName.ToLower()}_by_id";
            db.ExecuteNonQuery(sqlPath, param);

            db.CloseConnection();
        }
    }
}
