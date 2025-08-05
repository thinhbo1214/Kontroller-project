import { Handle } from './handle.js';
import { UIManager } from './ui.js';

// Initialize and export
const UI = new UIManager();


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
        Handle.Login(username, password);
    });

    // Đăng ký
    listenIfExists('#button-register', 'click', () => {
        const username = document.getElementById('signupUsername')?.value || '';
        const password = document.getElementById('signupPassword')?.value || '';
        const email = document.getElementById('signupEmail')?.value || '';
        Handle.Register(username, password, email);
    });

    // Ví dụ thêm: Đăng xuất
    listenIfExists('#button-logout', 'click', () => {
        Handle.Logout();
    });

    // Ví dụ khác: Tải profile
    listenIfExists('#load-profile', 'click', () => {
        Handle.LoadProfile();
    });

    // Thêm các listener khác tùy bạn

    //-----------------------------------------------//
    listenWindow('load', () => {
        UI.showLoading();
        setTimeout(() => UI.hideLoading(), 2000);
    });
});