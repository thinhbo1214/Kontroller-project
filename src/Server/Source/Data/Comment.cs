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
        public Guid CommentId { get; set; }

        /// <summary>
        /// The content of the comment.
        /// </summary>
        /// <example>'This is a comment.'</example>
        public string Content { get; set; }

        /// <summary>
        /// The user who created the comment.
        /// </summary>
        public Guid Author { get; set; }

        /// <summary>
        /// The date the comment was created, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        public string DateCreated { get; set; }

        /// <summary>
        /// Number of reactions the comment received from other users.
        /// </summary>
        public List<Guid> Reactions { get; set; }

        public Comment() 
        {
            CommentId = Guid.Empty;
            Content = "";
            Author = Guid.Empty;
            DateCreated = "";
            Reactions = new List<Guid>();
        }
    }
}
