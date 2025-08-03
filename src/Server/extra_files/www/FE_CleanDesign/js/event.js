import { Auth } from './auth.js';
import { UI } from './ui.js';

class EventHandler {
    constructor() {
        this.init();
    }

    init() {
        // Wait for DOM to be ready
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => this.bindEvents());
        } else {
            this.bindEvents();
        }
    }

    bindEvents() {
        // Initialize Lucide icons
        lucide.createIcons();

        // Get elements
        const elements = {
            backBtn: document.getElementById('backBtn'),
            signupForm: document.getElementById('signupForm'),
            togglePasswordBtn: document.getElementById('togglePasswordBtn'),
            signupEmail: document.getElementById('signupEmail')
        };

        // Back button
        elements.backBtn?.addEventListener('click', this.handleBack);

        // Signup form
        elements.signupForm?.addEventListener('submit', this.handleSignupSubmit);

        // Password toggle
        elements.togglePasswordBtn?.addEventListener('click', this.handlePasswordToggle);

        // Email validation
        elements.signupEmail?.addEventListener('blur', this.handleEmailValidation);

        // Global keyboard events
        document.addEventListener('keydown', this.handleKeydown);
    }

    // Event handlers
    handleBack = () => {
        window.location.href = 'index.html';
    }

    handleSignupSubmit = async (e) => {
        e.preventDefault();
        
        const formData = new FormData(e.target);
        const username = document.getElementById('signupUsername').value;
        const email = document.getElementById('signupEmail').value;
        const password = document.getElementById('signupPassword').value;

        await Auth.signup(username, email, password);
    }

    handlePasswordToggle = (e) => {
        const button = e.currentTarget;
        const targetId = button.dataset.target;
        UI.togglePassword(targetId, button);
    }

    handleEmailValidation = (e) => {
        const email = e.target.value;
        if (email && !UI.validateEmail(email)) {
            e.target.style.borderColor = '#ef4444';
            e.target.style.boxShadow = '0 0 0 2px rgba(239, 68, 68, 0.3)';
        } else {
            e.target.style.borderColor = 'rgba(255, 255, 255, 0.2)';
            e.target.style.boxShadow = 'none';
        }
    }

    handleKeydown = (e) => {
        // Enter key for signup form inputs
        if (e.key === 'Enter' && this.isSignupInput(e.target)) {
            e.preventDefault();
            document.getElementById('signupForm').dispatchEvent(new Event('submit'));
        }
    }

    // Helper methods
    isSignupInput(element) {
        const signupInputIds = ['signupUsername', 'signupEmail', 'signupPassword'];
        return signupInputIds.includes(element.id);
    }
}

// Initialize event handler
new EventHandler();