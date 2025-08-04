using System.Net.NetworkInformation;
using System.Net.Sockets;

namespace Server.Source.Helper
{
    /// <summary>
    /// Hỗ trợ cấu hình địa chỉ IP cho giao diện mạng, bao gồm gán IP tĩnh, chuyển về DHCP,
    /// và truy vấn địa chỉ IP hiện tại.
    /// </summary>
    public static class ConfigIPHelper
    {
        /// <summary>
        /// Danh sách IP ưu tiên để gán tự động nếu không truyền IP cụ thể.
        /// </summary>
        static string[] preferredIps = new string[]
        {
            "192.168.1.100",
            "192.168.1.125",
            "192.168.1.150",
            "192.168.1.175",
            "192.168.1.200"
        };

        /// <summary>
        /// Kiểm tra xem một địa chỉ IP có khả dụng hay không (chưa có thiết bị nào dùng).
        /// </summary>
        /// <param name="ip">Địa chỉ IP cần kiểm tra.</param>
        /// <returns>True nếu IP chưa có thiết bị nào sử dụng, ngược lại là false.</returns>
        public static bool IsIpAvailable(string ip)
        {
            using (var ping = new Ping())
            {
                try
                {
                    var reply = ping.Send(ip, 100);
                    return reply.Status != IPStatus.Success;
                }
                catch
                {
                    return false;
                }
            }
        }

        /// <summary>
        /// Gán IP tĩnh cho một giao diện mạng nhất định.
        /// Nếu không truyền IP cụ thể, sẽ tự động chọn từ danh sách IP ưu tiên.
        /// </summary>
        /// <param name="ip">Địa chỉ IP muốn gán. Nếu null hoặc rỗng sẽ chọn tự động.</param>
        /// <param name="interfaceName">Tên giao diện mạng (mặc định là "Wi-Fi").</param>
        /// <param name="subnet">Subnet mask (mặc định 255.255.255.0).</param>
        /// <param name="gateway">Địa chỉ gateway mặc định (mặc định 192.168.1.1).</param>
        public static void SetStaticIp(string ip = "", string interfaceName = "Wi-Fi", string subnet = "255.255.255.0", string gateway = "192.168.1.1")
        {
            if (!string.IsNullOrWhiteSpace(ip))
            {
                if (IsIpAvailable(ip))
                {
                    ApplyStaticIp(ip, interfaceName, subnet, gateway);
                }
                return;
            }

            // Nếu không truyền IP thì chọn IP tự động từ danh sách ưu tiên
            foreach (var preferredIp in preferredIps)
            {
                if (IsIpAvailable(preferredIp))
                {
                    ApplyStaticIp(preferredIp, interfaceName, subnet, gateway);
                    return;
                }
            }
        }

        /// <summary>
        /// Áp dụng IP tĩnh cho một giao diện mạng cụ thể bằng lệnh netsh.
        /// </summary>
        /// <param name="ip">Địa chỉ IP.</param>
        /// <param name="interfaceName">Tên giao diện mạng.</param>
        /// <param name="subnet">Subnet mask.</param>
        /// <param name="gateway">Địa chỉ gateway mặc định.</param>
        private static void ApplyStaticIp(string ip, string interfaceName, string subnet, string gateway)
        {
            string cmd = $"netsh interface ip set address \"{interfaceName}\" static {ip} {subnet} {gateway} 1";
            CmdHelper.RunCommand(cmd);
        }

        /// <summary>
        /// Chuyển giao diện mạng về chế độ DHCP (nhận IP tự động).
        /// </summary>
        /// <param name="interfaceName">Tên giao diện mạng (mặc định là "Wi-Fi").</param>
        public static void ResetToDHCP(string interfaceName = "Wi-Fi")
        {
            string cmd = $"netsh interface ip set address \"{interfaceName}\" dhcp";
            CmdHelper.RunCommand(cmd);
        }

        /// <summary>
        /// Lấy địa chỉ IP hiện tại của một giao diện mạng.
        /// </summary>
        /// <param name="interfaceName">Tên giao diện mạng cần kiểm tra (mặc định là "Wi-Fi").</param>
        /// <returns>Chuỗi địa chỉ IP nếu có, null nếu không tìm thấy.</returns>
        public static string? GetCurrentIpAddress(string interfaceName = "Wi-Fi")
        {
            var interfaces = NetworkInterface.GetAllNetworkInterfaces();

            foreach (var ni in interfaces)
            {
                if (ni.Name.Equals(interfaceName, StringComparison.OrdinalIgnoreCase) &&
                    ni.OperationalStatus == OperationalStatus.Up)
                {
                    var ipProps = ni.GetIPProperties();
                    foreach (var addr in ipProps.UnicastAddresses)
                    {
                        if (addr.Address.AddressFamily == AddressFamily.InterNetwork)
                        {
                            return addr.Address.ToString();
                        }
                    }
                }
            }

            return null;
        }
    }
}
