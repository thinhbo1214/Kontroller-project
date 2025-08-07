namespace Server.Source.Data
{
    /// <summary>
    /// A rating given by a user to a game, typically on a scale from 1 to 10.
    /// </summary>
    public class Rate
    {
        /// <summary>
        /// Unique identifier for the rating.
        /// </summary>
        /// <example>'001'</example>
        public Guid RateId { get; set; }

        /// <summary>
        /// Numeric score representing the user's rating of the game (1 to 10).
        /// </summary>
        /// <example>8</example>
        public int Value { get; set; }

        /// <summary>
        /// The user who submitted the rating.
        /// </summary>
        public Guid Rater { get; set; }

        /// <summary>
        /// The game that is being rated.
        /// </summary>
        public Guid Target { get; set; }

        public Rate()
        {
            RateId = Guid.Empty;
            Value = 0;
            Rater = Guid.Empty;
            Target = Guid.Empty;
        }
    }
}
