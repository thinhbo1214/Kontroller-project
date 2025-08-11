import { Controller } from './controller.js';
import { View, Pages } from './view.js';
import { Model } from './model.js';

// Hàm tiện ích: chỉ thêm sự kiện nếu phần tử tồn tại
function listenIfExists(selector, event, handler) {
    const element = document.querySelector(selector);
    if (element) {
        element.addEventListener(event, handler);
    }
}

// Hàm tiện ích: Thêm listener vào window nếu tồn tại (luôn tồn tại)
function listenWindow(event, handler) {
    if (typeof handler === 'function') {
        window.addEventListener(event, handler);
    }
}

document.addEventListener('DOMContentLoaded', () => {
    // Đăng nhập
    listenIfExists('#button-auth', 'click', () => {
        const username = document.getElementById('loginUsername')?.value || '';
        const password = document.getElementById('loginPassword')?.value || '';
        Controller.Login(username, password);
    });

    // Đăng ký
    listenIfExists('#signupBtn', 'click', () => {
        const username = document.getElementById('signupUsername')?.value || '';
        const password = document.getElementById('signupPassword')?.value || '';
        const email = document.getElementById('signupEmail')?.value || '';
        Controller.Register(username, password, email);
    });
    // Quen mat khua 
    listenIfExists('#forgotBtn', 'click', () => {
        const email = prompt('Please enter your email address:');
        if (email) {
            alert('Password reset link will be sent to your email.');
            Controller.Forgot(email)
        }

    });

    // 1. Lắng nghe sự kiện "change" để xem trước ảnh
    listenIfExists('#editAvatar', 'change', (e) => {
        const file = e.target.files[0];
        const preview = document.getElementById('avatarPreview');

        if (file && file.type.startsWith('image/')) {
            // Gán file vào biến toàn cục để có thể sử dụng sau
            Model.selectedFile = file;

            // Tạo URL xem trước và hiển thị
            const reader = new FileReader();
            reader.onload = (e) => {
                preview.src = e.target.result;
            };
            reader.readAsDataURL(file);
        } else {
            // Nếu file không hợp lệ, reset biến và ảnh preview
            Model.selectedFile = null;
            // Bạn có thể reset preview.src về ảnh avatar cũ ở đây
        }
    });

    listenIfExists('#saveEdit', 'click', () => {
        const avatar = document.getElementById('avatar');

        // Kiểm tra xem có file nào đã được chọn không
        if (Model.selectedFile) {
            // Gọi hàm xử lý chính với file đã được lưu
            Controller.ChangeAvatar(Model.selectedFile, avatar);
        }
    });

    // hienej thi thong tin 
    listenIfExists('#BioShow', 'click', () => {
        const EditBtn = document.getElementById('BioShow')?.value || '';
        const userID = document.getElementById('')
        Controller.ShowEdit(userID)
    });
    // xóa tài khoản 
    listenIfExists('#deleteAccount', 'click', () => {
        const passwordInput = document.getElementById('deletePassword'); // 
        const password = passwordInput.value;

        if (!password) {
            View.showWarning("Vui lòng nhập mật khẩu");
            return;
        }

        if (confirm("Bạn có chắc chắn muốn xóa tài khoản? Hành động này không thể hoàn tác.")) {
            Controller.DeleteAcc(password);
        }
    })
    // Ví dụ thêm: Đăng xuất
    listenIfExists('#button-logout', 'click', () => {
        Controller.Logout();
    });

    listenIfExists('#createListBtn', 'click', () => {

    });



    // Thêm các listener khác tùy bạn

    //-----------------------------------------------//

    //lấy token load page (tạm thời mới chỉ load đc profile)
    listenWindow('load', () => {
        const page = View.getPageNow();

        const token = Model.getAuthToken();
        if (token != null) {
            if (Model.isAuthTokenValid(token)) {
                if (page == Pages.INDEX || page == Pages.AUTH || page == Pages.REGISTER)
                    View.goTo(Pages.PROFILE);
            } else {
                Model.deleteAuthToken();
                if (page != Pages.INDEX && page != Pages.AUTH && page != Pages.REGISTER)
                    View.goTo(Pages.AUTH);

            }
        }

        View.showLoading();
        setTimeout(() => View.hideLoading(), 500);
    })
});