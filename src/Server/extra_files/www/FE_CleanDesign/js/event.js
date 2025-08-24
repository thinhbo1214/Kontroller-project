import { Controller } from './controller.js';
import { View } from './view.js';
import { Model, Pages } from './model.js';

View.init();

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
    // ========== Element event ===========
    // ========== Auth ===========
    // Đăng nhập
    listenIfExists('#button-auth', 'click', () => {
        const username = document.getElementById('loginUsername')?.value || '';
        const password = document.getElementById('loginPassword')?.value || '';
        Controller.Login(username, password);
    });


    // ========== Register ===========
    // Đăng ký
    listenIfExists('#signupBtn', 'click', () => {
        const username = document.getElementById('signupUsername')?.value || '';
        const password = document.getElementById('signupPassword')?.value || '';
        const email = document.getElementById('signupEmail')?.value || '';
        Controller.Register(username, password, email);
    });

    // Quên mật khẩu
    listenIfExists('#forgotBtn', 'click', () => {
        const email = prompt('Please enter your email address:');
        if (email) {
            Controller.Forgot(email)
        }

    });


    // ========= Profile ===========

    // Lắng nghe sự kiện "change" để xem trước ảnh
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
    listenIfExists('#avatarPreview', 'click', () => {
        const editAvatar = document.getElementById('editAvatar');
        editAvatar.click();
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
    });

    // Ví dụ thêm: Đăng xuất
    listenIfExists('#button-logout', 'click', () => {
        Controller.Logout();
    });

    // EDIT PAGE
    listenIfExists('#editButton', 'click', () => {
        const editMode = document.getElementById('editMode');
        editMode.classList.remove('hidden');
    });

    // Change Password logic
    listenIfExists('#newPassword', 'input', () => {
        const oldPassword = document.getElementById('oldPassword');
        const newPassword = document.getElementById('newPassword');

        if (newPassword.value.trim() !== '') {
            oldPassword.removeAttribute('disabled');   // bật
        } else {
            oldPassword.setAttribute('disabled', true); // tắt
            oldPassword.value = ''; // clear luôn cho chắc
        }
    });

    listenIfExists('#cancelEdit', 'click', () => {
        const editMode = document.getElementById('editMode');
        editMode.classList.add('hidden');
    });

    // Lưu lại chỉnh sửa
    listenIfExists('#saveEdit', 'click', async () => {
        const avatar = document.getElementById('avatar');
        const usernameDisplay = document.getElementById('usernameDisplay');
        const editName = document.getElementById('editName');
        const editEmail = document.getElementById('editEmail');
        const oldPassword = document.getElementById('oldPassword');
        const newPassword = document.getElementById('newPassword');
        const userInfo = Model.getLocalStorageJSON('userInfo') || {};

        // Kiểm tra xem có file nào đã được chọn không
        if (Model.selectedFile) {
            // Gọi hàm xử lý chính với file đã được lưu
            if (await Controller.ChangeAvatar(Model.selectedFile, avatar)) {
                userInfo.Avatar = avatar.src;
            }
        }

        // Username
        if (editName && editName.value.trim() !== '') {
            if (await Controller.ChangeUsername(editName.value.trim())) {
                userInfo.Username = editName?.value.trim() || userInfo.Username;
                usernameDisplay.textContent = editName.value.trim();
            }

        }

        // Password
        if (newPassword && newPassword.value.trim() !== '') {
            if (oldPassword && oldPassword.value.trim() !== '') {
                if (await Controller.ChangePassword(oldPassword.value.trim(), newPassword.value.trim())) {
                    userInfo.Password = newPassword?.value.trim() || userInfo.Password;
                }
            } else {
                check = false;
                View.showWarning("Vui lòng nhập mật khẩu cũ để đổi mật khẩu");
            }
        }

        // Email
        if (editEmail && editEmail.value.trim() !== '') {
            if (await Controller.ChangeEmail(editEmail.value.trim())) {
                userInfo.Email = editEmail?.value.trim() || userInfo.Email;
            }

        }

        Model.setLocalStorageJSON('userInfo', userInfo);

        editMode.classList.add('hidden');
    });

    listenIfExists('#closeSearchPopup', 'click', () => {
        searchPopup.classList.remove('active');
    });

    listenIfExists('#searchInput', 'blur', () => {
        setTimeout(() => {
            searchPopup.classList.remove('active');
        }, 200);
    });

    listenIfExists('#closeSearchPopup', 'keypress', (e) => {
        const searchPopup = document.getElementById('searchPopup');
        const searchInput = document.getElementById('searchInput');

        searchPopup.classList.remove('active');

        if (e.key === 'Enter' && activePosterIndex !== null) {

        }
    });














    // ========= Review =============
    listenIfExists('#clearFilters', 'click', () => {

    });
    listenIfExists('#loadMoreBtn', 'click', () => {

    });
    listenIfExists('#addReviewBtn', 'click', () => {

    });
    listenIfExists('#closeModal', 'click', () => {

    });
    listenIfExists('#cancelReview', 'click', () => {

    });
    listenIfExists('#addReviewModal', 'click', () => {

    });

    // ======== Commment =============



    // ======== Reaction =============



    // ======== Follower ============


    // ======== Following ===========


    // ======== Home ===========


    listenIfExists('#pagination', 'click', (e) => {
        const btn = e.target.closest('button');
        if (!btn) return;

        const dataGame = Model.getLocalStorageJSON('gameData');
        const numberPage = dataGame.length / 10;
        // Nếu là nút số trang
        if (btn.classList.contains('page-btn')) {
            Model.currentPagination = parseInt(btn.dataset.page);

            Controller.GetGamePagination(Model.getLocalStorageJSON('gameData'), Model.currentPagination, 10);
            View.updatePaginationUI(Model.currentPagination, numberPage);
        }

        // Nếu là nút prev
        if (btn.classList.contains('pagePrev')) {
            // TODO: xử lý prev
        }

        // Nếu là nút next
        if (btn.classList.contains('pageNext')) {
            // TODO: xử lý next
        }
    });


    // ========  Game-Detail ==========
    listenIfExists('#Savebtn', 'click', () => {
        // Controller.
    })

    // ======== Game-Review =========



    // ======== 


    // ========= Window event =========
    listenWindow('load', () => {
        View.showLoading();
        const page = View.getPageNow();
        Controller.ShowUserInfo();

        const token = Model.getAuthToken();
        if (token != null) {
            if (Model.isAuthTokenValid(token)) {
                if (page == Pages.Page.INDEX || page == Pages.Page.AUTH || page == Pages.Page.REGISTER)
                    View.goTo(Pages.Page.HOME);
            } else {
                Model.deleteAuthToken();
                if (page != Pages.Page.INDEX && page != Pages.Page.AUTH && page != Pages.Page.REGISTER)
                    View.goTo(Pages.Page.AUTH);
            }
        }

        const curPage = View.getPageNow();
        if (curPage == Pages.Page.HOME) {
            Controller.LoadHomeContent(Model.currentPagination, 10);
        }

        setTimeout(() => View.hideLoading(), 250);
    });

    window.addEventListener('pageshow', (event) => {
        if (event.persisted) {
            window.location.reload();
        }
    });

    listenWindow('offline', () => {
        View.showWarning('Bạn đang ngoại tuyến');
        console.log('Offline event fired');
    });

    listenWindow('online', () => {
        View.showSuccess('Bạn đã kết nối lại internet');
        console.log('Online event fired');
    });

    ['mousemove', 'keydown', 'scroll', 'click'].forEach(event => {
        listenWindow(event, () => {
            Controller.resetIdleTimer()
        });
    });

    Controller.resetIdleTimer();
});