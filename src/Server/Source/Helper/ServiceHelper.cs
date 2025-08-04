namespace Server.Source.Helper
{
    /// <summary>
    /// Cung cấp các phương thức hỗ trợ để quản lý và kiểm tra trạng thái các dịch vụ hệ thống Windows thông qua lệnh SC (Service Control).
    /// </summary>
    public static class ServiceHelper
    {
        /// <summary>
        /// Thực thi lệnh điều khiển dịch vụ (Service Control) như start, stop, v.v. trên một dịch vụ được chỉ định.
        /// </summary>
        /// <param name="serviceName">Tên của dịch vụ cần điều khiển.</param>
        /// <param name="command">Lệnh điều khiển dịch vụ (ví dụ: "start", "stop").</param>
        /// <remarks>
        /// Lệnh được thực thi với quyền quản trị viên thông qua <see cref="CmdHelper.RunCommand"/>.
        /// </remarks>
        public static void RunServiceCommand(string serviceName, string command)
        {
            string fullCommand = $"sc {command} \"{serviceName}\"";
            CmdHelper.RunCommand(fullCommand, runAsAdmin: true);
        }

        /// <summary>
        /// Kiểm tra xem một dịch vụ có đang chạy hay không.
        /// </summary>
        /// <param name="serviceName">Tên của dịch vụ cần kiểm tra.</param>
        /// <returns>
        /// Trả về <c>true</c> nếu dịch vụ đang chạy, ngược lại trả về <c>false</c>.
        /// </returns>
        public static bool IsServiceRunning(string serviceName)
        {
            var status = GetServiceStatus(serviceName);
            return status == ServiceStatus.RUNNING;
        }

        /// <summary>
        /// Lấy trạng thái hiện tại của một dịch vụ hệ thống.
        /// </summary>
        /// <param name="serviceName">Tên của dịch vụ cần kiểm tra.</param>
        /// <returns>
        /// Một giá trị của <see cref="ServiceStatus"/> biểu thị trạng thái của dịch vụ (RUNNING, STOPPED, PAUSED, NOT_FOUND, hoặc UNKNOWN).
        /// </returns>
        public static ServiceStatus GetServiceStatus(string serviceName)
        {
            string output = CmdHelper.RunCommandWithOutput($"sc query \"{serviceName}\"");

            if (output.Contains("The specified service does not exist", StringComparison.OrdinalIgnoreCase))
                return ServiceStatus.NOT_FOUND;

            if (output.Contains("RUNNING")) return ServiceStatus.RUNNING;
            if (output.Contains("STOPPED")) return ServiceStatus.STOPPED;
            if (output.Contains("PAUSED")) return ServiceStatus.PAUSED;

            return ServiceStatus.UNKNOWN;
        }
    }

    /// <summary>
    /// Định nghĩa các trạng thái có thể có của một dịch vụ hệ thống.
    /// </summary>
    public enum ServiceStatus
    {
        /// <summary>
        /// Dịch vụ không tồn tại.
        /// </summary>
        NOT_FOUND,

        /// <summary>
        /// Dịch vụ đang chạy.
        /// </summary>
        RUNNING,

        /// <summary>
        /// Dịch vụ đã dừng.
        /// </summary>
        STOPPED,

        /// <summary>
        /// Dịch vụ đang tạm dừng.
        /// </summary>
        PAUSED,

        /// <summary>
        /// Trạng thái của dịch vụ không xác định.
        /// </summary>
        UNKNOWN
    }
}

/*
 * Ví dụ cách dùng:
 * ServiceHelper.RunServiceCommand("MSSQLSERVER", "start"); // Khởi động dịch vụ MSSQLSERVER
 * ServiceHelper.RunServiceCommand("MyService", "stop");   // Dừng dịch vụ MyService
 */