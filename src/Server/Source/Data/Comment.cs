namespace Server.Source.Data
{
    /// <summary>
    /// A comment made by a user on a review, typically used for feedback or discussion.
    /// </summary>
    public class Comment
    {
        /// <summary>
        /// Unique identifier for the comment.
        /// </summary>
        /// <example>'001'</example>
        public string commentId;

        /// <summary>
        /// The content of the comment.
        /// </summary>
        /// <example>'This is a comment.'</example>
        public string content;

        /// <summary>
        /// The user who created the comment.
        /// </summary>
        public User author;

        /// <summary>
        /// The date the comment was created, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        public string dateCreated;

        /// <summary>
        /// Number of reactions the comment received from other users.
        /// </summary>
        public List<Reaction> reactions;

        public Comment() 
        {
            commentId = "";
            content = "";
            author = new User();
            dateCreated = "";
            reactions = new List<Reaction>();
        }
    }
}
