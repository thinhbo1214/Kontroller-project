using Microsoft.Data.SqlClient;

string _connectionString = "Server=localhost;Database=KontrollerDB;Integrated Security=True;TrustServerCertificate=True;";

using var conn = new SqlConnection(_connectionString);
try
{
    conn.Open();
    Console.WriteLine("✅ Kết nối thành công!");
}
catch (Exception ex)
{
    Console.WriteLine("❌ Lỗi khi kết nối: " + ex.Message);
}
