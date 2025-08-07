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
        public Guid ListId { get; set; }

        /// <summary>
        /// The name or title of the list created by the user.
        /// </summary>
        /// <example>'My Favorite Games'</example>
        public string Name { get; set; }

        /// <summary>
        /// A short explanation of what the list contains or why it was created.
        /// </summary>
        /// <example>'A collection of my favorite games.'</example>
        public string Description { get; set; }

        /// <summary>
        /// Array of games included in this list.
        /// </summary>
        public List<Guid> Games { get; set; }

        /// <summary>
        /// The date the list was created, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        public string DateCreated { get; set; }

        public List()
        {
            ListId = Guid.Empty;
            Name = "";
            Description = "";
            Games = new List<Guid>();
            DateCreated = "";
        }
    }
}
