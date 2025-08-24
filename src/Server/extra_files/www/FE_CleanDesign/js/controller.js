import { APIAuth, APIUser, GameAPI, ReviewAPI, ReactionAPI } from './api.js';
import { View } from './view.js';
import { uploadImage } from './externalapi.js';
import { Model, Pages } from './model.js';


export class Controller {
    // ====== API method =======

    // ======= User =========
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

        View.goTo(Pages.Page.HOME);
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
        View.goTo(Pages.Page.PROFILE);
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

        if (res.status === 401) {
            Model.deleteAuthToken();
            View.goTo(Pages.Page.AUTH);
            return false;
        }

        if (!res.ok) {
            View.showWarning("Đổi avatar thất bại!")
            return false;
        }

        avatar.src = imageUrl;
        View.showSuccess("Đổi avatar thành công!")
        return true;

    }

    static async ChangePassword(oldpassword, newPassword) {
        const api = new APIUser();
        View.showLoading();

        const res = await api.PutUserPassword(oldpassword, newPassword)
        View.hideLoading();

        if (res.status === 401) {
            Model.deleteAuthToken();
            View.goTo(Pages.Page.AUTH);
            return false;
        }

        if (!res.ok) {
            View.showWarning("Đổi password thất bại!")
            return false;
        }

        View.showSuccess("Đổi password thành công!")
        return true;
    }

    static async ChangeUsername(username) {
        const api = new APIUser();
        View.showLoading();

        const res = await api.PutUserUsername(username)
        View.hideLoading();

        if (res.status === 401) {
            Model.deleteAuthToken();
            View.goTo(Pages.Page.AUTH);
            return false;
        }

        if (!res.ok) {
            View.showWarning("Đổi username thất bại!")
            return false;
        }

        View.showSuccess("Đổi username thành công!")
        return true;
    }

    static async ChangeEmail(email) {
        const api = new APIUser();
        View.showLoading();

        const res = await api.PutUserEmail(email)
        View.hideLoading();

        if (res.status === 401) {
            Model.deleteAuthToken();
            View.goTo(Pages.Page.AUTH);
            return false;
        }

        if (!res.ok) {
            View.showWarning("Đổi email thất bại!")
            return false;
        }
        View.showSuccess("Đổi email thành công!")
        return true;
    }


    static async Forgot(email) {
        if (email == null) {
            View.showWarning("Vui lòng nhập đầy đủ thông tin!")
            return false;
        }
        const api = new APIAuth();
        View.showLoading();

        const res = await api.PostForgetPassword(email);
        View.hideLoading();

        if (!res.ok) {
            View.showWarning("Email chưa được đăng ký")
            return false;
        }

        View.showSuccess("Gửi mã thiết lập lại mật khẩu thành công")
        View.goTo(Pages.Page.AUTH);
        return true;
    }

    static async Logout() {
        const api = new APIAuth();
        View.showLoading();

        const res = await api.PostLogout()
        View.hideLoading();

        if (res.status === 401) {
            Model.deleteAuthToken();
            View.goTo(Pages.Page.AUTH);
            return;
        }
        if (!res.ok) {
            View.showWarning("Đăng xuất không thành công")
            return false;
        }

        View.showSuccess("Đăng xuất thành công")
        Model.deleteAuthToken();
        View.goTo(Pages.Page.INDEX)
        return true;
    }

    static async DeleteAcc(password) {
        const api = new APIUser();
        View.showLoading();

        const res = await api.DeleteUser(password)
        View.hideLoading();

        if (res.status === 401) {
            Model.deleteAuthToken();
            View.goTo(Pages.Page.AUTH);
            return;
        }
        if (!res.ok) {
            View.showWarning("Xóa tài khoản không thành công")
            return false;
        }

        View.showSuccess("Xóa tài khoản thành công")
        Model.deleteAuthToken();
        View.goTo(Pages.Page.INDEX)
        return true;
    }



    static async ShowUserInfo() {
        const api = new APIUser();

        View.showLoading();
        const userInfo = Model.getLocalStorageJSON('userInfo');

        // Xác suất fetch lại (30% chẳng hạn)
        const shouldRefetch = Math.random() < 0.3;

        if (!userInfo || shouldRefetch) {
            const res = await api.GetUser();
            View.hideLoading();

            if (!res.ok) {
                View.showUserInfo(userInfo);
                return false;
            }

            Model.setLocalStorageJSON('userInfo', res.data);
            View.showUserInfo(res.data);
            return true;
        }

        View.hideLoading();
        View.showUserInfo(userInfo);
        return true;
    }


    static async ShowStat() {
        const api = new APIUser();
        View.showLoading();

        const res1 = await api.GetUserFollower();
        const res2 = await api.GetUserFollowing();

        if (!res1.ok || !res2.ok) {

        }

        View.updateStats()
        return true;

    }



















    // ========= Game Review ==============
    //reaction section
    static async reactToReview(reactionType, reviewId, btnEl) {
        try {
            const api = new ReactionAPI();
            const res = await api.PostReactionForReview(reactionType, reviewId);

            if (res.success) {
                const countSpan = btnEl.querySelector("span");
                if (countSpan) {
                    let count = parseInt(countSpan.textContent) || 0;
                    countSpan.textContent = count + 1;
                }
            }
        } catch (err) {
            console.error("Error reacting to review:", err);
        }
    }

    static async reactToComment(reactionType, commentId, btnEl) {
        try {
            const api = new ReactionAPI();
            const res = await api.PostReactionForComment(reactionType, commentId);

            if (res.success) {
                // tăng count trong UI
                const countSpan = btnEl.querySelector("span");
                if (countSpan) {
                    let count = parseInt(countSpan.textContent) || 0;
                    countSpan.textContent = count + 1;
                }
            }
        } catch (err) {
            console.error("Error reacting to comment:", err);
        }
    }






    // ========= Game ===========
    static async GetGame() {
        const api = new GameAPI();
        View.showLoading();

        const res = await api.GetGame();
        View.hideLoading();

        if (!res.ok) {
            View.showWarning("Gặp lỗi khi lấy dữ liệu game")
            return false;
        }

        View.showGame(res.data)
        return true;
    }

    // ===========Review API===================
    static async GetReview() {
        const api = new ReviewAPI();
        View.showLoading();

        const res = await api.GetReviewByUser()
        View.hideLoading();

        if (!res.ok) {
            View.showWarning("Gặp lỗi khi lấy dữ liệu reviews")
            return false;
        }

        View.showReview(res.data)
        return true;

    }

    static async SaveReview() {
        const api = new ReviewAPI();
        View.showLoading();

        const res = await api.PostReview()
        View.hideLoading();

        if (!res.ok) {
            View.showWarning("Găp sự cố khi save review");
            return false;
        }

        View.goTo(Pages.Page.GAME_DETAIL)
        return true;
    }


    // ======== Web client logic method
    static resetIdleTimer() {
        clearTimeout(Model.idleTimer);
        Model.idleTimer = setTimeout(() => {
            View.showWarning('Bạn đã quá thời gian chờ');
            Model.deleteAuthToken();
            View.goTo(Pages.Page.AUTH);
        }, Model.idleLimit);
    }
}
