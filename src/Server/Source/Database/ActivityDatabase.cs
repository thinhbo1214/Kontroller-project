using Server.Source.Data;

namespace Server.Source.Database
{
    public class ActivityDatabase: BaseDatabase<Activity>
    {
        private static ActivityDatabase _instance;

        // private constructor để ngăn việc tạo mới từ bên ngoài
        private ActivityDatabase(){}

        public static ActivityDatabase Instance => _instance ??= new ActivityDatabase();

        protected override string TableName => "activity";
    }
}
