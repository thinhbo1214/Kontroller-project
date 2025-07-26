using Server.Source.Data;

namespace Server.Source.Database
{
    public class GameDatabase: BaseDatabase<Game>
    {
        private static GameDatabase _instance;
        private GameDatabase() { }

        public static GameDatabase Instance => _instance ??= new GameDatabase();

        protected override string TableName => "game";
    }
}
