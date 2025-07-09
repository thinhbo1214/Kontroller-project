using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Data
{
    /// <summary>
    /// A user reaction that records a specific response to review or comment in the system.
    /// </summary>
    public class Reaction
    {
        /// <summary>
        /// Unique identifier for the reaction.
        /// </summary>
        public string reactId;

        /// <summary>
        /// URL of the reaction type, such as an emoji or icon representing the reaction.
        /// </summary>
        public string reactionType;

        /// <summary>
        /// The user who performed the reaction.
        /// </summary>
        public User author;

        /// <summary>
        /// The date the reaction was performed, in YYYY-MM-DD format.
        /// </summary>
        public string dateDo;

        public Reaction()
        {
            reactId = "";
            reactionType = "";
            author = new User();
            dateDo = "";
        }
    }
}
