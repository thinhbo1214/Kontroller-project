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
        public string reactId;

        /// <summary>
        /// URL of the reaction type, such as an emoji or icon representing the reaction.
        /// </summary>
        /// <example>'https://example.com/reaction.png'</example>
        public string reactionType;

        /// <summary>
        /// The user who performed the reaction.
        /// </summary>
        public User author;

        /// <summary>
        /// The date the reaction was performed, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        public string dateDo;

        public Reaction()
        {
            reactId = "";
            reactionType = "";
            author = new User();
            dateDo = "";
        }
    }
}
