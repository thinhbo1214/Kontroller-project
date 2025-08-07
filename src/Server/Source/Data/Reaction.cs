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
        public string ReactId { get; set; }

        /// <summary>
        /// URL of the reaction type, such as an emoji or icon representing the reaction.
        /// </summary>
        /// <example>'https://example.com/reaction.png'</example>
        public string ReactionType { get; set; }

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
            ReactId = "";
            ReactionType = "";
            Author = Guid.Empty;
            DateDo = "";
        }
    }
}
