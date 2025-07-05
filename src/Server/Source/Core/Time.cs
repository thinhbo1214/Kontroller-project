using System.Diagnostics;

namespace Server.Source.Core
{
    public static class Time
    {
        private static readonly Stopwatch stopwatch = Stopwatch.StartNew();
        public static float time => (float)stopwatch.Elapsed.TotalSeconds;
    }
}
