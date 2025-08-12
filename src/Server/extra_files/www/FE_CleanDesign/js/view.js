export class View {
    constructor() {
        View.init();
    }

    static init() {
        View.createNotificationContainer();
    }

    static goTo(page) {
        window.location.href = page;
    }
    static getPageNow() {
        const path = window.location.pathname;
        if (path === '/' || path === '') {
            return 'index.html'; // chuẩn hóa thành index.html
        }
        
        return path.substring(path.lastIndexOf('/') + 1);
    }
    // Existing notification methods...
    static createNotificationContainer() {
        if (!document.getElementById('notificationContainer')) {
            const container = document.createElement('div');
            container.id = 'notificationContainer';
            container.className = 'fixed top-4 right-4 z-50 space-y-2';
            document.body.appendChild(container);
        }
    }

    static showLoading(message = 'Processing...') {
        // Check if loading overlay exists, if not create it
        let overlay = document.getElementById('loadingOverlay');
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.id = 'loadingOverlay';
            overlay.className = 'fixed inset-0 bg-black/50 flex items-center justify-center z-50 hidden';
            overlay.innerHTML = `
                <div class="bg-gray-800 rounded-lg p-6 flex items-center space-x-4">
                    <div class="animate-spin rounded-full h-8 w-8 border-2 border-white border-t-transparent"></div>
                    <p class="text-white">${message}</p>
                </div>
            `;
            document.body.appendChild(overlay);
        }

        const messageElement = overlay.querySelector('p');
        if (messageElement) {
            messageElement.textContent = message;
        }
        overlay.classList.remove('hidden');
    }

    static hideLoading() {
        const overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            overlay.classList.add('hidden');
        }
    }

    static showError(message, duration = 5000) {
        View.showNotification(message, 'error', duration);
    }

    static showSuccess(message, duration = 3000) {
        View.showNotification(message, 'success', duration);
    }

    static showInfo(message, duration = 4000) {
        View.showNotification(message, 'info', duration);
    }

    static showWarning(message, duration = 4000) {
        View.showNotification(message, 'warning', duration);
    }

    static showNotification(message, type = 'info', duration = 4000) {
        const container = document.getElementById('notificationContainer');
        if (!container) return;

        const notification = document.createElement('div');
        notification.className = `notification bg-gray-800 p-4 rounded-lg shadow-lg transform transition-all duration-300 translate-x-full opacity-0 max-w-sm border-l-4 ${View.getNotificationClasses(type)}`;

        const iconHtml = View.getNotificationIcon(type);

        notification.innerHTML = `
            <div class="flex items-start gap-3">
                <div class="flex-shrink-0">
                    ${iconHtml}
                </div>
                <div class="flex-1">
                    <p class="text-white text-sm font-medium">${message}</p>
                </div>
                <button class="flex-shrink-0 text-white/60 hover:text-white/80 ml-2" onclick="this.parentElement.parentElement.remove()">
                    <i class="fas fa-times text-xs"></i>
                </button>
            </div>
        `;

        container.appendChild(notification);

        // Animate in
        setTimeout(() => {
            notification.classList.remove('translate-x-full', 'opacity-0');
        }, 100);

        // Auto remove
        if (duration > 0) {
            setTimeout(() => {
                View.removeNotification(notification);
            }, duration);
        }
    }

    static removeNotification(notification) {
        notification.classList.add('translate-x-full', 'opacity-0');
        setTimeout(() => {
            if (notification.parentElement) {
                notification.parentElement.removeChild(notification);
            }
        }, 300);
    }

    static getNotificationClasses(type) {
        switch (type) {
            case 'success':
                return 'border-green-500 bg-green-900/20';
            case 'error':
                return 'border-red-500 bg-red-900/20';
            case 'warning':
                return 'border-yellow-500 bg-yellow-900/20';
            case 'info':
            default:
                return 'border-blue-500 bg-blue-900/20';
        }
    }

    static getNotificationIcon(type) {
        switch (type) {
            case 'success':
                return '<i class="fas fa-check-circle text-green-400"></i>';
            case 'error':
                return '<i class="fas fa-times-circle text-red-400"></i>';
            case 'warning':
                return '<i class="fas fa-exclamation-triangle text-yellow-400"></i>';
            case 'info':
            default:
                return '<i class="fas fa-info-circle text-blue-400"></i>';
        }
    }

    // Modal Management
    showModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.add('show');
            document.body.style.overflow = 'hidden';
        }
    }

    hideModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.remove('show');
            document.body.style.overflow = 'auto';
        }
    }

    // Lists Page Specific Methods
    displayGameSearchResults(results, addGameCallback) {
        const container = document.getElementById('gameSearchResults');
        if (!container) return;

        if (results.length === 0) {
            container.innerHTML = '<div class="text-gray-400 text-sm p-3">No games found</div>';
            return;
        }

        container.innerHTML = results.map(game => `
            <div class="game-search-item bg-gray-700 p-3 rounded cursor-pointer flex items-center justify-between hover:bg-gray-600 transition-colors" 
                 data-click="addGameToList" data-game-id="${game.id}">
                <div>
                    <div class="text-white font-medium">${game.title}</div>
                    <div class="text-gray-400 text-sm">${game.genre} • ${game.year}</div>
                </div>
                <i class="fas fa-plus text-blue-400"></i>
            </div>
        `).join('');
    }

    clearGameSearchResults() {
        const container = document.getElementById('gameSearchResults');
        if (container) {
            container.innerHTML = '';
        }
    }

    clearGameSearch() {
        const searchInput = document.getElementById('gameSearch');
        if (searchInput) {
            searchInput.value = '';
        }
        View.clearGameSearchResults();
    }

    updateSelectedGames(selectedGames, removeCallback) {
        const container = document.getElementById('selectedGames');
        if (!container) return;

        if (selectedGames.length === 0) {
            container.innerHTML = '';
            return;
        }

        container.innerHTML = `
            <div class="text-sm font-medium text-gray-300 mb-2">Selected Games (${selectedGames.length}):</div>
            ${selectedGames.map(game => `
                <div class="bg-gray-700 p-3 rounded flex items-center justify-between">
                    <div>
                        <div class="text-white font-medium">${game.title}</div>
                        <div class="text-gray-400 text-sm">${game.genre} • ${game.year}</div>
                    </div>
                    <button type="button" data-click="removeGameFromList" data-game-id="${game.id}"
                            class="text-red-400 hover:text-red-300 transition-colors">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            `).join('')}
        `;
    }

    updateTagsList(tags, removeCallback) {
        const container = document.getElementById('tagsList');
        if (!container) return;

        container.innerHTML = tags.map(tag => `
            <span class="bg-blue-600 text-white px-3 py-1 rounded-full text-sm flex items-center">
                ${tag}
                <button type="button" data-click="removeTag" data-tag="${tag}" 
                        class="ml-2 text-blue-200 hover:text-white transition-colors">
                    <i class="fas fa-times text-xs"></i>
                </button>
            </span>
        `).join('');
    }

    resetCreateListForm() {
        const form = document.getElementById('createListForm');
        if (form) {
            form.reset();
        }

        // Clear dynamic content
        View.updateSelectedGames([], null);
        View.updateTagsList([], null);
        View.clearGameSearchResults();
    }

    showListDetailModal(list, games) {
        const modal = document.getElementById('listDetailModal');
        if (!modal) return;

        // Populate modal content
        const titleElement = document.getElementById('listDetailTitle');
        const dateElement = document.getElementById('listDetailDate');
        const likesElement = document.getElementById('listDetailLikes');
        const gameCountElement = document.getElementById('listDetailGameCount');
        const descriptionElement = document.getElementById('listDetailDescription');
        const tagsContainer = document.getElementById('listDetailTags');
        const gamesContainer = document.getElementById('listDetailGames');

        if (titleElement) titleElement.textContent = list.title;
        if (dateElement) dateElement.textContent = list.date;
        if (likesElement) likesElement.textContent = `${list.likes} likes`;
        if (gameCountElement) gameCountElement.textContent = `${list.gameCount} games`;
        if (descriptionElement) descriptionElement.textContent = list.description;

        // Populate tags
        if (tagsContainer) {
            if (list.tags && list.tags.length > 0) {
                tagsContainer.innerHTML = `
                    <div class="flex flex-wrap gap-2">
                        ${list.tags.map(tag => `
                            <span class="bg-blue-600 text-white px-3 py-1 rounded-full text-sm">${tag}</span>
                        `).join('')}
                    </div>
                `;
            } else {
                tagsContainer.innerHTML = '';
            }
        }

        // Populate games
        if (gamesContainer) {
            if (games.length > 0) {
                gamesContainer.innerHTML = games.map((game, index) => `
                    <div class="bg-gray-700 rounded-lg p-4 flex items-center space-x-4 hover:bg-gray-600 transition-colors">
                        <div class="text-gray-400 font-bold text-lg w-8">${index + 1}</div>
                        <img src="${game.poster}" alt="${game.title}" class="w-16 h-20 object-cover rounded">
                        <div class="flex-1">
                            <h4 class="font-semibold text-white">${game.title}</h4>
                            <p class="text-gray-400 text-sm">${game.genre} • ${game.year}</p>
                        </div>
                        <div class="flex space-x-2">
                            <button class="text-blue-400 hover:text-blue-300 p-2 transition-colors">
                                <i class="fas fa-heart"></i>
                            </button>
                            <button class="text-gray-400 hover:text-white p-2 transition-colors">
                                <i class="fas fa-bookmark"></i>
                            </button>
                        </div>
                    </div>
                `).join('');
            } else {
                gamesContainer.innerHTML = '<div class="text-gray-400 text-center py-8">No games in this list yet.</div>';
            }
        }

        View.showModal('listDetailModal');
    }

    addListToPage(listData, clickCallback) {
        const container = document.getElementById('listsContainer');
        if (!container) return;

        const listElement = document.createElement('div');
        listElement.className = 'list-card bg-gray-800 rounded-lg overflow-hidden hover:bg-gray-750 cursor-pointer transition-all duration-300 hover:transform hover:-translate-y-1 hover:shadow-xl';
        listElement.setAttribute('data-date', listData.dateCreated || new Date().toISOString().split('T')[0]);
        listElement.setAttribute('data-title', listData.title);
        listElement.setAttribute('data-games', listData.gameCount);
        listElement.setAttribute('data-likes', listData.likes);
        listElement.setAttribute('data-list-id', listData.id);

        const formattedDate = listData.dateCreatedFormatted || new Date().toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric'
        });

        listElement.innerHTML = `
            <div class="flex">
                <div class="relative w-80 h-32 bg-gray-700 flex-shrink-0">
                    <div class="text-center py-4 text-gray-400">
                        <i class="fas fa-gamepad text-2xl mb-2"></i>
                        <div class="text-sm">Game posters preview</div>
                    </div>
                    <div class="absolute inset-0 bg-gradient-to-r from-black/60 to-black/30 flex items-center justify-center">
                        <span class="text-white text-lg font-bold bg-black/50 px-3 py-1 rounded">${listData.gameCount} Games</span>
                    </div>
                </div>
                
                <div class="flex-1 p-6">
                    <div class="flex justify-between items-start">
                        <div class="flex-1">
                            <h3 class="text-xl font-bold mb-2 text-white">${listData.title}</h3>
                            <p class="text-gray-400 text-sm mb-4 leading-relaxed">${listData.description}</p>
                            ${listData.tags && listData.tags.length > 0 ? `
                                <div class="flex flex-wrap gap-1 mb-2">
                                    ${listData.tags.map(tag => `<span class="bg-gray-600 text-gray-200 px-2 py-1 rounded text-xs">${tag}</span>`).join('')}
                                </div>
                            ` : ''}
                        </div>
                        <div class="text-right text-sm text-gray-400 ml-4">
                            <div class="mb-2">${formattedDate}</div>
                            <div class="flex items-center justify-end space-x-1">
                                <i class="fas fa-heart text-red-500"></i>
                                <span>${listData.likes} likes</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        `;

        // Add to beginning of container
        container.insertBefore(listElement, container.firstChild);
    }

    sortListsInDOM(sortBy) {
        const container = document.getElementById('listsContainer');
        if (!container) return;

        const lists = Array.from(container.children);

        lists.sort((a, b) => {
            switch (sortBy) {
                case 'date':
                    return new Date(b.dataset.date) - new Date(a.dataset.date);
                case 'title':
                    return a.dataset.title.localeCompare(b.dataset.title);
                case 'games':
                    return parseInt(b.dataset.games) - parseInt(a.dataset.games);
                case 'likes':
                    return parseInt(b.dataset.likes) - parseInt(a.dataset.likes);
                default:
                    return 0;
            }
        });

        // Re-append sorted elements
        lists.forEach(list => container.appendChild(list));
    }

    updateListLikes(listId, newLikes) {
        const listCard = document.querySelector(`[data-list-id="${listId}"]`);
        if (listCard) {
            const likesElement = listCard.querySelector('.fa-heart').nextElementSibling;
            if (likesElement) {
                likesElement.textContent = `${newLikes} likes`;
            }
            listCard.setAttribute('data-likes', newLikes);
        }
    }

    // Input validation methods
    updateInputValidation(input, isValid, errorMessage = '') {
        const fieldContainer = input.parentElement;
        let errorElement = fieldContainer.querySelector('.field-error');

        // Remove existing error styling
        input.classList.remove('border-red-500', 'border-2', 'border-green-500');

        if (errorElement) {
            errorElement.remove();
        }

        if (!isValid && errorMessage) {
            // Add error styling
            input.classList.add('border-red-500', 'border-2');

            // Create error message
            errorElement = document.createElement('div');
            errorElement.className = 'field-error text-red-400 text-xs mt-1';
            errorElement.textContent = errorMessage;
            fieldContainer.appendChild(errorElement);
        } else if (isValid && input.value.trim()) {
            // Add success styling
            input.classList.add('border-green-500');
        }
    }

    updatePasswordStrength(passwordInput, strength) {
        let strengthIndicator = passwordInput.parentElement.querySelector('.password-strength');

        if (!strengthIndicator) {
            strengthIndicator = document.createElement('div');
            strengthIndicator.className = 'password-strength mt-2';
            passwordInput.parentElement.appendChild(strengthIndicator);
        }

        const strengthLevels = ['Very Weak', 'Weak', 'Fair', 'Good', 'Strong'];
        const strengthColors = ['bg-red-500', 'bg-orange-500', 'bg-yellow-500', 'bg-blue-500', 'bg-green-500'];

        const level = Math.min(strength, 4);
        const strengthText = strengthLevels[level] || 'Very Weak';
        const strengthColor = strengthColors[level] || 'bg-red-500';

        strengthIndicator.innerHTML = `
            <div class="flex items-center space-x-2">
                <div class="flex space-x-1">
                    ${Array.from({ length: 5 }, (_, i) => `
                        <div class="w-4 h-1 rounded ${i <= level ? strengthColor : 'bg-gray-600'}"></div>
                    `).join('')}
                </div>
                <span class="text-xs text-gray-400">${strengthText}</span>
            </div>
        `;
    }

    togglePassword(inputId, button) {
        const input = document.getElementById(inputId);
        if (!input) return;

        const icon = button.querySelector('i');

        if (input.type === 'password') {
            input.type = 'text';
            icon.className = 'fas fa-eye-slash';
        } else {
            input.type = 'password';
            icon.className = 'fas fa-eye';
        }
    }

    // Utility methods
    async copyToClipboard(text) {
        try {
            await navigator.clipboard.writeText(text);
            View.showSuccess('Copied to clipboard');
            return true;
        } catch (error) {
            console.error('Failed to copy text:', error);
            View.showError('Failed to copy text');
            return false;
        }
    }

    scrollToElement(elementId, offset = 0) {
        const element = document.getElementById(elementId);
        if (!element) return;

        const elementPosition = element.getBoundingClientRect().top + window.pageYOffset;
        const offsetPosition = elementPosition - offset;

        window.scrollTo({
            top: offsetPosition,
            behavior: 'smooth'
        });
    }

    // Cleanup method
    cleanup() {
        const modals = document.querySelectorAll('[id$="Modal"]');
        modals.forEach(modal => modal.remove());

        const notifications = document.querySelectorAll('.notification');
        notifications.forEach(notification => notification.remove());
    }
}

export const Pages = {
    AUTH: 'auth.html',
    PROFILE: 'profile.html',
    ACTIVITY: 'activity.html',
    DIARY: 'diary.html',
    FRIENDS: 'friends.html',
    GAME_DETAIL: 'game-detail.html',
    GAME_REVIEW: 'game-review.html',
    GAMES: 'games.html',
    INDEX: 'index.html',
    LIKES: 'likes.html',
    LISTS: 'lists.html',
    REGISTER: 'register.html',
    REVIEW: 'review.html',
    FOLLOWERS: 'followers.html'
};
