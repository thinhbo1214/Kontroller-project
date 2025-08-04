using Microsoft.Data.SqlClient;
using Server.Source.Core;
using Server.Source.Model;
using Server.Source.Presenter;
using Server.Source.View;

namespace Server.Source.MainApp
{
    /// <summary>
    /// Điểm khởi chạy chính của ứng dụng Windows Forms, chịu trách nhiệm khởi tạo và chạy ứng dụng máy chủ.
    /// </summary>
    internal static class Program
    {
        /// <summary>
        /// Điểm nhập chính cho ứng dụng.
        /// </summary>
        /// <remarks>
        /// Phương thức này thực hiện các bước sau:
        /// - Khởi tạo cấu hình ứng dụng thông qua <see cref="AppInitializer.Initialize"/>.
        /// - Thiết lập mô hình máy chủ (<see cref="ModelServer"/>) trong hệ thống mô phỏng.
        /// - Khởi tạo trình bày máy chủ (<see cref="ServerPresenter"/>).
        /// - Chạy giao diện người dùng chính của máy chủ (<see cref="ViewServer"/>) trong vòng lặp ứng dụng Windows Forms.
        /// Để tùy chỉnh cấu hình ứng dụng như thiết lập DPI cao hoặc phông chữ mặc định, xem thêm tại https://aka.ms/applicationconfiguration.
        /// </remarks>
        [STAThread]
        static void Main()
        {
            AppInitializer.Initialize();

            Simulation.SetModel<ModelServer>(new ModelServer());
            Simulation.GetModel<ServerPresenter>().Init();

            ViewServer viewServer = Simulation.GetModel<ViewServer>();
            Application.Run(viewServer);
        }
    }
}