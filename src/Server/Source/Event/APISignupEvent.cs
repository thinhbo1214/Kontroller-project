using Server.Source.Core;
using Server.Source.NetCoreServer;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Server.Source.Event
{
    public class APISignupEvent: Simulation.Event<APISignupEvent>
    {
        public HttpRequest request { get; set; }
        public HttpsSession session { get; set; }
        public override void Execute()
        {

        }
    }
}
