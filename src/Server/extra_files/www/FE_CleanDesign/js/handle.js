import { APIAuth, APIUser } from './api.js';
import { Pages, UIManager } from './ui.js';

// Initialize and export
const UI = new UIManager();

export class Handle {
    static async Login(username, password) {
        if (!username || !password) {
            UI.showWarning("Vui lòng nhập đầy đủ thông tin");
            return false;
        }

        const api = new APIAuth();
        UI.showLoading();
        const res = await api.PostLogin(username, password);

        if (res.ok) {
            setTimeout(() => {
                UI.goTo(Pages.PROFILE);
            }, 2000);
            UI.showSuccess("Đăng nhập thành công");
        } else {
            UI.showWarning("Sai tài khoản hoặc mật khẩu");
        }
        UI.hideLoading();
    }
    static async Register(username, password, email) {
        if (!username || !password || !email) {
            UI.showWarning("Vui lòng nhập đầy đủ thông tin");
            return false;
        }

        const api = new APIUser();
        UI.showLoading();
        const res = await api.PostUser(username, password, email);

        if (res.ok) {
            setTimeout(() => {
                
                UI.goTo(Pages.AUTH);
            }, 2000);
            UI.showSuccess("Đăng ký thành công");
        } else {
            UI.showWarning("Thông tin đăng ký không hợp lệ");
        }
        UI.hideLoading();
    }
}