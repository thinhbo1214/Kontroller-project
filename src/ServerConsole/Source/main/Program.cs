using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Threading.Tasks;

namespace ServerConsole.Source.main
{
    class Program
    {
        static void Main(string[] args)
        {
            var server = new Server();

            server.Run();           
        }
    }
}
