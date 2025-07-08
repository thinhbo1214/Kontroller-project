using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Data
{
    /// <summary>
    /// A rating given by a user to a game, typically on a scale from 1 to 10.
    /// </summary>
    public class Rate
    {
        /// <summary>
        /// Unique identifier for the rating.
        /// </summary>
        /// <example>'001'</example>
        public string rateId;

        /// <summary>
        /// Numeric score representing the user's rating of the game (1 to 10).
        /// </summary>
        /// <example>8</example>
        public int value;

        /// <summary>
        /// The user who submitted the rating.
        /// </summary>
        public User rater;

        /// <summary>
        /// The game that is being rated.
        /// </summary>
        public Game target;

        public Rate()
        {
            rateId = "";
            value = 0;
            rater = new User();
            target = new Game();
        }
    }
}
