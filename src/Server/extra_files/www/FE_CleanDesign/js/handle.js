import { API } from './api.js';
import { UI } from './ui.js';

class HandleManager {
    constructor() {
        this.currentModal = null;
        this.currentTab = null;
    }

    // Navigation handlers
    handleBack = (e) => {
        e.preventDefault();
        const target = e.target.dataset.target || 'index.html';
        window.location.href = target;
    }

    // Authentication handlers
    handleSignup = async (e) => {
        e.preventDefault();
        
        const form = document.getElementById('signupForm');
        if (form) {
            this.handleSignupSubmit({ target: form });
        }
    }

    handleSignupSubmit = async (e) => {
        const form = e.target;
        const formData = new FormData(form);
        
        const userData = {
            username: formData.get('username') || document.getElementById('signupUsername')?.value,
            email: formData.get('email') || document.getElementById('signupEmail')?.value,
            password: formData.get('password') || document.getElementById('signupPassword')?.value
        };

        // Validate data
        if (!this.validateSignupData(userData)) {
            return;
        }

        try {
            UI.showLoading(true);
            const result = await API.signup(userData);
            
            if (result.success) {
                UI.showSuccess('Đăng ký thành công!');
                setTimeout(() => window.location.href = 'login.html', 2000);
            } else {
                UI.showError(result.message || 'Đăng ký thất bại');
            }
        } catch (error) {
            UI.showError('Có lỗi xảy ra: ' + error.message);
        } finally {
            UI.showLoading(false);
        }
    }

    handleLogin = async (e) => {
        e.preventDefault();
        
        const form = document.getElementById('loginForm');
        if (form) {
            this.handleLoginSubmit({ target: form });
        }
    }

    handleLoginSubmit = async (e) => {
        const form = e.target;
        const formData = new FormData(form);
        
        const loginData = {
            email: formData.get('email') || document.getElementById('loginEmail')?.value,
            password: formData.get('password') || document.getElementById('loginPassword')?.value
        };

        if (!this.validateLoginData(loginData)) {
            return;
        }

        try {
            UI.showLoading(true);
            const result = await API.login(loginData);
            
            if (result.success) {
                UI.showSuccess('Đăng nhập thành công!');
                setTimeout(() => window.location.href = 'dashboard.html', 1500);
            } else {
                UI.showError(result.message || 'Đăng nhập thất bại');
            }
        } catch (error) {
            UI.showError('Có lỗi xảy ra: ' + error.message);
        } finally {
            UI.showLoading(false);
        }
    }

    handleLogout = async (e) => {
        e.preventDefault();
        
        try {
            const result = await API.logout();
            if (result.success) {
                UI.showSuccess('Đăng xuất thành công!');
                setTimeout(() => window.location.href = 'index.html', 1000);
            }
        } catch (error) {
            UI.showError('Có lỗi khi đăng xuất');
        }
    }

    // UI handlers
    handlePasswordToggle = (e) => {
        e.preventDefault();
        const button = e.target.closest('button');
        const targetId = button.dataset.target;
        
        if (targetId) {
            UI.togglePassword(targetId, button);
        }
    }

    handleModalOpen = (e) => {
        e.preventDefault();
        const modalId = e.target.dataset.modal;
        if (modalId) {
            this.currentModal = modalId;
            UI.showModal(modalId);
        }
    }

    handleModalClose = (e) => {
        e.preventDefault();
        if (this.currentModal) {
            UI.hideModal(this.currentModal);
            this.currentModal = null;
        }
    }

    handleTabSwitch = (e) => {
        e.preventDefault();
        const tabId = e.target.dataset.tab;
        if (tabId) {
            UI.switchTab(tabId);
            this.currentTab = tabId;
        }
    }

    // Input handlers
    handleEmailInput = (e) => {
        const email = e.target.value;
        const isValid = this.validateEmail(email);
        UI.updateInputValidation(e.target, isValid, 'Email không hợp lệ');
    }

    handlePasswordInput = (e) => {
        const password = e.target.value;
        const strength = this.getPasswordStrength(password);
        UI.updatePasswordStrength(e.target, strength);
    }

    handleUsernameInput = (e) => {
        const username = e.target.value;
        const isValid = username.length >= 3;
        UI.updateInputValidation(e.target, isValid, 'Tên người dùng phải có ít nhất 3 ký tự');
    }

    handleInputValidation = (e) => {
        const input = e.target;
        const value = input.value.trim();
        
        switch (input.type) {
            case 'email':
                const emailValid = this.validateEmail(value);
                UI.updateInputValidation(input, emailValid, 'Email không hợp lệ');
                break;
                
            case 'password':
                const passwordValid = value.length >= 6;
                UI.updateInputValidation(input, passwordValid, 'Mật khẩu phải có ít nhất 6 ký tự');
                break;
                
            default:
                if (input.required && !value) {
                    UI.updateInputValidation(input, false, 'Trường này là bắt buộc');
                } else {
                    UI.updateInputValidation(input, true);
                }
                break;
        }
    }

    // Keyboard handlers
    handleEnterKey = (e) => {
        const form = e.target.closest('form');
        if (form) {
            e.preventDefault();
            const submitBtn = form.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.click();
            }
        }
    }

    handleEscapeKey = (e) => {
        // Close modals on escape
        if (this.currentModal) {
            this.handleModalClose(e);
        }
    }

    // Generic handlers
    handleGenericButton = (e) => {
        const button = e.target;
        const action = button.dataset.action;
        
        if (action) {
            // Handle custom actions
            console.log('Generic button action:', action);
        }
    }

    handleLinkAction = (e) => {
        const link = e.target;
        const action = link.dataset.action;
        
        switch (action) {
            case 'scroll-to':
                const target = link.dataset.target;
                UI.scrollToElement(target);
                break;
                
            default:
                console.log('Link action:', action);
                break;
        }
    }

    handleGenericForm = async (e) => {
        const form = e.target;
        const action = form.dataset.action;
        
        console.log('Generic form submission:', action);
        // Handle generic form submissions
    }

    handleContactSubmit = async (e) => {
        const form = e.target;
        const formData = new FormData(form);
        
        const contactData = {
            name: formData.get('name'),
            email: formData.get('email'),
            message: formData.get('message')
        };

        try {
            UI.showLoading(true);
            const result = await API.contact(contactData);
            
            if (result.success) {
                UI.showSuccess('Tin nhắn đã được gửi thành công!');
                form.reset();
            } else {
                UI.showError('Có lỗi khi gửi tin nhắn');
            }
        } catch (error) {
            UI.showError('Có lỗi xảy ra: ' + error.message);
        } finally {
            UI.showLoading(false);
        }
    }

    // Validation methods
    validateEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    validateSignupData(data) {
        if (!data.username || data.username.length < 3) {
            UI.showError('Tên người dùng phải có ít nhất 3 ký tự');
            return false;
        }
        
        if (!this.validateEmail(data.email)) {
            UI.showError('Email không hợp lệ');
            return false;
        }
        
        if (!data.password || data.password.length < 6) {
            UI.showError('Mật khẩu phải có ít nhất 6 ký tự');
            return false;
        }
        
        return true;
    }

    validateLoginData(data) {
        if (!this.validateEmail(data.email)) {
            UI.showError('Email không hợp lệ');
            return false;
        }
        
        if (!data.password) {
            UI.showError('Vui lòng nhập mật khẩu');
            return false;
        }
        
        return true;
    }

    getPasswordStrength(password) {
        let strength = 0;
        if (password.length >= 8) strength++;
        if (/[a-z]/.test(password)) strength++;
        if (/[A-Z]/.test(password)) strength++;
        if (/[0-9]/.test(password)) strength++;
        if (/[^A-Za-z0-9]/.test(password)) strength++;
        
        return strength;
    }
}

// Initialize and export
const Handle = new HandleManager();
export { Handle };