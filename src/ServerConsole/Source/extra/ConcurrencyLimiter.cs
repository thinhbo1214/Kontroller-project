using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ServerConsole.Source.Extra
{
    public static class ConcurrencyLimiter
    {
        public static readonly SemaphoreSlim Limiter = new SemaphoreSlim(20);
    }
}
