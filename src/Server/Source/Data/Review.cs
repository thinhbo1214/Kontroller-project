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

        public int Rating { get; set; }

        /// <summary>
        /// The date the review was created, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        /// 
        public string DateCreated { get; set; }

        public Guid Author { get; set; }

        public List<Guid> CommentId { get; set; }
        public int NumberComment { get; set; }

        public List<Guid> ReactionId { get; set; }

        public int NumberReaction { get; set; }

        public Review()
        {
            ReviewId = Guid.Empty;
            Content = "";
            Rating = 0;
            DateCreated = "";
            Author = Guid.Empty;
            NumberReaction = 0;
            NumberComment = 0;

            ReactionId = new List<Guid>();
            CommentId = new List<Guid>();
        }
    }
}
