namespace Server.Source.MainApp
{
    /// <summary>
    /// Cung cấp phương thức để khởi tạo cấu hình ban đầu cho ứng dụng Windows Forms.
    /// </summary>
    internal static class AppInitializer
    {
        /// <summary>
        /// Khởi tạo các thiết lập cơ bản cho ứng dụng, bao gồm chế độ DPI, kiểu trực quan và chế độ vẽ văn bản.
        /// </summary>
        /// <remarks>
        /// Phương thức này thiết lập các thuộc tính sau:
        /// - Chế độ DPI hệ thống để hỗ trợ hiển thị trên các màn hình có độ phân giải cao.
        /// - Kích hoạt các kiểu trực quan của Windows.
        /// - Thiết lập chế độ vẽ văn bản tương thích mặc định.
        /// </remarks>
        public static void Initialize()
        {
            Application.SetHighDpiMode(HighDpiMode.SystemAware);
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
        }
    }
}