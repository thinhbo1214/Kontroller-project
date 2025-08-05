import { API } from './api.js';
import { UI } from './ui.js';

class HandleManager {
    constructor() {
        this.currentModal = null;
        this.currentTab = null;
        this.selectedGames = [];
        this.currentTags = [];
        this.sampleGames = [
            { id: 1, title: "The Witcher 3: Wild Hunt", genre: "RPG", year: 2015, poster: "https://via.placeholder.com/150x200/DC2626/FFFFFF?text=Witcher+3" },
            { id: 2, title: "Red Dead Redemption 2", genre: "Action", year: 2018, poster: "https://via.placeholder.com/150x200/DC2626/FFFFFF?text=RDR2" },
            { id: 3, title: "Cyberpunk 2077", genre: "RPG", year: 2020, poster: "https://via.placeholder.com/150x200/FBBF24/000000?text=Cyberpunk" },
            { id: 4, title: "God of War", genre: "Action", year: 2018, poster: "https://via.placeholder.com/150x200/1F2937/FFFFFF?text=God+of+War" },
            { id: 5, title: "The Last of Us Part II", genre: "Action", year: 2020, poster: "https://via.placeholder.com/150x200/059669/FFFFFF?text=TLOU2" },
            // Add more games as needed...
        ];
        this.listData = {
            // Sample list data structure
            1: {
                title: "TOP 10 GAMES OF ALL TIME",
                description: "This is my personal take, not objective. These are the games that have had the most impact on me personally and shaped my gaming experience over the years.",
                date: "July 15, 2025",
                likes: 24,
                gameCount: 12,
                tags: ["Personal Favorites", "All Time", "Masterpieces"],
                games: [1, 2, 3, 4, 5]
            }
            // Add more list data...
        };
    }

    // Existing methods...
    handleBack = (e) => {
        e.preventDefault();
        const target = e.target.dataset.target || 'index.html';
        window.location.href = target;
    }

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

        if (!this.validateSignupData(userData)) {
            return;
        }

        try {
            UI.showLoading('Creating account...');
            const result = await API.signup(userData);
            
            if (result.success) {
                UI.showSuccess('Account created successfully!');
                setTimeout(() => window.location.href = 'login.html', 2000);
            } else {
                UI.showError(result.message || 'Signup failed');
            }
        } catch (error) {
            UI.showError('An error occurred: ' + error.message);
        } finally {
            UI.hideLoading();
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
            UI.showLoading('Signing in...');
            const result = await API.login(loginData);
            
            if (result.success) {
                UI.showSuccess('Login successful!');
                setTimeout(() => window.location.href = 'dashboard.html', 1500);
            } else {
                UI.showError(result.message || 'Login failed');
            }
        } catch (error) {
            UI.showError('An error occurred: ' + error.message);
        } finally {
            UI.hideLoading();
        }
    }

    handleLogout = async (e) => {
        e.preventDefault();
        
        try {
            const result = await API.logout();
            if (result.success) {
                UI.showSuccess('Logged out successfully!');
                setTimeout(() => window.location.href = 'index.html', 1000);
            }
        } catch (error) {
            UI.showError('Error logging out');
        }
    }

    // Lists Page Handlers
    handleCreateList = (e) => {
        e.preventDefault();
        this.currentModal = 'createListModal';
        UI.showModal('createListModal');
        this.resetCreateListForm();
    }

    handleListClick = (e) => {
        e.preventDefault();
        const listCard = e.target.closest('.list-card');
        if (listCard) {
            const listId = listCard.getAttribute('data-list-id');
            this.showListDetail(listId);
        }
    }

    handleCreateListSubmit = async (e) => {
        e.preventDefault();
        
        const title = document.getElementById('listTitle')?.value.trim();
        const description = document.getElementById('listDescription')?.value.trim();
        const privacy = document.getElementById('listPrivacy')?.value;

        if (!title) {
            UI.showError('Please enter a list title');
            return;
        }

        const newList = {
            title: title,
            description: description || 'No description provided.',
            privacy: privacy,
            tags: [...this.currentTags],
            games: [...this.selectedGames],
            gameCount: this.selectedGames.length,
            likes: 0
        };

        try {
            UI.showLoading('Creating list...');
            const result = await API.createList(newList);
            
            if (result.success) {
                UI.showSuccess('List created successfully!');
                this.addListToPage(result.data);
                this.handleModalClose(e);
            } else {
                UI.showError(result.message || 'Failed to create list');
            }
        } catch (error) {
            UI.showError('An error occurred: ' + error.message);
        } finally {
            UI.hideLoading();
        }
    }

    handleSortChange = (e) => {
        const sortBy = e.target.value;
        this.sortLists(sortBy);
    }

    handleGameSearch = (e) => {
        const query = e.target.value.toLowerCase().trim();
        
        if (query.length < 2) {
            UI.clearGameSearchResults();
            return;
        }

        const results = this.sampleGames.filter(game => 
            game.title.toLowerCase().includes(query) && 
            !this.selectedGames.find(sg => sg.id === game.id)
        ).slice(0, 5);

        UI.displayGameSearchResults(results, this.handleAddGameToList.bind(this));
    }

    handleAddGameToList = (gameId) => {
        const game = this.sampleGames.find(g => g.id === gameId);
        if (game && !this.selectedGames.find(sg => sg.id === gameId)) {
            this.selectedGames.push(game);
            UI.updateSelectedGames(this.selectedGames, this.handleRemoveGameFromList.bind(this));
            UI.clearGameSearch();
        }
    }

    handleRemoveGameFromList = (gameId) => {
        this.selectedGames = this.selectedGames.filter(game => game.id !== gameId);
        UI.updateSelectedGames(this.selectedGames, this.handleRemoveGameFromList.bind(this));
    }

    handleTagInput = (e) => {
        if (e.key === 'Enter' || e.key === ',') {
            e.preventDefault();
            this.addTag(e.target.value.trim());
            e.target.value = '';
        }
    }

    handleTagInputBlur = (e) => {
        const tag = e.target.value.trim();
        if (tag) {
            this.addTag(tag);
            e.target.value = '';
        }
    }

    handleRemoveTag = (tag) => {
        this.currentTags = this.currentTags.filter(t => t !== tag);
        UI.updateTagsList(this.currentTags, this.handleRemoveTag.bind(this));
    }

    handleLikeList = async (e) => {
        e.preventDefault();
        const listId = e.target.dataset.listId;
        
        try {
            const result = await API.likeList(listId);
            if (result.success) {
                UI.showSuccess('List liked!');
                // Update UI to reflect the like
                this.updateListLikes(listId, result.data.likes);
            }
        } catch (error) {
            UI.showError('Failed to like list');
        }
    }

    handleShareList = async (e) => {
        e.preventDefault();
        const listId = e.target.dataset.listId;
        const shareUrl = `${window.location.origin}/list/${listId}`;
        
        try {
            await UI.copyToClipboard(shareUrl);
        } catch (error) {
            UI.showError('Failed to copy share link');
        }
    }

    // UI Handlers
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

    // Input validation handlers
    handleEmailInput = (e) => {
        const email = e.target.value;
        const isValid = this.validateEmail(email);
        UI.updateInputValidation(e.target, isValid, 'Invalid email address');
    }

    handlePasswordInput = (e) => {
        const password = e.target.value;
        const strength = this.getPasswordStrength(password);
        UI.updatePasswordStrength(e.target, strength);
    }

    handleUsernameInput = (e) => {
        const username = e.target.value;
        const isValid = username.length >= 3;
        UI.updateInputValidation(e.target, isValid, 'Username must be at least 3 characters');
    }

    handleInputValidation = (e) => {
        const input = e.target;
        const value = input.value.trim();
        
        switch (input.type) {
            case 'email':
                const emailValid = this.validateEmail(value);
                UI.updateInputValidation(input, emailValid, 'Invalid email address');
                break;
                
            case 'password':
                const passwordValid = value.length >= 6;
                UI.updateInputValidation(input, passwordValid, 'Password must be at least 6 characters');
                break;
                
            default:
                if (input.required && !value) {
                    UI.updateInputValidation(input, false, 'This field is required');
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
        if (this.currentModal) {
            this.handleModalClose(e);
        }
    }

    // Helper methods
    addTag(tag) {
        if (tag && !this.currentTags.includes(tag) && this.currentTags.length < 10) {
            this.currentTags.push(tag);
            UI.updateTagsList(this.currentTags, this.handleRemoveTag.bind(this));
        }
    }

    resetCreateListForm() {
        this.selectedGames = [];
        this.currentTags = [];
        UI.resetCreateListForm();
    }

    showListDetail(listId) {
        const list = this.listData[listId];
        if (!list) return;

        const listGames = list.games.map(gameId => 
            this.sampleGames.find(g => g.id === gameId)
        ).filter(Boolean);

        UI.showListDetailModal(list, listGames);
        this.currentModal = 'listDetailModal';
    }

    sortLists(sortBy) {
        UI.sortListsInDOM(sortBy);
    }

    addListToPage(listData) {
        UI.addListToPage(listData, this.handleListClick.bind(this));
    }

    updateListLikes(listId, newLikes) {
        UI.updateListLikes(listId, newLikes);
    }

    // Validation methods
    validateEmail(email) {
        return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
    }

    validateSignupData(data) {
        if (!data.username || data.username.length < 3) {
            UI.showError('Username must be at least 3 characters');
            return false;
        }
        
        if (!this.validateEmail(data.email)) {
            UI.showError('Invalid email address');
            return false;
        }
        
        if (!data.password || data.password.length < 6) {
            UI.showError('Password must be at least 6 characters');
            return false;
        }
        
        return true;
    }

    validateLoginData(data) {
        if (!this.validateEmail(data.email)) {
            UI.showError('Invalid email address');
            return false;
        }
        
        if (!data.password) {
            UI.showError('Please enter your password');
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