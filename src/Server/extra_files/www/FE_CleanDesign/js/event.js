import { Auth } from './auth.js';
import { UI } from './ui.js';

class ClickHandler {
    constructor() {
        this.init();
    }

    init() {
        // Wait for DOM to be ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.bindClickEvents());
        } else {
            this.bindClickEvents();
        }
    }

    bindClickEvents() {
        // Initialize Lucide icons
        lucide.createIcons();

        // Bind all click events using event delegation
        document.addEventListener('click', this.handleGlobalClick);
    }

    handleGlobalClick = (e) => {
        const target = e.target;
        const clickAction = target.dataset.click || target.id;

        // Route click events based on element ID or data-click attribute
        switch (clickAction) {
            case 'backBtn':
            case 'back':
                this.handleBack(e);
                break;
            
            case 'signupBtn':
            case 'signup':
                this.handleSignup(e);
                break;
            
            case 'togglePasswordBtn':
            case 'toggle-password':
                this.handlePasswordToggle(e);
                break;
            
            case 'loginBtn':
            case 'login':
                this.handleLogin(e);
                break;
            
            case 'logoutBtn':
            case 'logout':
                this.handleLogout(e);
                break;
            
            default:
                // Handle form submissions
                if (target.type === 'submit') {
                    this.handleFormSubmit(e);
                }
                break;
        }
    }

    // Click event handlers
    handleBack = (e) => {
        e.preventDefault();
        window.location.href = 'index.html';
    }

    handleSignup = async (e) => {
        e.preventDefault();
        
        const username = document.getElementById('signupUsername')?.value;
        const email = document.getElementById('signupEmail')?.value;
        const password = document.getElementById('signupPassword')?.value;

        if (username && email && password) {
            await Auth.signup(username, email, password);
        }
    }

    handleLogin = async (e) => {
        e.preventDefault();
        
        const email = document.getElementById('loginEmail')?.value;
        const password = document.getElementById('loginPassword')?.value;

        if (email && password) {
            await Auth.login(email, password);
        }
    }

    handleLogout = async (e) => {
        e.preventDefault();
        await Auth.logout();
    }

    handlePasswordToggle = (e) => {
        e.preventDefault();
        const button = e.target;
        const targetId = button.dataset.target;
        UI.togglePassword(targetId, button);
    }

    handleFormSubmit = async (e) => {
        const form = e.target.closest('form');
        if (!form) return;

        e.preventDefault();
        
        switch (form.id) {
            case 'signupForm':
                this.handleSignup(e);
                break;
            case 'loginForm':
                this.handleLogin(e);
                break;
        }
    }

    // Utility methods
    validateEmail(email) {
        return UI.validateEmail ? UI.validateEmail(email) : /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    showError(message) {
        console.error(message);
        // Add your error display logic here
    }

    showSuccess(message) {
        console.log(message);
        // Add your success display logic here
    }
}

// Initialize click handler
new ClickHandler();