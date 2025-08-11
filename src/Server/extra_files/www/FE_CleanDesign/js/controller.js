import { APIAuth, APIUser } from './api.js';
import { Pages, ViewServer } from './view.js';

const CLOUDINARY_CLOUD_NAME = 'dynmsbofr'; 
const CLOUDINARY_UPLOAD_PRESET = 'avatar_upload'; 

// Hàm upload file
async function uploadImage(file) {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('upload_preset', CLOUDINARY_UPLOAD_PRESET);

  const response = await fetch(`https://api.cloudinary.com/v1_1/${CLOUDINARY_CLOUD_NAME}/image/upload`, {
    method: 'POST',
    body: formData
  });

  if (!response.ok) {
    throw new Error('Upload thất bại');
  }

  const data = await response.json();
  return data.secure_url;
}

// Initialize and export
const UI = new ViewServer();

export class Controller {
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

    static async ChangeAvatar(file, avatar) {
        if (!file) {
            UI.showWarning("Vui lòng chọn ảnh");
            return false;
        }

        if (!file.type.startsWith('image/')) {
            UI.showWarning("Vui lòng chọn đúng định dạng ảnh");
            return false;
        }

        if (file.size > 2 * 1024 * 1024) { // 2MB
            UI.showWarning("Ảnh vượt quá dung lượng cho phép (2MB)");
            return false;
        }

        UI.showLoading();
        const imageUrl = await uploadImage(file);
        const api = new APIUser();
        const res = await api.PutUserAvatar(imageUrl);
        UI.hideLoading();


        if (!res.ok) {
            UI.showWarning("Đổi avatar thất bại!")
            return false;
        }

        avatar.src = imageUrl;

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
