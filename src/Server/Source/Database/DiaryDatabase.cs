using Server.Source.Data;

namespace Server.Source.Database
{
    public class DiaryDatabase: BaseDatabase<Diary>
    {
        private static DiaryDatabase _instance;
        private DiaryDatabase() { }

        public static DiaryDatabase Instance => _instance ??= new DiaryDatabase();

        protected override string TableName => "diary";
    }
}
