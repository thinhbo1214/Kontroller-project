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
            UI.showSuccess("Đăng nhập thành công");
            await new Promise(resolve => setTimeout(resolve, 2000)); // Đợi 2 giây để người dùng thấy message
            UI.goTo(Pages.PROFILE);

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
            UI.showSuccess("Đăng ký thành công");
            await new Promise(resolve => setTimeout(resolve, 2000)); // Đợi 2 giây
            UI.goTo(Pages.AUTH);
        } else {
            UI.showWarning("Thông tin đăng ký không hợp lệ");
        }

        UI.hideLoading();
    }
}