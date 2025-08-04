using Microsoft.Data.SqlClient;
using Server.Source.Core;
using Server.Source.Helper;
using System.Data;

namespace Server.Source.Manager
{
    /// <summary>
    /// Quản lý kết nối cơ sở dữ liệu SQL Server và thực thi các truy vấn SQL, hỗ trợ lưu trữ cache câu lệnh SQL từ tệp.
    /// </summary>
    public class DatabaseManager
    {
        private readonly string _basePath; // Nơi chứa thư mục gốc chứa file sql
        private readonly string _connectionString;

        /// <summary>
        /// Bộ nhớ cache cho các câu lệnh SQL, với khóa dạng "folder/file" hoặc "file".
        /// </summary>
        private readonly Dictionary<string, string> _sqlCache = new Dictionary<string, string>();

        /// <summary>
        /// Theo dõi thời gian sửa đổi cuối cùng của các tệp SQL để kiểm tra thay đổi.
        /// </summary>
        private readonly Dictionary<string, DateTime> _fileLastWriteTime = new Dictionary<string, DateTime>();

        private SqlConnection? _connection;

        /// <summary>
        /// Khởi động dịch vụ SQL Server với tên dịch vụ được chỉ định.
        /// </summary>
        /// <param name="serviceName">Tên của dịch vụ SQL Server (mặc định là "MSSQLSERVER").</param>
        public void StartSqlService(string serviceName = "MSSQLSERVER")
        {
            ServiceHelper.RunServiceCommand(serviceName, "start");
        }

        /// <summary>
        /// Dừng dịch vụ SQL Server với tên dịch vụ được chỉ định.
        /// </summary>
        /// <param name="serviceName">Tên của dịch vụ SQL Server (mặc định là "MSSQLSERVER").</param>
        public void StopSqlService(string serviceName = "MSSQLSERVER")
        {
            ServiceHelper.RunServiceCommand(serviceName, "stop");
        }

        /// <summary>
        /// Khởi tạo <see cref="DatabaseManager"/> với đường dẫn thư mục SQL và chuỗi kết nối.
        /// </summary>
        /// <param name="basePath">Đường dẫn thư mục chứa các tệp SQL.</param>
        /// <param name="connectionString">Chuỗi kết nối tới cơ sở dữ liệu SQL Server.</param>
        /// <exception cref="ArgumentNullException">Ném ra nếu <paramref name="basePath"/> hoặc <paramref name="connectionString"/> là null.</exception>
        public DatabaseManager(string basePath, string connectionString)
        {
            _basePath = basePath ?? throw new ArgumentNullException(nameof(basePath));
            _connectionString = connectionString ?? throw new ArgumentNullException(nameof(connectionString));
        }

        /// <summary>
        /// Khởi tạo <see cref="DatabaseManager"/> với đường dẫn mặc định và chuỗi kết nối tới cơ sở dữ liệu KontrollerDB.
        /// </summary>
        public DatabaseManager()
        {
            _basePath = Path.Combine(AppContext.BaseDirectory, "extra_files", "MyServerData", "queries");
            _connectionString = "Server=localhost;Database=KontrollerDB;Integrated Security=True;TrustServerCertificate=True;";
        }

        /// <summary>
        /// Lấy câu lệnh SQL từ cache hoặc đọc từ tệp, hỗ trợ thư mục con (ví dụ: "users/get_user_by_id").
        /// </summary>
        /// <param name="key">Khóa của câu lệnh SQL trong cache hoặc đường dẫn tệp (ví dụ: "users/get_user_by_id").</param>
        /// <returns>Chuỗi câu lệnh SQL.</returns>
        /// <exception cref="FileNotFoundException">Ném ra nếu tệp SQL không tồn tại.</exception>
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

        /// <summary>
        /// Tải lại câu lệnh SQL từ tệp và cập nhật cache.
        /// </summary>
        /// <param name="key">Khóa của câu lệnh SQL.</param>
        /// <param name="fullPath">Đường dẫn đầy đủ tới tệp SQL.</param>
        /// <param name="lastWriteTime">Thời gian sửa đổi cuối cùng của tệp.</param>
        /// <returns>Chuỗi câu lệnh SQL được tải lại.</returns>
        private string ReloadSql(string key, string fullPath, DateTime lastWriteTime)
        {
            string sql = File.ReadAllText(fullPath);
            _sqlCache[key] = sql;
            _fileLastWriteTime[key] = lastWriteTime;
            return sql;
        }

        /// <summary>
        /// Chuyển đổi khóa thành đường dẫn đầy đủ tới tệp SQL.
        /// </summary>
        /// <param name="key">Khóa của câu lệnh SQL (ví dụ: "users/get_user_by_id").</param>
        /// <returns>Đường dẫn đầy đủ tới tệp SQL (ví dụ: "D:/MyServerData/users/get_user_by_id.sql").</returns>
        private string GetFullPathFromKey(string key)
        {
            // Key có thể là "users/get_user_by_id" => convert thành D:/MyServerData/users/get_user_by_id.sql
            string relativePath = key.Replace('/', Path.DirectorySeparatorChar) + ".sql";
            return Path.Combine(_basePath, relativePath);
        }

        /// <summary>
        /// Xóa toàn bộ cache câu lệnh SQL và thời gian sửa đổi tệp.
        /// </summary>
        public void ClearCache()
        {
            _sqlCache.Clear();
            _fileLastWriteTime.Clear();
        }

        /// <summary>
        /// Mở kết nối tới cơ sở dữ liệu SQL Server.
        /// </summary>
        /// <exception cref="InvalidOperationException">Ném ra nếu kết nối không thể mở.</exception>
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
        /// Đóng và giải phóng kết nối cơ sở dữ liệu.
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
        /// Thực thi câu lệnh SQL không trả về dữ liệu (INSERT, UPDATE, DELETE).
        /// </summary>
        /// <param name="key">Khóa của câu lệnh SQL trong cache hoặc tệp.</param>
        /// <param name="parameters">Tham số SQL (nếu có).</param>
        /// <returns>Số dòng bị ảnh hưởng bởi câu lệnh.</returns>
        /// <exception cref="InvalidOperationException">Ném ra nếu kết nối chưa được mở.</exception>
        public int ExecuteNonQuery(string key, Dictionary<string, object>? parameters = null)
        {
            string sql = GetSql(key);
            using var cmd = CreateCommand(sql, parameters);
            return cmd.ExecuteNonQuery();
        }

        /// <summary>
        /// Thực thi câu lệnh SQL trả về dữ liệu dưới dạng <see cref="DataTable"/> (SELECT).
        /// </summary>
        /// <param name="key">Khóa của câu lệnh SQL trong cache hoặc tệp.</param>
        /// <param name="parameters">Tham số SQL (nếu có).</param>
        /// <returns>Bảng dữ liệu chứa kết quả truy vấn.</returns>
        /// <exception cref="InvalidOperationException">Ném ra nếu kết nối chưa được mở.</exception>
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
        /// Thực thi câu lệnh SQL trả về một giá trị duy nhất (thường dùng với COUNT, SUM, ...).
        /// </summary>
        /// <param name="key">Khóa của câu lệnh SQL trong cache hoặc tệp.</param>
        /// <param name="parameters">Tham số SQL (nếu có).</param>
        /// <returns>Giá trị duy nhất từ truy vấn hoặc <c>null</c> nếu không có kết quả.</returns>
        /// <exception cref="InvalidOperationException">Ném ra nếu kết nối chưa được mở.</exception>
        public object? ExecuteScalar(string key, Dictionary<string, object>? parameters = null)
        {
            string sql = GetSql(key);
            using var cmd = CreateCommand(sql, parameters);
            return cmd.ExecuteScalar();
        }

        /// <summary>
        /// Tạo đối tượng <see cref="SqlCommand"/> với câu lệnh SQL và tham số.
        /// </summary>
        /// <param name="sql">Câu lệnh SQL cần thực thi.</param>
        /// <param name="parameters">Tham số SQL (nếu có).</param>
        /// <returns>Đối tượng <see cref="SqlCommand"/> đã được cấu hình.</returns>
        /// <exception cref="InvalidOperationException">Ném ra nếu kết nối chưa được mở.</exception>
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
        /// Thực thi câu lệnh SQL trả về dữ liệu dưới dạng <see cref="DataTable"/> bất đồng bộ (SELECT).
        /// </summary>
        /// <param name="key">Khóa của câu lệnh SQL trong cache hoặc tệp.</param>
        /// <param name="parameters">Tham số SQL (nếu có).</param>
        /// <returns>Bảng dữ liệu chứa kết quả truy vấn.</returns>
        /// <exception cref="InvalidOperationException">Ném ra nếu kết nối chưa được mở.</exception>
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
        /// Thực thi câu lệnh SQL không trả về dữ liệu bất đồng bộ (INSERT, UPDATE, DELETE).
        /// </summary>
        /// <param name="key">Khóa của câu lệnh SQL trong cache hoặc tệp.</param>
        /// <param name="parameters">Tham số SQL (nếu có).</param>
        /// <returns>Số dòng bị ảnh hưởng bởi câu lệnh.</returns>
        /// <exception cref="InvalidOperationException">Ném ra nếu kết nối chưa được mở.</exception>
        public async Task<int> ExecuteNonQueryAsync(string key, Dictionary<string, object>? parameters = null)
        {
            string sql = GetSql(key);
            using var cmd = CreateCommand(sql, parameters);
            return await cmd.ExecuteNonQueryAsync();
        }

        // Ghi chú: Không có phương thức Dispose rõ ràng trong mã gốc, có thể cần xem xét thêm IDisposable
    }
}

/*
// Ví dụ cách sử dụng:
// var connStr = "Server=localhost;Database=MyDatabase;User Id=myUsername;Password=myPassword;";
// var connStr = "Server=localhost;Database=MyDatabase;Integrated Security=True;";
// Truy cập SQL Server ở máy khác
// var connStr = "Server=192.168.1.100;Database=MyDb;User Id=sa;Password=pass;";

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