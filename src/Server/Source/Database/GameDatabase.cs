using Server.Source.Data;
using Server.Source.Extra;
using Server.Source.Helper;

namespace Server.Source.Database
{
    public class GameDatabase: BaseDatabase<Game>
    {
        private static GameDatabase _instance;
        private GameDatabase() { }

        public static GameDatabase Instance => _instance ??= new GameDatabase();

        protected override string TableName => "game";

        public virtual List<Game> GetGamePagination(object data)
        {
            var sqlPath = $"{TableName}/get_game_pagination";
            var result = ExecuteQuery<Game, PaginateParams>(sqlPath, data);

            return result;
        }

        public virtual List<Game> GetGameByUser(object data)
        {
            var sqlPath = $"{TableName}/get_game_by_user";
            var result = ExecuteQuery<Game, UserIdParams>(sqlPath, data);

            return result;
        }
    }
}
