import { APIAuth, APIUser } from './api.js';
import { Pages, View } from './view.js';
import { uploadImage } from './externalapi.js';

export class Controller {
    static async Login(username, password) {
        if (!username || !password) {
            View.showWarning("Vui lòng nhập đầy đủ thông tin!");
            return false;
        }

        const api = new APIAuth();
        View.showLoading();

        const res = await api.PostLogin(username, password);
        View.hideLoading();


        if (!res.ok) {
            View.showWarning("Tài khoản hoặc mật khẩu không đúng!");
            return false;
        }

        View.showSuccess("Đăng nhập thành công!");
        View.goTo(Pages.AUTH);
        return true;
    }
    static async Register(username, password, email) {
        if (!username || !password || !email) {
            View.showWarning("VView lòng nhập đầy đủ thông tin!");
            return false;
        }

        const api = new APIUser();
        View.showLoading();
        const res = await api.PostUser(username, password, email);
        View.hideLoading();

        if (!res.ok) {
            View.showWarning("Thông tin đăng ký không hợp lệ");
            return false;
        }

        View.showSuccess("Đăng ký thành công");
        View.goTo(Pages.PROFILE);
        return true;
    }

    static async ChangeAvatar(file, avatar) {
        if (!file) {
            View.showWarning("Vuilòng chọn ảnh");
            return false;
        }

        if (!file.type.startsWith('image/')) {
            View.showWarning("Vui lòng chọn đúng định dạng ảnh");
            return false;
        }

        if (file.size > 2 * 1024 * 1024) { // 2MB
            View.showWarning("Ảnh vượt quá dung lượng cho phép (2MB)");
            return false;
        }

        View.showLoading();
        const imageUrl = await uploadImage(file);
        const api = new APIUser();
        const res = await api.PutUserAvatar(imageUrl);
        View.hideLoading();


        if (!res.ok) {
            View.showWarning("Đổi avatar thất bại!")
            return false;
        }

        avatar.src = imageUrl;

        View.showSuccess("Đổi avatar thành công!")
        return true;

    }
    
    static async Forgot(email) {
        if (email == null) {
            View.showWarning("Vui lòng nhập đầy đủ thông tin!")
            return false;
        }
        const api = new APIUser();
        View.showLoading();

        const res = await api.PostForgetPassword(email);
        View.hideLoading();
        if (!res.ok) {
            View.showWarning("Email chưa được đăng ký")
            return false;
        }

        View.showSuccess("Gửi mã thiết lập lại mật khẩu thành công")
        View.goTo(Pages.AUTH);
        return true;
    }
    static async ShowEdit(userId) {


        const api = new APIUser();
        View.showLoading();

        const res = await api.GetUser(userId);
        View.hideLoading();
        if (!res.ok) {
            View.showWarning("Lỗi xảy ra")
            return false;
        }

        View.showSuccess("Mở bio thành công")
        return true;
    }

    static async DeleteAcc(password) {
        const api = new APIUser();
        View.showLoading();

        const res = await api.DeleteUser(password)
        View.hideLoading();

        if (!res.ok) {
            View.showWarning("Xóa tài khoản không thành công")
            return false;
        }

        View.showSuccess("Xóa tài khoản thành công")
        View.goTo(Pages.INDEX)
        return true;
    }
}
