// Trong handle.js
import { APIAuth, APIUser } from './api.js';
import { Pages, UI } from './ui.js';

export class Handle {
    static async Login(username, password) {
        if (!username || !password) {
            UI.toast("Vui lòng nhập đầy đủ thông tin");
            return false;
        }

        const api = new APIAuth();
        const res = await api.PostLogin(username, password);

        if (res.ok) {
            UI.toast("Đăng nhập thành công");
            UI.showLoading();
            setTimeout(() => {
                UI.hideLoading();
                UI.goTo(Pages.PROFILE);
            }, 2000);
        } else {
            UI.toast("Sai tài khoản hoặc mật khẩu");
        }
    }
    static async Register(username, password, email) {
        if (!username || !password || !email) {
            UI.toast("Vui lòng nhập đầy đủ thông tin");
            return false;
        }

        const api = new APIUser();
        const res = await api.PostUser(username, password, email);

        if (res.ok) {
            UI.showLoading();

            setTimeout(() => {
                UI.toast("Đăng ký thành công");

                setTimeout(() => {
                    UI.hideLoading();
                }, 2000);
                UI.goTo(Pages.AUTH);
            }, 2000);
        } else {
            UI.toast("Thông tin đăng ký không hợp lệ");
        }
    }
    static async ForgetPassword() {
        const email = prompt('Hãy nhập vào email của bạn: ');

        const api = new APIUser();
        UI.showLoading();
        const res = await api.PostForgetPassword(email);

        if (true) {
            setTimeout(() => {
                 UI.toast("Đã khôi phục mật khẩu, hãy kiểm tra email của bạn.");

                setTimeout(() => {
                    UI.goTo(Pages.INDEX);
                }, 1000);
                setTimeout(() => {
                    UI.hideLoading();
                }, 3000);
               

                // Tắt loading sau khi toast hiện (ví dụ 2s sau)



            }, 2000); // Đợi 2s rồi mới hiển thị toast
        } else {
            UI.toast("Email không hợp lệ.");
        }
    }
}
