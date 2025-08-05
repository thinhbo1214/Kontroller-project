import { Handle } from './handle.js';

// Hàm tiện ích: chỉ thêm sự kiện nếu phần tử tồn tại
function listenIfExists(selector, event, handler) {
    const element = document.querySelector(selector);
    if (element) {
        element.addEventListener(event, handler);
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

    listenIfExists('#createListBtn', 'click', () => {
        
    });



    // Thêm các listener khác tùy bạn

    
});