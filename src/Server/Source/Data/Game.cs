namespace Server.Source.Data
{
    /// <summary>
    /// Represents a video game with descriptive metadata, user reviews, and media assets.
    /// </summary>
    public class Game
    {
        /// <summary>
        /// Unique identifier for the game.
        /// </summary>
        /// <example>'001'</example>
        public Guid GameId { get; set; }

        /// <summary>
        /// The title or name of the game.
        /// </summary>
        /// <example>'Minecraft'</example>
        public string Title { get; set; }

        /// <summary>
        /// A brief summary of the game's content, genre, or storyline.
        /// </summary>
        /// <example>'A sandbox video game developed by Mojang Studios.'</example>
        public string Descriptions { get; set; }

        /// <summary>
        /// The genre or category of the game (e.g., Adventure, RPG, Action).
        /// </summary>
        /// <example>'Adventure'</example>
        public string Genre { get; set; }

        /// <summary>
        /// List of reviews written by users about this game.
        /// </summary>
        public List<Guid> Review { get; set; }

        public int NumberReview { get; set; }

        /// <summary>
        /// The average rating score for the game based on user reviews (scale 1-10).
        /// </summary>
        /// <example>4.5</example>
        public float AvgRating { get; set; }

        /// <summary>
        /// URL of the game's poster image, typically used in listings.
        /// </summary> 
        /// <example>'https://example.com/poster.jpg'</example>
        public string Poster { get; set; }

        /// <summary>
        /// URL of a backdrop image used in game detail pages.
        /// </summary>
        /// <example>'https://example.com/backdrop.jpg'</example>
        public string Backdrop { get; set; }

        /// <summary>
        /// Additional details about the game including studios, countries and languages.
        /// </summary>
        /// <example>'Nintendo, Japan, Languages supported: English, Japanese, Spanish'</example>
        public string Details { get; set; }

        /// <summary>
        /// List of platforms or digital stores where the game is available.
        /// </summary>
        /// <example> 'Steam','Epic Games Store'</example>
        public List<string> Services { get; set; }

        public Game() 
        {
            GameId = Guid.Empty;
            Title = "";
            Descriptions = "";
            Genre = "";
            NumberReview = 0;
            AvgRating = 0;
            Poster = "";
            Backdrop = "";
            Details = "";

            Review = new List<Guid>();
            Services = new List<string>();
        }
    }
}
