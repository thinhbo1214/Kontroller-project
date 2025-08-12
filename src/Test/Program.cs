using System;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Net;
using System.Net.NetworkInformation;
using System.Threading.Tasks;

using Microsoft.Data.SqlClient;
using Server.Source.Core;
using Server.Source.Manager;
using System;
using System.Data;
using System.Net;
using System.Net.NetworkInformation;
using System.Threading.Tasks;


string GetLocalSubnet()
{
    foreach (NetworkInterface ni in NetworkInterface.GetAllNetworkInterfaces())
    {
        if (ni.OperationalStatus == OperationalStatus.Up &&
            ni.NetworkInterfaceType != NetworkInterfaceType.Loopback)
        {
            foreach (UnicastIPAddressInformation ip in ni.GetIPProperties().UnicastAddresses)
            {
                if (ip.Address.AddressFamily == System.Net.Sockets.AddressFamily.InterNetwork)
                {
                    string[] parts = ip.Address.ToString().Split('.');
                    if (parts.Length == 4)
                    {
                        return $"{parts[0]}.{parts[1]}.{parts[2]}";
                    }
                }
            }
        }
    }
    return null;
}

async Task<string> TryAutoConnectAsync(string database, string user, string password, string defaultIp)
{
    // Thử localhost
    string localConn = $"Server=localhost;Database={database};Integrated Security=True;TrustServerCertificate=True;";
    if (await TestConnectionAsync(localConn))
        return localConn;

    // Thử IP default
    string defaultConn = $"Server={defaultIp};Database={database};User Id={user};Password={password};TrustServerCertificate=True;";
    if (await TestConnectionAsync(defaultConn))
        return defaultConn;

    // Quét LAN (song song)
    string baseSubnet = GetLocalSubnet();
    if (baseSubnet != null)
    {
        Console.WriteLine($"🔍 Đang quét subnet {baseSubnet}.x ...", LogLevel.INFO, LogSource.SYSTEM);
        var tasks = new List<Task<(string, bool)>>();
        for (int i = 1; i <= 254; i++) // Giới hạn quét
        {
            string ip = $"{baseSubnet}.{i}";
            if (ip == defaultIp) continue;
            string conn = $"Server={ip};Database={database};User Id={user};Password={password};TrustServerCertificate=True;";
            tasks.Add(TestConnectionWithResultAsync(conn));
        }

        var results = await Task.WhenAll(tasks);
        foreach (var result in results)
        {
            if (result.Item2)
                return result.Item1;
        }
    }

    return null;
}
async Task<(string, bool)> TestConnectionWithResultAsync(string connectionString)
{
    bool success = await TestConnectionAsync(connectionString);
    return (connectionString, success);
}

async Task<bool> TestConnectionAsync(string connectionString)
{
    try
    {
        var builder = new SqlConnectionStringBuilder(connectionString)
        {
            ConnectTimeout = 1
        };
        using (var conn = new SqlConnection(builder.ConnectionString))
        {
            await conn.OpenAsync();
        }
        Console.WriteLine($"✅ Thành công: {connectionString}", LogLevel.INFO, LogSource.SYSTEM);
        return true;
    }
    catch
    {
        Console.WriteLine($"❌ Thất bại: {connectionString}", LogLevel.ERROR, LogSource.SYSTEM);
        return false;
    }
}

string database = "KontrollerDB";
string user = "admin";
string password = "Admin@321";
string defaultIp = "192.168.1.25"; // IP default của máy SQL Server

string _connectionString = Task.Run(() => TryAutoConnectAsync(database, user, password, defaultIp)).Result;

if (_connectionString == null)
{
    Console.WriteLine($"❌ Thất bại");
}

while (true) ;


