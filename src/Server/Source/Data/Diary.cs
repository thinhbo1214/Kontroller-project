namespace Server.Source.Data
{
    /// <summary>
    /// A personal log created by a user to record games they have played or want to track.
    /// </summary>
    public class Diary
    {
        /// <summary>
        /// Unique identifier for the diary entry.
        /// </summary>
        /// <example>'001'</example>
        public Guid DiaryId { get; set; }

        /// <summary>
        /// List of games associated with this diary entry.
        /// </summary>
        public List<Guid> GameLogged { get; set; }

        public int NumberGameLogged { get; set; }

        /// <summary>
        /// The date the diary entry was created or updated, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        public string DateLogged { get; set; }

        public Diary() 
        {
            DiaryId = Guid.Empty;
            DateLogged = "";
            NumberGameLogged = 0;

            GameLogged = new List<Guid>();
        }
    }
}
