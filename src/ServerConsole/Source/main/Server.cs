using NetCoreServer;
using System;
using System.Collections.Concurrent;
using System.Net;
using System.Net.Sockets;
using System.Security.Authentication;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Xml;

namespace ServerConsole.Source.main
{
    class Server
    {
        string certificate;
        string password;
        int port;
        string www;
        SslContext context;
        HttpsCacheServer server;

        public Server()
        {
            certificate = Path.Combine(AppContext.BaseDirectory, @"..\..\..\tools\certificates\server.pfx");
            password = "qwerty";

            // HTTPS server port
            port = 8443;

            // HTTPS server content path
            www = Path.Combine(AppContext.BaseDirectory, @"../../../www/ClientWeb");

            // Create and prepare a new SSL server context
            context = new SslContext(SslProtocols.Tls13, new X509Certificate2(certificate, password));

            // Create a new HTTP server
            server = new HttpsCacheServer(context, IPAddress.Any, port);
            server.AddStaticContent(www, "/api");
        }

        public void Run()
        {
            Console.WriteLine($"HTTPS server port: {port}");
            Console.WriteLine($"HTTPS server static content path: {www}");
            Console.WriteLine($"HTTPS server website: https://localhost:{port}/api/index.html");

            Console.WriteLine();

            // Start the server
            Console.Write("Server starting...");
            server.Start();
            Console.WriteLine("Done!");

            Console.WriteLine("Press Enter to stop the server or '!' to restart the server...");

            // Perform text input
            for (; ; )
            {
                string line = Console.ReadLine();
                if (string.IsNullOrEmpty(line))
                    break;

                // Restart the server
                if (line == "!")
                {
                    Console.Write("Server restarting...");
                    server.Restart();
                    Console.WriteLine("Done!");
                }
            }

            // Stop the server
            Console.Write("Server stopping...");
            server.Stop();
            Console.WriteLine("Done!");
        }
    }
}
