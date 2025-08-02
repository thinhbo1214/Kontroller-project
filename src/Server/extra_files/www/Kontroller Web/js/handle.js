// Trong handle.js
import { LoginAPI } from './api.js';
import { Pages, UI } from './ui.js';

export class Handle {
    static async Login(username, password) {
        if (!username || !password) {
            UI.toast("Vui lòng nhập đầy đủ thông tin");
            return false;
        }

        const api = new LoginAPI();
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
}
