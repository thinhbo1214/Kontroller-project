using Microsoft.VisualBasic.ApplicationServices;

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

        public int NumberComment { get; set; }

        public int NumberReaction { get; set; }
        public Guid UserId { get; set; }

        public string Username { get; set; }
        public string Avatar { get; set; }

        public Guid GameId { get; set; }
        public string Poster { get; set; }
        public string Backdrop { get; set; }
        public string Title { get; set; }
        public float AvgRating { get; set; }

        public Review()
        {
            //ReviewId = Guid.Empty;
            //Content = "";
            //Rating = 0;
            //DateCreated = "";
            //NumberReaction = 0;
            //NumberComment = 0;

            //Username = "";
            //Avatar = "";
            //UserId = Guid.Empty;

            //GameId = Guid.Empty;
            //Title = "";
            //AvgRating = 0;

        }
    }
}
