using Microsoft.Data.Sql;
using Microsoft.Data.SqlClient;
using System.Data;

    

string connectionString = $"Server=MSSQLSERVER;Database=master;User Id=sa;Password=svcntt;TrustServerCertificate=True;";
try
{
    using (var connection = new SqlConnection(connectionString))
    {
        connection.Open();
        Console.WriteLine("Thành công");
    }
}
catch
{
    Console.WriteLine("Thành công");
}