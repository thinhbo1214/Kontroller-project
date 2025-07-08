using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

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
        public string gameId;

        /// <summary>
        /// The title or name of the game.
        /// </summary>
        /// <example>'Minecraft'</example>
        public string title;

        /// <summary>
        /// A brief summary of the game's content, genre, or storyline.
        /// </summary>
        /// <example>'A sandbox video game developed by Mojang Studios.'</example>
        public string description;

        /// <summary>
        /// The genre or category of the game (e.g., Adventure, RPG, Action).
        /// </summary>
        /// <example>'Adventure'</example>
        public string genre;

        /// <summary>
        /// List of reviews written by users about this game.
        /// </summary>
        public List<Review> review;

        /// <summary>
        /// The average rating score for the game based on user reviews (scale 1-10).
        /// </summary>
        /// <example>4.5</example>
        public float avgRating;

        /// <summary>
        /// URL of the game's poster image, typically used in listings.
        /// </summary> 
        /// <example>'https://example.com/poster.jpg'</example>
        public string poster;

        /// <summary>
        /// URL of a backdrop image used in game detail pages.
        /// </summary>
        /// <example>'https://example.com/backdrop.jpg'</example>
        public string backdrop;

        /// <summary>
        /// Additional details about the game including studios, countries and languages.
        /// </summary>
        /// <example>'Nintendo, Japan, Languages supported: English, Japanese, Spanish'</example>
        public string details;

        /// <summary>
        /// List of platforms or digital stores where the game is available.
        /// </summary>
        /// <example> 'Steam','Epic Games Store'</example>
        public List<string> services;

        public Game() 
        {
            gameId = "";
            title = "";
            description = "";
            genre = "";
            review = new List<Review>();
            avgRating = 0;
            poster = "";
            backdrop = "";
            details = "";
            services = new List<string>();
        }
    }
}
