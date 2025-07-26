namespace Server.Source.Data
{
    /// <summary>
    /// A user-defined collection of games, typically grouped by theme, preference, or custom purpose.
    /// </summary>
    public class List
    {
        /// <summary>
        /// Unique identifier for the list.
        /// </summary>
        /// <example>'001'</example>
        public string listId;

        /// <summary>
        /// The name or title of the list created by the user.
        /// </summary>
        /// <example>'My Favorite Games'</example>
        public string name;

        /// <summary>
        /// A short explanation of what the list contains or why it was created.
        /// </summary>
        /// <example>'A collection of my favorite games.'</example>
        public string description;

        /// <summary>
        /// Array of games included in this list.
        /// </summary>
        public List<Game> games;

        /// <summary>
        /// The date the list was created, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        public string dateCreated;

        public List()
        {
            listId = "";
            name = "";
            description = "";
            games = new List<Game>();
            dateCreated = "";
        }
    }
}
