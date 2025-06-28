using ServerConsole.Source.Core;
using ServerConsole.Source.Presenter;
using ServerConsole.Source.Manager;
using ServerConsole.Source.View;

namespace ServerConsole.Source.MainApp
{
    class Program
    {
        public static void SetUp()
        {
            Simulation.SetModel<LogManager>(new LogManager());
            Simulation.SetModel<SimulationManager>(new SimulationManager());
            Simulation.SetModel<SessionManager>(new SessionManager());
            Simulation.SetModel<ServerPresenter>(new ServerPresenter());
            Simulation.SetModel<ViewServer>(new ViewServer());
        }
        public static void Run()
        {
            Simulation.GetModel<LogManager>().Start();
            Simulation.GetModel<ViewServer>().Start();
            Simulation.GetModel<SimulationManager>().Start();
            Simulation.GetModel<SessionManager>().Start();
            Simulation.GetModel<ServerPresenter>().Start();
            Simulation.GetModel<ViewServer>().Start();
        }
        static void Main(string[] args)
        {
            SetUp();
            Run();

            while (true)
            {

            }

        }
    }
}
