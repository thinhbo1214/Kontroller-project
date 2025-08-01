// UI.js - Thêm hàm displayProfile
class UI {
    constructor() {
        this.init();
    }

    init() {
        this.createNotificationContainer();
    }

    // Tạo container cho notifications
    createNotificationContainer() {
        if (!document.getElementById('notificationContainer')) {
            const container = document.createElement('div');
            container.id = 'notificationContainer';
            container.className = 'fixed top-4 right-4 z-50 space-y-2';
            document.body.appendChild(container);
        }
    }

    // Hiển thị profile - MAIN FUNCTION
    displayProfile(userData) {
        console.log('🎨 Displaying profile for:', userData);

        if (!userData) {
            console.error('❌ No user data provided');
            this.showError('No user data to display');
            return;
        }

        try {
            // Update avatar
            this.updateAvatar(userData);
            
            // Update basic info
            this.updateBasicInfo(userData);
            
            // Update stats
            this.updateStats(userData);
            
            // Update dates
            this.updateDates(userData);

            console.log('✅ Profile display completed');
            this.showSuccess('Profile loaded successfully');

        } catch (error) {
            console.error('❌ Error displaying profile:', error);
            this.showError('Failed to display profile data');
        }
    }

    // Update avatar
    updateAvatar(userData) {
        const avatarImg = document.querySelector('[data-profile="avatar"]');
        const avatarPlaceholder = document.querySelector('[data-profile="avatar-placeholder"]');
        
        if (userData.avatar && userData.avatar.trim()) {
            // Có avatar URL
            if (avatarImg) {
                avatarImg.src = userData.avatar;
                avatarImg.style.display = 'block';
                avatarImg.alt = `${userData.username || 'User'}'s avatar`;
            }
            if (avatarPlaceholder) {
                avatarPlaceholder.style.display = 'none';
            }
        } else {
            // Không có avatar, dùng placeholder
            if (avatarImg) {
                avatarImg.style.display = 'none';
            }
            if (avatarPlaceholder) {
                avatarPlaceholder.style.display = 'flex';
                avatarPlaceholder.textContent = this.generateAvatarLetter(userData.username);
            }
        }
    }

    // Update basic information
    updateBasicInfo(userData) {
        const fields = {
            'username': userData.username || 'Unknown User',
            'email': userData.email || 'No email provided',
            'fullName': userData.fullName || userData.full_name || userData.name || 'Not specified',
            'bio': userData.bio || 'No bio available',
            'id': userData.id || 'N/A'
        };

        Object.entries(fields).forEach(([field, value]) => {
            const elements = document.querySelectorAll(`[data-profile="${field}"]`);
            elements.forEach(element => {
                element.textContent = value;
            });
        });
    }

    // Update gaming stats
    updateStats(userData) {
        const stats = userData.stats || {};
        
        const statFields = {
            'gamesPlayed': stats.gamesPlayed || stats.games_played || 0,
            'totalScore': this.formatNumber(stats.totalScore || stats.total_score || 0),
            'level': stats.level || this.calculateLevel(stats.totalScore || 0)
        };

        Object.entries(statFields).forEach(([field, value]) => {
            const elements = document.querySelectorAll(`[data-profile="${field}"]`);
            elements.forEach(element => {
                element.textContent = value;
            });
        });

        // Update progress bars if exists
        this.updateLevelProgress(stats);
    }

    // Update dates
    updateDates(userData) {
        const dateFields = {
            'joinDate': userData.joinDate || userData.join_date || userData.createdAt,
            'lastLogin': userData.lastLogin || userData.last_login || userData.updatedAt
        };

        Object.entries(dateFields).forEach(([field, value]) => {
            const elements = document.querySelectorAll(`[data-profile="${field}"]`);
            elements.forEach(element => {
                element.textContent = this.formatDate(value);
            });
        });
    }

    // Update level progress bar
    updateLevelProgress(stats) {
        const currentScore = stats.totalScore || stats.total_score || 0;
        const currentLevel = stats.level || this.calculateLevel(currentScore);
        const nextLevelScore = this.getNextLevelScore(currentLevel);
        const currentLevelScore = this.getCurrentLevelScore(currentLevel);
        
        const progress = ((currentScore - currentLevelScore) / (nextLevelScore - currentLevelScore)) * 100;
        
        const progressBar = document.querySelector('[data-profile="levelProgress"]');
        const progressText = document.querySelector('[data-profile="levelProgressText"]');
        
        if (progressBar) {
            progressBar.style.width = `${Math.min(progress, 100)}%`;
        }
        
        if (progressText) {
            progressText.textContent = `${currentScore - currentLevelScore}/${nextLevelScore - currentLevelScore} XP`;
        }
    }

    // Helper functions
    generateAvatarLetter(username) {
        if (!username) return 'U';
        return username.charAt(0).toUpperCase();
    }

    formatDate(dateString) {
        if (!dateString) return 'Unknown';
        
        try {
            const date = new Date(dateString);
            if (isNaN(date.getTime())) return 'Invalid date';
            
            return date.toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'long',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });
        } catch (error) {
            return 'Invalid date';
        }
    }

    formatNumber(num) {
        if (!num) return '0';
        return num.toLocaleString();
    }

    calculateLevel(totalScore) {
        if (totalScore < 1000) return 1;
        if (totalScore < 5000) return Math.floor(totalScore / 1000) + 1;
        return Math.floor(totalScore / 2500) + 3;
    }

    getNextLevelScore(level) {
        if (level < 5) return level * 1000;
        return (level - 3) * 2500;
    }

    getCurrentLevelScore(level) {
        if (level <= 1) return 0;
        if (level <= 5) return (level - 1) * 1000;
        return 5000 + (level - 5) * 2500;
    }

    // Notification functions
    showSuccess(message) {
        this.showNotification(message, 'success');
    }

    showError(message) {
        this.showNotification(message, 'error');
    }

    showNotification(message, type = 'info') {
        const container = document.getElementById('notificationContainer');
        const notification = document.createElement('div');
        
        const colors = {
            success: 'bg-green-600',
            error: 'bg-red-600',
            info: 'bg-blue-600',
            warning: 'bg-yellow-600'
        };

        const icons = {
            success: '✅',
            error: '❌',
            info: 'ℹ️',
            warning: '⚠️'
        };

        notification.className = `${colors[type]} text-white px-4 py-3 rounded-lg shadow-lg flex items-center gap-2 transform transition-all duration-300 translate-x-full opacity-0`;
        notification.innerHTML = `
            <span>${icons[type]}</span>
            <span>${message}</span>
            <button onclick="this.parentElement.remove()" class="ml-2 hover:bg-white/20 rounded p-1">×</button>
        `;

        container.appendChild(notification);

        // Animate in
        setTimeout(() => {
            notification.classList.remove('translate-x-full', 'opacity-0');
        }, 100);

        // Auto remove after 5 seconds
        setTimeout(() => {
            if (notification.parentElement) {
                notification.classList.add('translate-x-full', 'opacity-0');
                setTimeout(() => notification.remove(), 300);
            }
        }, 5000);
    }

    showLoading(message = 'Loading...') {
        let overlay = document.getElementById('loadingOverlay');
        if (!overlay) {
            overlay = document.createElement('div');
            overlay.id = 'loadingOverlay';
            overlay.className = 'fixed inset-0 bg-black/50 flex items-center justify-center z-50';
            document.body.appendChild(overlay);
        }

        overlay.innerHTML = `
            <div class="bg-white/10 backdrop-blur-lg border border-white/20 p-6 rounded-lg text-center">
                <div class="animate-spin rounded-full h-8 w-8 border-2 border-white border-t-transparent mx-auto mb-4"></div>
                <p class="text-white">${message}</p>
            </div>
        `;
        overlay.classList.remove('hidden');
    }

    hideLoading() {
        const overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            overlay.classList.add('hidden');
        }
    }
}

const uiInstance = new UI();
export default uiInstance;