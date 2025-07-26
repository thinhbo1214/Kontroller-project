using Server.Source.Core;
using Server.Source.Model;
using Server.Source.Presenter;
using Server.Source.View;

namespace Server.Source.MainApp
{
    internal static class Program
    {
        /// <summary>
        ///  The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            // To customize application configuration such as set high DPI settings or default font,
            // see https://aka.ms/applicationconfiguration.
            AppInitializer.Initialize();

            Simulation.SetModel<ModelServer>(new ModelServer());
            Simulation.GetModel<ServerPresenter>().Init();

            ViewServer viewServer = Simulation.GetModel<ViewServer>();
            Application.Run(viewServer);
        }
    }
}
