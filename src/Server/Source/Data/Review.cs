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
        /// The user who wrote the review.
        /// </summary>
        public User author;

        /// <summary>
        /// The rating score associated with the review.
        /// </summary>
        public Rate rating;

        /// <summary>
        /// List of comments made by other users in response to the review.
        /// </summary>
        public List<Comment> comments;

        /// <summary>
        /// The date the review was created, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        public string dateCreated;

        /// <summary>
        ///  Number of reaction this review has received from other users
        /// </summary>
        public Reaction reaction;

        public Review()
        {
            reviewId = "";
            content = "";
            author = new User();
            rating = new Rate();
            comments = new List<Comment>();
            dateCreated = "";
            reaction = new Reaction();
        }
    }
}
