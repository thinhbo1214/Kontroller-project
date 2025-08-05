import { APIAuth, APIUser } from './api.js';
import { Pages, UIManager } from './ui.js';

// Initialize and export
const UI = new UIManager();

export class Handle {
    static async Login(username, password) {
        if (!username || !password) {
            UI.showWarning("Vui lòng nhập đầy đủ thông tin!");
            return false;
        }

        const api = new APIAuth();
        UI.showLoading();

        const res = await api.PostLogin(username, password);
        UI.hideLoading();

        if (!res.ok) {
            UI.showWarning("Tài khoản hoặc mật khẩu không đúng!");
            return false;
        }

        UI.showSuccess("Đăng nhập thành công!");
        UI.goTo(Pages.PROFILE);
        return true;
    }
    static async Register(username, password, email) {
        if (!username || !password || !email) {
            UI.showWarning("Vui lòng nhập đầy đủ thông tin!");
            return false;
        }

        const api = new APIUser();
        UI.showLoading();
        const res = await api.PostUser(username, password, email);

        if (res.ok) {
            UI.showSuccess("Đăng ký thành công");
            UI.goTo(Pages.AUTH);
        } else {
            UI.showWarning("Thông tin đăng ký không hợp lệ");
        }

        UI.hideLoading();
    }
}