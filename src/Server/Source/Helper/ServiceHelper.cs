namespace Server.Source.Helper
{
    public static class ServiceHelper
    {
        public static void RunServiceCommand(string serviceName, string command)
        {
            string fullCommand = $"sc {command} \"{serviceName}\"";
            CmdHelper.RunCommand(fullCommand, runAsAdmin: true);
        }

        public static bool IsServiceRunning(string serviceName)
        {
            var status = GetServiceStatus(serviceName);
            return status == ServiceStatus.RUNNING;
        }

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
}

public enum ServiceStatus
{
    NOT_FOUND,
    RUNNING,
    STOPPED,
    PAUSED,
    UNKNOWN
}
/*
 * Cách dùng 
ServiceHelper.RunServiceCommand("MSSQLSERVER", "start");
ServiceHelper.RunServiceCommand("MyService", "stop");

 */
