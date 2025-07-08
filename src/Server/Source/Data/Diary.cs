using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Data
{
    /// <summary>
    /// A personal log created by a user to record games they have played or want to track.
    /// </summary>
    public class Diary
    {
        /// <summary>
        /// Unique identifier for the diary entry.
        /// </summary>
        /// <example>'001'</example>
        public string diaryId;

        /// <summary>
        /// List of games associated with this diary entry.
        /// </summary>
        public List<Game> gameLogged;

        /// <summary>
        /// The date the diary entry was created or updated, in YYYY-MM-DD format.
        /// </summary>
        /// <example>'2023-10-01'</example>
        public string dateLogged;

        public Diary() 
        {
            diaryId = "";
            gameLogged = new List<Game>();
            dateLogged = "";
        }
    }
}
