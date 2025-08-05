using Server.Source.Extra;
using Server.Source.Manager;
using System.Net;

NotifyManager notifyManager = new NotifyManager("smtp.gmail.com", 587, "aysd pgdv lfib ldll");
notifyManager.Start();
notifyManager.OnEmailSent += req =>
{
    Console.WriteLine("Đã reset mật khẩu");
    // Không chặn thread xử lý SendMailAsync
    _ = Task.Run(() => notifyManager.Stop());
};
notifyManager.SendMailResetPassword("kingnemacc1@gmail.com", ">fkV1gq3gD1v");


while (true);
