namespace Server.Source.Data
{
    /// <summary>
    /// A written review by a user that includes their thoughts and rating for a game.
    /// </summary>
    public class Review
    {
        /// <summary>
        /// Unique identifier for the review.
        /// </summary>
        /// <example>'001'</example>
        public Guid ReviewId { get; set; }

        /// <summary>
        /// The main body of the review written by the user.
        /// </summary>
        /// <example>'This is a review.'</example>
        public string Content { get; set; }

        /// <summary>
        /// The date the review was created, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        /// 
        public string DateCreated { get; set; }
        public Review()
        {
            ReviewId = Guid.Empty;
            Content = "";
            DateCreated = "";
        }
    }
}
