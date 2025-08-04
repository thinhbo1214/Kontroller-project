import { Handle } from './handle.js';
import { UI } from './ui.js';

// cach them su kien moi gom 3 cach
// 1 Thêm case mới trong handleGlobalClick
// 2 Tạo handler method tương ứng
// 3 Thêm ID hoặc data-click attribute cho element

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
        // Initialize Lucide icons if available
        if (typeof lucide !== 'undefined') {
            lucide.createIcons();
        }

        // Global click event listener using event delegation
        document.addEventListener('click', this.handleGlobalClick);
        
        // Global form submit listener
        document.addEventListener('submit', this.handleGlobalSubmit);
        
        // Global input events for real-time validation
        document.addEventListener('input', this.handleGlobalInput);
        document.addEventListener('blur', this.handleGlobalBlur);
        
        // Global keyboard events
        document.addEventListener('keydown', this.handleGlobalKeydown);
    }

    // Global click handler - routes all click events
    handleGlobalClick = (e) => {
        const target = e.target;
        const action = target.dataset.click || target.id || target.className;

        // Route based on data-click attribute, ID, or specific classes
        switch (true) {
            // Back navigation
            case action.includes('back') || action.includes('backBtn'):
                Handle.handleBack(e);
                break;

            // Authentication actions
            case action.includes('signup') || action.includes('signupBtn'):
                Handle.handleSignup(e);
                break;

            case action.includes('login') || action.includes('loginBtn'):
                Handle.handleLogin(e);
                break;

            case action.includes('logout') || action.includes('logoutBtn'):
                Handle.handleLogout(e);
                break;

            // Password toggle
            case action.includes('toggle-password') || action.includes('togglePasswordBtn'):
                Handle.handlePasswordToggle(e);
                break;

            // Modal controls
            case action.includes('modal-open'):
                Handle.handleModalOpen(e);
                break;

            case action.includes('modal-close'):
                Handle.handleModalClose(e);
                break;

            // Tab switching
            case action.includes('tab-'):
                Handle.handleTabSwitch(e);
                break;

            // Generic button actions
            case target.tagName === 'BUTTON' && target.type === 'button':
                Handle.handleGenericButton(e);
                break;

            // Links with data-action
            case target.tagName === 'A' && target.dataset.action:
                e.preventDefault();
                Handle.handleLinkAction(e);
                break;

            default:
                // Let other clicks pass through
                break;
        }
    }

    // Global form submit handler
    handleGlobalSubmit = (e) => {
        const form = e.target;
        const formId = form.id;
        const formAction = form.dataset.action;

        // Route form submissions
        switch (formId || formAction) {
            case 'signupForm':
            case 'signup':
                e.preventDefault();
                Handle.handleSignupSubmit(e);
                break;

            case 'loginForm':
            case 'login':
                e.preventDefault();
                Handle.handleLoginSubmit(e);
                break;

            case 'contactForm':
            case 'contact':
                e.preventDefault();
                Handle.handleContactSubmit(e);
                break;

            default:
                // Let other forms submit normally or handle generically
                if (form.dataset.preventDefault === 'true') {
                    e.preventDefault();
                    Handle.handleGenericForm(e);
                }
                break;
        }
    }

    // Global input handler for real-time validation
    handleGlobalInput = (e) => {
        const target = e.target;
        const inputType = target.type;
        const inputId = target.id;

        switch (inputType) {
            case 'email':
                Handle.handleEmailInput(e);
                break;
            
            case 'password':
                Handle.handlePasswordInput(e);
                break;
            
            case 'text':
                if (inputId.includes('username')) {
                    Handle.handleUsernameInput(e);
                }
                break;

            default:
                // Generic input handling if needed
                break;
        }
    }

    // Global blur handler for validation
    handleGlobalBlur = (e) => {
        const target = e.target;
        
        if (target.tagName === 'INPUT' || target.tagName === 'TEXTAREA') {
            Handle.handleInputValidation(e);
        }
    }

    // Global keyboard handler
    handleGlobalKeydown = (e) => {
        switch (e.key) {
            case 'Enter':
                if (this.isFormInput(e.target)) {
                    Handle.handleEnterKey(e);
                }
                break;
            
            case 'Escape':
                Handle.handleEscapeKey(e);
                break;
            
            case 'Tab':
                // Handle tab navigation if needed
                break;

            default:
                break;
        }
    }

    // Helper methods
    isFormInput(element) {
        return ['INPUT', 'TEXTAREA', 'SELECT'].includes(element.tagName);
    }

    // Method to manually trigger events (useful for programmatic calls)
    triggerEvent(eventType, selector, data = {}) {
        const element = document.querySelector(selector);
        if (element) {
            const event = new CustomEvent(eventType, { detail: data });
            element.dispatchEvent(event);
        }
    }

    // Method to add dynamic event listeners
    addClickHandler(selector, handler) {
        document.addEventListener('click', (e) => {
            if (e.target.matches(selector)) {
                handler(e);
            }
        });
    }
}

// Initialize and export
const Events = new EventHandler();
export { Events };