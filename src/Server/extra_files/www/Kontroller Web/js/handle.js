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
            UI.toast("Đăng ký thành công");
            UI.showLoading();
            setTimeout(() => {
                UI.hideLoading();
                UI.goTo(Pages.AUTH);
            }, 2000);
        } else {
            UI.toast("Thông tin đăng ký không hợp lệ");
        }
    }
}
