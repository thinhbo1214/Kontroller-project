using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Threading.Tasks;
using Microsoft.Data.SqlClient;
using Server.Source.Helper;


namespace Server.Source.Manager
{
    public class DatabaseManager
    {
        private readonly string _basePath; // Nơi chứa thư mục gốc chứa file sql
        private readonly string _connectionString;

        /// <summary>
        /// Cache sql: key -> câu lệnh sql, key dạng "folder/file" hoặc "file"
        /// </summary>
        private readonly Dictionary<string, string> _sqlCache = new Dictionary<string, string>();

        /// <summary>
        /// Dùng để kiểm tra file thay đổi hay chưa
        /// </summary>
        private readonly Dictionary<string, DateTime> _fileLastWriteTime = new Dictionary<string, DateTime>();

        private SqlConnection? _connection;
        public void StartSqlService(string serviceName = "MSSQLSERVER")
        {
            ServiceHelper.RunServiceCommand(serviceName, "start");
        }

        public void StopSqlService(string serviceName = "MSSQLSERVER")
        {
            ServiceHelper.RunServiceCommand(serviceName, "stop");
        }
        public DatabaseManager(string basePath, string connectionString)
        {
            _basePath = basePath ?? throw new ArgumentNullException(nameof(basePath));
            _connectionString = connectionString ?? throw new ArgumentNullException(nameof(connectionString));
        }
        public DatabaseManager()
        {
            //certificate = Path.Combine(AppContext.BaseDirectory, @"..\..\..\tools\certificates\server.pfx");
            _basePath = Path.Combine(AppContext.BaseDirectory, "MyServerData");
            _connectionString = "Server=localhost;Database=MyDatabase;Integrated Security=True;";
        }
        /// <summary>
        /// Lấy câu lệnh SQL từ cache hoặc đọc file, hỗ trợ thư mục con (ví dụ "users/get_user_by_id")
        /// </summary>
        public string GetSql(string key)
        {
            if (_sqlCache.TryGetValue(key, out var cachedSql))
            {
                // Kiểm tra file có thay đổi không
                string fullPath = GetFullPathFromKey(key);
                DateTime lastWriteTime = File.GetLastWriteTimeUtc(fullPath);

                if (_fileLastWriteTime.TryGetValue(key, out var lastCachedWriteTime))
                {
                    if (lastWriteTime > lastCachedWriteTime)
                    {
                        // File đã thay đổi => reload
                        return ReloadSql(key, fullPath, lastWriteTime);
                    }
                    else
                    {
                        // File không thay đổi => trả cache
                        return cachedSql;
                    }
                }
                else
                {
                    // Lần đầu chưa lưu time => cập nhật
                    _fileLastWriteTime[key] = lastWriteTime;
                    return cachedSql;
                }
            }
            else
            {
                // Chưa có trong cache => đọc file
                string fullPath = GetFullPathFromKey(key);
                if (!File.Exists(fullPath))
                    throw new FileNotFoundException($"File SQL không tồn tại: {fullPath}");

                return ReloadSql(key, fullPath, File.GetLastWriteTimeUtc(fullPath));
            }
        }

        private string ReloadSql(string key, string fullPath, DateTime lastWriteTime)
        {
            string sql = File.ReadAllText(fullPath);
            _sqlCache[key] = sql;
            _fileLastWriteTime[key] = lastWriteTime;
            return sql;
        }

        private string GetFullPathFromKey(string key)
        {
            // Key có thể là "users/get_user_by_id" => convert thành D:/MyServerData/users/get_user_by_id.sql
            string relativePath = key.Replace('/', Path.DirectorySeparatorChar) + ".sql";
            return Path.Combine(_basePath, relativePath);
        }

        /// <summary>
        /// Xóa cache SQL (toàn bộ)
        /// </summary>
        public void ClearCache()
        {
            _sqlCache.Clear();
            _fileLastWriteTime.Clear();
        }

        /// <summary>
        /// Mở kết nối tới database
        /// </summary>
        public void OpenConnection()
        {
            if (_connection == null)
            {
                _connection = new SqlConnection(_connectionString);
                _connection.Open();
            }
            else if (_connection.State != ConnectionState.Open)
            {
                _connection.Open();
            }
        }

        /// <summary>
        /// Đóng kết nối database
        /// </summary>
        public void CloseConnection()
        {
            if (_connection != null)
            {
                if (_connection.State != ConnectionState.Closed)
                    _connection.Close();
                _connection.Dispose();
                _connection = null;
            }
        }

        /// <summary>
        /// Thực thi câu lệnh SQL không trả về dữ liệu (INSERT, UPDATE, DELETE)
        /// </summary>
        /// <param name="key">Tên file sql (key trong cache)</param>
        /// <param name="parameters">Tham số SQL nếu có</param>
        /// <returns>Số dòng bị ảnh hưởng</returns>
        public int ExecuteNonQuery(string key, Dictionary<string, object>? parameters = null)
        {
            string sql = GetSql(key);
            using var cmd = CreateCommand(sql, parameters);
            return cmd.ExecuteNonQuery();
        }

        /// <summary>
        /// Thực thi câu lệnh SQL trả về dữ liệu dạng DataTable (SELECT)
        /// </summary>
        public DataTable ExecuteQuery(string key, Dictionary<string, object>? parameters = null)
        {
            string sql = GetSql(key);
            using var cmd = CreateCommand(sql, parameters);
            using var adapter = new SqlDataAdapter(cmd);
            var dt = new DataTable();
            adapter.Fill(dt);
            return dt;
        }

        /// <summary>
        /// Thực thi câu lệnh SQL trả về một giá trị (thường dùng với COUNT, SUM, ...)
        /// </summary>
        public object? ExecuteScalar(string key, Dictionary<string, object>? parameters = null)
        {
            string sql = GetSql(key);
            using var cmd = CreateCommand(sql, parameters);
            return cmd.ExecuteScalar();
        }

        /// <summary>
        /// Tạo SqlCommand với tham số và kết nối đã mở sẵn
        /// </summary>
        private SqlCommand CreateCommand(string sql, Dictionary<string, object>? parameters)
        {
            if (_connection == null || _connection.State != ConnectionState.Open)
                throw new InvalidOperationException("Connection chưa được mở.");

            var cmd = _connection.CreateCommand();
            cmd.CommandText = sql;
            cmd.CommandType = CommandType.Text;

            if (parameters != null)
            {
                foreach (var p in parameters)
                {
                    cmd.Parameters.AddWithValue(p.Key, p.Value ?? DBNull.Value);
                }
            }

            return cmd;
        }

        /// <summary>
        /// Async version của ExecuteQuery
        /// </summary>
        public async Task<DataTable> ExecuteQueryAsync(string key, Dictionary<string, object>? parameters = null)
        {
            string sql = GetSql(key);
            using var cmd = CreateCommand(sql, parameters);
            using var reader = await cmd.ExecuteReaderAsync();
            var dt = new DataTable();
            dt.Load(reader);
            return dt;
        }

        /// <summary>
        /// Async version của ExecuteNonQuery
        /// </summary>
        public async Task<int> ExecuteNonQueryAsync(string key, Dictionary<string, object>? parameters = null)
        {
            string sql = GetSql(key);
            using var cmd = CreateCommand(sql, parameters);
            return await cmd.ExecuteNonQueryAsync();
        }

        /// <summary>
        /// Giải phóng tài nguyên
        /// </summary>
    }
}

/*
// var connStr = "Server=localhost;Database=MyDatabase;User Id=myUsername;Password=myPassword;";
// var connStr = "Server=localhost;Database=MyDatabase;Integrated Security=True;";
// Truy cập SQL Server ở máy khác
//var connStr = "Server=192.168.1.100;Database=MyDb;User Id=sa;Password=pass;";

var connStr = "your connection string here";
using var dbManager = new DatabaseManager("D:/MyServerData", connStr);

dbManager.OpenConnection();

// Ví dụ chạy truy vấn trả về nhiều dòng
var users = dbManager.ExecuteQuery("users/get_all_users");

// Ví dụ truy vấn lấy một giá trị
var count = (int)dbManager.ExecuteScalar("users/count_users");

// Ví dụ insert với tham số
var param = new Dictionary<string, object> { ["@UserName"] = "John", ["@Age"] = 30 };
int rows = dbManager.ExecuteNonQuery("users/insert_user", param);

dbManager.CloseConnection();

 */
