namespace Server.Source.Data
{
    /// <summary>
    /// A user reaction that records a specific response to review or comment in the system.
    /// </summary>
    public class Reaction
    {
        /// <summary>
        /// Unique identifier for the reaction.
        /// </summary>
        /// <example>'001'</example>
        public string ReactionId { get; set; }

        /// <summary>
        /// URL of the reaction type, such as an emoji or icon representing the reaction.
        /// </summary>
        /// <example>0-4</example>
        public int ReactionType { get; set; }

        /// <summary>
        /// The user who performed the reaction.
        /// </summary>
        public Guid Author { get; set; }

        /// <summary>
        /// The date the reaction was performed, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        public string DateDo { get; set; }

        public Reaction()
        {
            ReactionId = "";
            ReactionType = 0;
            Author = Guid.Empty;
            DateDo = "";
        }
    }
}
