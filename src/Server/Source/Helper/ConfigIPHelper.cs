using System.Net.NetworkInformation;
using System.Net.Sockets;

namespace Server.Source.Helper
{
    public static class ConfigIPHelper
    {
        static string[] preferredIps = new string[]
        {
        "192.168.1.100",
        "192.168.1.125",
        "192.168.1.150",
        "192.168.1.175",
        "192.168.1.200"
        };

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
        /// Gán IP tĩnh cho giao diện mạng
        /// </summary>
        /// <param name="ip">IP muốn gán, nếu null hoặc rỗng sẽ chọn tự động từ danh sách ưu tiên</param>
        /// <param name="interfaceName">Tên giao diện mạng</param>
        /// <param name="subnet">Subnet mask</param>
        /// <param name="gateway">Default gateway</param>
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

        private static void ApplyStaticIp(string ip, string interfaceName, string subnet, string gateway)
        {
            string cmd = $"netsh interface ip set address \"{interfaceName}\" static {ip} {subnet} {gateway} 1";
            CmdHelper.RunCommand(cmd);
        }

        public static void ResetToDHCP(string interfaceName = "Wi-Fi")
        {
            string cmd = $"netsh interface ip set address \"{interfaceName}\" dhcp";
            CmdHelper.RunCommand(cmd);
        }

        /// <summary>
        /// Lấy IP hiện tại của giao diện mạng
        /// </summary>
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
