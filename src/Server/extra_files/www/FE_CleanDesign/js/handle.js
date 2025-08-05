import { APIAuth, APIUser } from './api.js';
import { UIManager } from './ui.js';

// Initialize and export
const UI = new UIManager();

export class Handle {
    static async Login(username, password) {
        if (!username || !password) {
            UI.toast("Vui lòng nhập đầy đủ thông tin");
            return false;
        }

        const api = new APIAuth();
        UI.showLoading();
        const res = await api.PostLogin(username, password);

        if (res.ok) {
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
        UI.showLoading();
        const res = await api.PostUser(username, password, email);

        if (res.ok) {
            setTimeout(() => {
                UI.hideLoading();
                UI.goTo(Pages.AUTH);
            }, 2000);
        } else {
            UI.toast("Thông tin đăng ký không hợp lệ");
        }
    }
}