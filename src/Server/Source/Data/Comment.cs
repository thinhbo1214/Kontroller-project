using Microsoft.VisualBasic.ApplicationServices;

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
        /// The date the comment was created, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        public string CreatedAt { get; set; }

        public int NumberReaction { get; set; }

        /// <summary>
        /// The user who created the comment.
        /// </summary>
        public Guid UserId { get; set; }
        public string Username { get; set; }
        public string Avatar { get; set; }

        public Guid ReviewId { get; set; }

        public Comment() 
        {
            CommentId = Guid.Empty;
            Content = "";
            Username = "";
            Avatar = "";
            UserId = Guid.Empty;
            CreatedAt = "";
            NumberReaction = 0;
            ReviewId = Guid.Empty;
        }
    }
}
