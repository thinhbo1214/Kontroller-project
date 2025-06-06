using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerConsole.Source.extra
{
    public static class ConcurrencyLimiter
    {
        public static readonly SemaphoreSlim Limiter = new SemaphoreSlim(20);
    }
}
