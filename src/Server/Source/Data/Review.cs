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
        public string reviewId;

        /// <summary>
        /// The main body of the review written by the user.
        /// </summary>
        /// <example>'This is a review.'</example>
        public string content;

        /// <summary>
        /// The date the review was created, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        /// 
        public string dateCreated;
        public Review()
        {
            reviewId = "";
            content = "";
            dateCreated = "";
        }
    }
}
