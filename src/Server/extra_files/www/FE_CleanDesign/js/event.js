// event.js - Xử lý các sự kiện trên trang đăng nhập
import { LoginAPI } from './api.js';
import { AuthHandler } from './handle.js';
import { UIManager } from './ui.js';

class EventManager {
    constructor() {
        this.loginAPI = new LoginAPI();
        this.authHandler = new AuthHandler();
        this.uiManager = new UIManager();
        this.init();
    }

    init() {
        this.bindEvents();
        this.setupKeyboardEvents();
    }

    bindEvents() {
        // Bind login button click event
        const loginButton = document.getElementById('button-auth');
        if (loginButton) {
            loginButton.addEventListener('click', (e) => {
                e.preventDefault();
                this.handleLoginClick();
            });
        }

        // Bind password toggle events
        const toggleButtons = document.querySelectorAll('.toggle-password');
        toggleButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                const inputId = e.target.closest('button').previousElementSibling.id || 
                              e.target.closest('button').parentElement.querySelector('input').id;
                this.togglePasswordVisibility(inputId, e.target.closest('button'));
            });
        });

        // Bind input field events for validation
        const usernameInput = document.getElementById('loginUsername');
        const passwordInput = document.getElementById('loginPassword');

        if (usernameInput) {
            usernameInput.addEventListener('blur', () => {
                this.validateUsername();
            });
            usernameInput.addEventListener('input', () => {
                this.clearFieldError('loginUsername');
            });
        }

        if (passwordInput) {
            passwordInput.addEventListener('blur', () => {
                this.validatePassword();
            });
            passwordInput.addEventListener('input', () => {
                this.clearFieldError('loginPassword');
            });
        }

        // Bind forgot password
        const forgotLink = document.querySelector('[onclick="showForgotPassword()"]');
        if (forgotLink) {
            forgotLink.removeAttribute('onclick');
            forgotLink.addEventListener('click', (e) => {
                e.preventDefault();
                this.handleForgotPassword();
            });
        }
    }

    setupKeyboardEvents() {
        // Enter key for login
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Enter') {
                const activeElement = document.activeElement;
                if (activeElement && 
                   (activeElement.id === 'loginUsername' || activeElement.id === 'loginPassword')) {
                    e.preventDefault();
                    this.handleLoginClick();
                }
            }
        });

        // Escape key to clear errors
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.uiManager.clearAllErrors();
            }
        });
    }

    async handleLoginClick() {
        try {
            // Validate inputs first
            if (!this.validateInputs()) {
                return;
            }

            const username = document.getElementById('loginUsername').value.trim();
            const password = document.getElementById('loginPassword').value;

            // Show loading
            this.uiManager.showLoading();
            
            // Disable button to prevent double submission
            this.uiManager.setButtonState('button-auth', false);

            // Call login API
            const result = await this.authHandler.login(username, password);
            
            if (result.success) {
                this.uiManager.showSuccess('Login successful! Redirecting...');
                // Redirect after short delay
                setTimeout(() => {
                    window.location.href = 'profile.html';
                }, 1500);
            } else {
                this.uiManager.showError(result.message || 'Login failed. Please check your credentials.');
                this.uiManager.setButtonState('button-auth', true);
            }

        } catch (error) {
            console.error('Login error:', error);
            this.uiManager.showError('An unexpected error occurred. Please try again.');
            this.uiManager.setButtonState('button-auth', true);
        } finally {
            this.uiManager.hideLoading();
        }
    }

    validateInputs() {
        const username = document.getElementById('loginUsername').value.trim();
        const password = document.getElementById('loginPassword').value;
        
        let isValid = true;

        // Clear previous errors
        this.uiManager.clearAllErrors();

        // Validate username
        if (!username) {
            this.uiManager.showFieldError('loginUsername', 'Username is required');
            isValid = false;
        } else if (username.length < 3) {
            this.uiManager.showFieldError('loginUsername', 'Username must be at least 3 characters');
            isValid = false;
        }

        // Validate password
        if (!password) {
            this.uiManager.showFieldError('loginPassword', 'Password is required');
            isValid = false;
        } else if (password.length < 4) {
            this.uiManager.showFieldError('loginPassword', 'Password must be at least 4 characters');
            isValid = false;
        }

        return isValid;
    }

    validateUsername() {
        const username = document.getElementById('loginUsername').value.trim();
        if (username && username.length < 3) {
            this.uiManager.showFieldError('loginUsername', 'Username must be at least 3 characters');
            return false;
        }
        return true;
    }

    validatePassword() {
        const password = document.getElementById('loginPassword').value;
        if (password && password.length < 4) {
            this.uiManager.showFieldError('loginPassword', 'Password must be at least 4 characters');
            return false;
        }
        return true;
    }

    clearFieldError(fieldId) {
        this.uiManager.clearFieldError(fieldId);
    }

    togglePasswordVisibility(inputId, button) {
        const input = document.getElementById(inputId);
        const icon = button.querySelector('i');
        
        if (input.type === 'password') {
            input.type = 'text';
            icon.setAttribute('data-lucide', 'eye-off');
        } else {
            input.type = 'password';
            icon.setAttribute('data-lucide', 'eye');
        }
        
        // Recreate icons
        if (window.lucide) {
            window.lucide.createIcons();
        }
    }

    handleForgotPassword() {
        this.uiManager.showForgotPasswordModal();
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new EventManager();
});

export { EventManager };