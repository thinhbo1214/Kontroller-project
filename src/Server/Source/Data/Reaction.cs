using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Data
{
    public class Reaction
    {
        public string reactId;
        public string reactionType;
        public User author;
        public string dateCreated;

        public Reaction()
        {
            reactId = "";
            reactionType = "";
            author = new User();
            dateCreated = "";
        }
    }
}
