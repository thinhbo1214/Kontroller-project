import { Handle } from './handle.js';
import { UI } from './ui.js';



// Tất cả sự kiện được xử lý thông qua một listener duy nhất
// Extended event handler for Lists page and other functionalities
class EventHandler {
    constructor() {
        this.init();
    }

    init() {
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

        // Global event listeners using event delegation
        document.addEventListener('click', this.handleGlobalClick);
        document.addEventListener('submit', this.handleGlobalSubmit);
        document.addEventListener('input', this.handleGlobalInput);
        document.addEventListener('blur', this.handleGlobalBlur);
        document.addEventListener('keydown', this.handleGlobalKeydown);
        document.addEventListener('change', this.handleGlobalChange);
    }

    // Enhanced global click handler
    handleGlobalClick = (e) => {
        const target = e.target.closest('[data-click], [id], button, a');
        if (!target) return;

        const action = target.dataset.click || target.id || target.className;

        // Route click events
        switch (true) {
            // Navigation
            case action.includes('back') || action.includes('backBtn'):
                Handle.handleBack(e);
                break;

            // Authentication
            case action.includes('signup') || action.includes('signupBtn'):
                Handle.handleSignup(e);
                break;

            case action.includes('login') || action.includes('loginBtn'):
                Handle.handleLogin(e);
                break;

            case action.includes('logout') || action.includes('logoutBtn'):
                Handle.handleLogout(e);
                break;

            // Lists functionality
            case action.includes('createListBtn') || target.id === 'createListBtn':
                Handle.handleCreateList(e);
                break;

            case action.includes('list-card') || target.classList.contains('list-card'):
                Handle.handleListClick(e);
                break;

            case action.includes('addGameToList'):
                const gameId = parseInt(target.dataset.gameId);
                if (gameId) Handle.handleAddGameToList(gameId);
                break;

            case action.includes('removeGameFromList'):
                const removeGameId = parseInt(target.dataset.gameId);
                if (removeGameId) Handle.handleRemoveGameFromList(removeGameId);
                break;

            case action.includes('removeTag'):
                const tag = target.dataset.tag;
                if (tag) Handle.handleRemoveTag(tag);
                break;

            case action.includes('likeList'):
                Handle.handleLikeList(e);
                break;

            case action.includes('shareList'):
                Handle.handleShareList(e);
                break;

            // Modal controls
            case action.includes('modal-close') || action.includes('closeModal') || 
                 target.id === 'closeModal' || target.id === 'closeDetailModal':
                Handle.handleModalClose(e);
                break;

            case action.includes('modal-open'):
                Handle.handleModalOpen(e);
                break;

            // Password toggle
            case action.includes('toggle-password') || action.includes('togglePasswordBtn'):
                Handle.handlePasswordToggle(e);
                break;

            // Tab switching
            case action.includes('tab-'):
                Handle.handleTabSwitch(e);
                break;

            // Generic handlers
            case target.tagName === 'BUTTON' && target.type === 'button':
                this.handleButtonClick(e);
                break;

            case target.tagName === 'A' && target.dataset.action:
                e.preventDefault();
                Handle.handleLinkAction(e);
                break;

            default:
                break;
        }
    }

    // Enhanced global form submit handler
    handleGlobalSubmit = (e) => {
        const form = e.target;
        const formId = form.id;
        const formAction = form.dataset.action;

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

            case 'createListForm':
            case 'createList':
                e.preventDefault();
                Handle.handleCreateListSubmit(e);
                break;

            case 'contactForm':
            case 'contact':
                e.preventDefault();
                Handle.handleContactSubmit(e);
                break;

            default:
                if (form.dataset.preventDefault === 'true') {
                    e.preventDefault();
                    Handle.handleGenericForm(e);
                }
                break;
        }
    }

    // Enhanced global input handler
    handleGlobalInput = (e) => {
        const target = e.target;
        const inputType = target.type;
        const inputId = target.id;

        // Route input events
        switch (true) {
            case inputType === 'email':
                Handle.handleEmailInput(e);
                break;
            
            case inputType === 'password':
                Handle.handlePasswordInput(e);
                break;
            
            case inputType === 'text' && inputId.includes('username'):
                Handle.handleUsernameInput(e);
                break;

            // Lists specific inputs
            case inputId === 'gameSearch':
                this.debounce(() => Handle.handleGameSearch(e), 300);
                break;

            case inputId === 'tagInput':
                // Tag input is handled in keydown for Enter/comma
                break;

            case inputId === 'listTitle':
                this.updateCharacterCount(target, 100);
                break;

            case inputId === 'listDescription':
                this.updateCharacterCount(target, 500);
                break;

            default:
                break;
        }
    }

    // Global blur handler
    handleGlobalBlur = (e) => {
        const target = e.target;
        
        if (target.tagName === 'INPUT' || target.tagName === 'TEXTAREA') {
            // Special handling for tag input
            if (target.id === 'tagInput') {
                Handle.handleTagInputBlur(e);
            } else {
                Handle.handleInputValidation(e);
            }
        }
    }

    // Enhanced global keyboard handler
    handleGlobalKeydown = (e) => {
        const target = e.target;

        switch (e.key) {
            case 'Enter':
                if (target.id === 'tagInput') {
                    Handle.handleTagInput(e);
                } else if (this.isFormInput(target)) {
                    Handle.handleEnterKey(e);
                }
                break;
            
            case ',':
                if (target.id === 'tagInput') {
                    Handle.handleTagInput(e);
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

    // Global change handler
    handleGlobalChange = (e) => {
        const target = e.target;

        switch (target.id) {
            case 'sortSelect':
                Handle.handleSortChange(e);
                break;

            default:
                break;
        }
    }

    // Helper method for button clicks
    handleButtonClick = (e) => {
        const button = e.target;
        const action = button.dataset.action;
        
        // Handle specific button actions
        switch (action) {
            case 'add-game':
                const gameId = parseInt(button.dataset.gameId);
                if (gameId) Handle.handleAddGameToList(gameId);
                break;

            case 'remove-game':
                const removeGameId = parseInt(button.dataset.gameId);
                if (removeGameId) Handle.handleRemoveGameFromList(removeGameId);
                break;

            case 'remove-tag':
                const tag = button.dataset.tag;
                if (tag) Handle.handleRemoveTag(tag);
                break;

            default:
                Handle.handleGenericButton(e);
                break;
        }
    }

    // Utility methods
    isFormInput(element) {
        return ['INPUT', 'TEXTAREA', 'SELECT'].includes(element.tagName);
    }

    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    }

    updateCharacterCount(input, maxLength) {
        const remaining = maxLength - input.value.length;
        const counter = input.parentElement.querySelector('.char-counter');
        
        if (counter) {
            counter.textContent = `${remaining} characters remaining`;
            counter.className = remaining < 10 ? 'char-counter text-xs text-red-400 mt-1' : 'char-counter text-xs text-gray-400 mt-1';
        }
    }

    // Method to add dynamic event listeners
    addClickHandler(selector, handler) {
        document.addEventListener('click', (e) => {
            if (e.target.matches(selector) || e.target.closest(selector)) {
                handler(e);
            }
        });
    }

    // Method to trigger custom events
    triggerEvent(eventType, selector, data = {}) {
        const element = document.querySelector(selector);
        if (element) {
            const event = new CustomEvent(eventType, { detail: data });
            element.dispatchEvent(event);
        }
    }

    // Cleanup method
    cleanup() {
        document.removeEventListener('click', this.handleGlobalClick);
        document.removeEventListener('submit', this.handleGlobalSubmit);
        document.removeEventListener('input', this.handleGlobalInput);
        document.removeEventListener('blur', this.handleGlobalBlur);
        document.removeEventListener('keydown', this.handleGlobalKeydown);
        document.removeEventListener('change', this.handleGlobalChange);
    }
}

// Initialize and export
const Events = new EventHandler();
export { Events };