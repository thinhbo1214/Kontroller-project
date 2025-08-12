using System;
using System.Data;
using Microsoft.Data.SqlClient;
using System.Net;
using System.Net.NetworkInformation;
using System.Threading.Tasks;

static string TryAutoConnect(string database, string user, string password, string defaultIp)
{
    // 3. Quét LAN
    string baseSubnet = GetLocalSubnet(); // ví dụ: "192.168.1"
    if (baseSubnet != null)
    {
        Console.WriteLine($"🔍 Đang quét subnet {baseSubnet}.x ...");

        for (int i = 1; i <= 254; i++)
        {
            string ip = $"{baseSubnet}.{i}";
            if (ip == defaultIp) continue;

            string conn = $"Server={ip};Database={database};User Id={user};Password={password};TrustServerCertificate=True;";

            if (TestConnection(conn))
                return conn;
        }
    }
    // 1. Thử localhost
    if (TestConnection($"Server=localhost;Database={database};Integrated Security=True;TrustServerCertificate=True;"))
        return $"Server=localhost;Database={database};Integrated Security=True;TrustServerCertificate=True;";

    // 2. Thử IP default
    if (TestConnection($"Server={defaultIp};Database={database};User Id={user};Password={password};TrustServerCertificate=True;"))
        return $"Server={defaultIp};Database={database};User Id={user};Password={password};TrustServerCertificate=True;";

    

    return null; // không tìm thấy
}

static bool TestConnection(string connectionString)
{
    try
    {
        using (var conn = new SqlConnection(connectionString))
        {
            // Timeout 1 giây để test nhanh
            conn.ConnectionTimeout.Equals(1); // thuộc tính readonly → dùng cách khác
            var builder = new SqlConnectionStringBuilder(connectionString)
            {
                ConnectTimeout = 1
            };
            using (var testConn = new SqlConnection(builder.ConnectionString))
            {
                testConn.Open();
            }
        }
        Console.WriteLine($"✅ Thành công: {connectionString}");
        return true;
    }
    catch
    {
        Console.WriteLine($"❌ Thất bại: {connectionString}");
        return false;
    }
}

static string GetLocalSubnet()
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

string database = "KontrollerDB";
string user = "sa";
string password = "svcntt";
string defaultIp = "192.168.1.25"; // IP default của máy SQL Server

string connectionString = TryAutoConnect(database, user, password, defaultIp);
if (connectionString != null)
{
    Console.WriteLine($"✅ Kết nối thành công! Connection string: {connectionString}");
}
else
{
    Console.WriteLine("❌ Không tìm thấy SQL Server nào khả dụng.");
}