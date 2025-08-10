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
        UI.goTo(Pages.AUTH);
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
        UI.hideLoading();

        if (!res.ok) {
            UI.showWarning("Thông tin đăng ký không hợp lệ");
            return false;
        }

        UI.showSuccess("Đăng ký thành công");
        UI.goTo(Pages.PROFILE);
        return true;
    }

    static async ChangeAvatar(file, preview) {
        if (!file) {
            UI.showWarning("Vui lòng chọn ảnh");
            return false;
        }

        const api = new APIUser();

        UI.showLoading();
        const res = await api.PutUserAvatar(file);
        UI.hideLoading();

        if (!res.ok) {
            UI.showWarning("Đổi avatar thất bại!")
            return false;
        }

        // Preview ảnh mới
        const reader = new FileReader();
        reader.onload = (e) => {
            preview.src = e.target.result;
        };
        reader.readAsDataURL(file);

        UI.showSuccess("Đổi avatar thành công!")
        return true;

    }
    static async Forgot(email) {
        if (email == null) {
            UI.showWarning("Vui lòng nhập đầy đủ thông tin!")
            return false;
        }
        const api = new APIUser();
        UI.showLoading();

        const res = await api.PostForgetPassword(email);
        UI.hideLoading();
        if (!res.ok) {
            UI.showWarning("Email chưa được đăng ký")
            return false;
        }

        UI.showSuccess("Gửi mã thiết lập lại mật khẩu thành công")
        UI.goTo(Pages.AUTH);
        return true;
    }
    static async ShowEdit(userId) {


        const api = new APIUser();
        UI.showLoading();

        const res = await api.GetUser(userId);
        UI.hideLoading();
        if (!res.ok) {
            UI.showWarning("Lỗi xảy ra")
            return false;
        }

        UI.showSuccess("Mở bio thành công")
        return true;
    }

    static async DeleteAcc(password) {
        const api = new APIUser();
        UI.showLoading();

        const res = await api.DeleteUser(password)
        UI.hideLoading();

        if (!res.ok) {
            UI.showWarning("Xóa tài khoản không thành công")
            return false;
        }

        UI.showSuccess("Xóa tài khoản thành công")
        UI.goTo(Pages.INDEX)
        return true;
    }
}
