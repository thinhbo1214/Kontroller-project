// ui.js - Quản lý giao diện người dùng
class UIManager {
    constructor() {
        this.init();
    }

    init() {
        // Initialize any UI components if needed
        this.createNotificationContainer();
    }

    /**
     * Tạo container cho notifications
     */
    createNotificationContainer() {
        if (!document.getElementById('notificationContainer')) {
            const container = document.createElement('div');
            container.id = 'notificationContainer';
            container.className = 'fixed top-4 right-4 z-50 space-y-2';
            document.body.appendChild(container);
        }
    }

    /**
     * Hiển thị loading overlay
     */
    showLoading(message = 'Processing...') {
        const overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            const messageElement = overlay.querySelector('p');
            if (messageElement) {
                messageElement.textContent = message;
            }
            overlay.classList.remove('hidden');
        }
    }

    /**
     * Ẩn loading overlay
     */
    hideLoading() {
        const overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            overlay.classList.add('hidden');
        }
    }

    /**
     * Hiển thị thông báo lỗi
     */
    showError(message, duration = 5000) {
        this.showNotification(message, 'error', duration);
    }

    /**
     * Hiển thị thông báo thành công
     */
    showSuccess(message, duration = 3000) {
        this.showNotification(message, 'success', duration);
    }

    /**
     * Hiển thị thông báo info
     */
    showInfo(message, duration = 4000) {
        this.showNotification(message, 'info', duration);
    }

    /**
     * Hiển thị thông báo warning
     */
    showWarning(message, duration = 4000) {
        this.showNotification(message, 'warning', duration);
    }

    /**
     * Hiển thị notification với type tùy chỉnh
     */
    showNotification(message, type = 'info', duration = 4000) {
        const container = document.getElementById('notificationContainer');
        if (!container) return;

        const notification = document.createElement('div');
        notification.className = `notification glass-card p-4 rounded-lg shadow-lg transform transition-all duration-300 translate-x-full opacity-0 max-w-sm ${this.getNotificationClasses(type)}`;
        
        const iconHtml = this.getNotificationIcon(type);
        
        notification.innerHTML = `
            <div class="flex items-start gap-3">
                <div class="flex-shrink-0">
                    ${iconHtml}
                </div>
                <div class="flex-1">
                    <p class="text-white text-sm font-medium">${message}</p>
                </div>
                <button class="flex-shrink-0 text-white/60 hover:text-white/80 ml-2" onclick="this.parentElement.parentElement.remove()">
                    <i data-lucide="x" class="w-4 h-4"></i>
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
                this.removeNotification(notification);
            }, duration);
        }

        // Recreate icons
        if (window.lucide) {
            window.lucide.createIcons();
        }
    }

    /**
     * Remove notification với animation
     */
    removeNotification(notification) {
        notification.classList.add('translate-x-full', 'opacity-0');
        setTimeout(() => {
            if (notification.parentElement) {
                notification.parentElement.removeChild(notification);
            }
        }, 300);
    }

    /**
     * Get CSS classes for notification type
     */
    getNotificationClasses(type) {
        switch (type) {
            case 'success':
                return 'border-l-4 border-green-500 bg-green-900/20';
            case 'error':
                return 'border-l-4 border-red-500 bg-red-900/20';
            case 'warning':
                return 'border-l-4 border-yellow-500 bg-yellow-900/20';
            case 'info':
            default:
                return 'border-l-4 border-blue-500 bg-blue-900/20';
        }
    }

    /**
     * Get icon HTML for notification type
     */
    getNotificationIcon(type) {
        switch (type) {
            case 'success':
                return '<i data-lucide="check-circle" class="w-5 h-5 text-green-400"></i>';
            case 'error':
                return '<i data-lucide="x-circle" class="w-5 h-5 text-red-400"></i>';
            case 'warning':
                return '<i data-lucide="alert-triangle" class="w-5 h-5 text-yellow-400"></i>';
            case 'info':
            default:
                return '<i data-lucide="info" class="w-5 h-5 text-blue-400"></i>';
        }
    }

    /**
     * Hiển thị lỗi cho trường cụ thể
     */
    showFieldError(fieldId, message) {
        const field = document.getElementById(fieldId);
        if (!field) return;

        // Remove existing error
        this.clearFieldError(fieldId);

        // Add error styling
        field.classList.add('border-red-500', 'border-2');
        field.classList.remove('border-white/20');

        // Create error message
        const errorDiv = document.createElement('div');
        errorDiv.className = 'field-error text-red-400 text-xs mt-1 font-medium';
        errorDiv.textContent = message;

        // Insert error message after field
        field.parentElement.appendChild(errorDiv);

        // Focus field
        field.focus();
    }

    /**
     * Clear lỗi cho trường cụ thể
     */
    clearFieldError(fieldId) {
        const field = document.getElementById(fieldId);
        if (!field) return;

        // Remove error styling
        field.classList.remove('border-red-500', 'border-2');
        field.classList.add('border-white/20');

        // Remove error message
        const errorDiv = field.parentElement.querySelector('.field-error');
        if (errorDiv) {
            errorDiv.remove();
        }
    }

    /**
     * Clear tất cả lỗi
     */
    clearAllErrors() {
        const errorDivs = document.querySelectorAll('.field-error');
        errorDivs.forEach(div => div.remove());

        const errorFields = document.querySelectorAll('.border-red-500');
        errorFields.forEach(field => {
            field.classList.remove('border-red-500', 'border-2');
            field.classList.add('border-white/20');
        });
    }

    /**
     * Set trạng thái button (enable/disable)
     */
    setButtonState(buttonId, enabled) {
        const button = document.getElementById(buttonId);
        if (!button) return;

        if (enabled) {
            button.disabled = false;
            button.classList.remove('opacity-50', 'cursor-not-allowed');
            button.textContent = 'Login';
        } else {
            button.disabled = true;
            button.classList.add('opacity-50', 'cursor-not-allowed');
            button.textContent = 'Logging in...';
        }
    }

    /**
     * Hiển thị modal forgot password
     */
    showForgotPasswordModal() {
        // Remove existing modal if any
        const existingModal = document.getElementById('forgotPasswordModal');
        if (existingModal) {
            existingModal.remove();
        }

        const modalHtml = `
            <div id="forgotPasswordModal" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
                <div class="glass-card p-6 rounded-lg max-w-md w-full mx-4 transform transition-all duration-300 scale-95 opacity-0">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-xl font-bold text-white">Reset Password</h3>
                        <button onclick="this.closest('#forgotPasswordModal').remove()" class="text-white/60 hover:text-white/80">
                            <i data-lucide="x" class="w-5 h-5"></i>
                        </button>
                    </div>
                    <div class="mb-4">
                        <label class="block text-white/80 text-sm font-medium mb-2">Email Address</label>
                        <input
                            type="email"
                            id="forgotEmailInput"
                            class="input-field w-full px-4 py-3 rounded-lg text-white placeholder-white/50"
                            placeholder="Enter your email address"
                        />
                    </div>
                    <div class="space-y-3">
                        <button 
                            onclick="handleForgotPasswordSubmit()"
                            class="w-full bg-blue-600 hover:bg-blue-700 text-white font-semibold py-3 px-6 rounded-lg transition-all duration-200"
                        >
                            Send Reset Link
                        </button>
                        <button 
                            onclick="this.closest('#forgotPasswordModal').remove()"
                            class="w-full bg-gray-600 hover:bg-gray-700 text-white font-semibold py-3 px-6 rounded-lg transition-all duration-200"
                        >
                            Cancel
                        </button>
                    </div>
                    <p class="text-white/60 text-xs mt-4 text-center">
                        A password reset link will be sent to your email address.
                    </p>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', modalHtml);

        // Animate in
        const modal = document.getElementById('forgotPasswordModal');
        const content = modal.querySelector('.glass-card');
        setTimeout(() => {
            content.classList.remove('scale-95', 'opacity-0');
            content.classList.add('scale-100', 'opacity-100');
        }, 100);

        // Focus email input
        setTimeout(() => {
            const emailInput = document.getElementById('forgotEmailInput');
            if (emailInput) emailInput.focus();
        }, 200);

        // Handle forgot password submit
        window.handleForgotPasswordSubmit = () => {
            const email = document.getElementById('forgotEmailInput').value.trim();
            if (!email) {
                this.showError('Please enter your email address');
                return;
            }

            if (!this.isValidEmail(email)) {
                this.showError('Please enter a valid email address');
                return;
            }

            // Close modal
            modal.remove();
            
            // Show success message
            this.showSuccess('Password reset link has been sent to your email address');
            
            // Here you would typically call an API to send the reset email
            console.log('Forgot password request for:', email);
        };

        // Recreate icons
        if (window.lucide) {
            window.lucide.createIcons();
        }
    }

    /**
     * Validate email format
     */
    isValidEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    /**
     * Animate element with custom animation
     */
    animateElement(element, animation = 'pulse') {
        if (!element) return;

        switch (animation) {
            case 'shake':
                element.classList.add('animate-pulse');
                setTimeout(() => {
                    element.classList.remove('animate-pulse');
                }, 600);
                break;
            case 'pulse':
            default:
                element.classList.add('animate-pulse');
                setTimeout(() => {
                    element.classList.remove('animate-pulse');
                }, 1000);
                break;
        }
    }

    /**
     * Update page title
     */
    updateTitle(title) {
        document.title = title;
    }

    /**
     * Show/hide elements with animation
     */
    toggleElement(elementId, show = true) {
        const element = document.getElementById(elementId);
        if (!element) return;

        if (show) {
            element.classList.remove('hidden', 'opacity-0');
            element.classList.add('opacity-100');
        } else {
            element.classList.remove('opacity-100');
            element.classList.add('opacity-0');
            setTimeout(() => {
                element.classList.add('hidden');
            }, 300);
        }
    }

    /**
     * Create loading spinner
     */
    createLoadingSpinner(size = 'medium') {
        const sizeClasses = {
            small: 'h-4 w-4',
            medium: 'h-8 w-8',
            large: 'h-12 w-12'
        };

        const spinner = document.createElement('div');
        spinner.className = `animate-spin rounded-full border-2 border-white border-t-transparent ${sizeClasses[size] || sizeClasses.medium}`;
        
        return spinner;
    }

    /**
     * Show confirmation dialog
     */
    showConfirmDialog(message, onConfirm, onCancel = null) {
        const modalHtml = `
            <div id="confirmDialog" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
                <div class="glass-card p-6 rounded-lg max-w-md w-full mx-4 transform transition-all duration-300 scale-95 opacity-0">
                    <div class="text-center">
                        <div class="mb-4">
                            <i data-lucide="help-circle" class="w-12 h-12 text-yellow-400 mx-auto"></i>
                        </div>
                        <h3 class="text-lg font-bold text-white mb-4">Confirmation</h3>
                        <p class="text-white/80 mb-6">${message}</p>
                        <div class="flex gap-3">
                            <button 
                                onclick="handleConfirmYes()"
                                class="flex-1 bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-4 rounded-lg transition-all duration-200"
                            >
                                Yes
                            </button>
                            <button 
                                onclick="handleConfirmNo()"
                                class="flex-1 bg-gray-600 hover:bg-gray-700 text-white font-semibold py-2 px-4 rounded-lg transition-all duration-200"
                            >
                                No
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;

        document.body.insertAdjacentHTML('beforeend', modalHtml);

        const modal = document.getElementById('confirmDialog');
        const content = modal.querySelector('.glass-card');
        
        // Animate in
        setTimeout(() => {
            content.classList.remove('scale-95', 'opacity-0');
            content.classList.add('scale-100', 'opacity-100');
        }, 100);

        // Handle responses
        window.handleConfirmYes = () => {
            modal.remove();
            if (onConfirm) onConfirm();
            delete window.handleConfirmYes;
            delete window.handleConfirmNo;
        };

        window.handleConfirmNo = () => {
            modal.remove();
            if (onCancel) onCancel();
            delete window.handleConfirmYes;
            delete window.handleConfirmNo;
        };

        // Recreate icons
        if (window.lucide) {
            window.lucide.createIcons();
        }
    }

    /**
     * Format text with highlight
     */
    highlightText(text, searchTerm) {
        if (!searchTerm) return text;
        
        const regex = new RegExp(`(${searchTerm})`, 'gi');
        return text.replace(regex, '<mark class="bg-yellow-300 text-black px-1 rounded">$1</mark>');
    }

    /**
     * Smooth scroll to element
     */
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

    /**
     * Copy text to clipboard
     */
    async copyToClipboard(text) {
        try {
            await navigator.clipboard.writeText(text);
            this.showSuccess('Copied to clipboard');
            return true;
        } catch (error) {
            console.error('Failed to copy text:', error);
            this.showError('Failed to copy text');
            return false;
        }
    }

    /**
     * Format date for display
     */
    formatDate(date, format = 'default') {
        const d = new Date(date);
        
        switch (format) {
            case 'short':
                return d.toLocaleDateString();
            case 'long':
                return d.toLocaleDateString('en-US', { 
                    year: 'numeric', 
                    month: 'long', 
                    day: 'numeric' 
                });
            case 'time':
                return d.toLocaleTimeString();
            case 'datetime':
                return d.toLocaleString();
            default:
                return d.toLocaleDateString();
        }
    }

    /**
     * Debounce function for search inputs
     */
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

    /**
     * Check if element is in viewport
     */
    isInViewport(element) {
        const rect = element.getBoundingClientRect();
        return (
            rect.top >= 0 &&
            rect.left >= 0 &&
            rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
            rect.right <= (window.innerWidth || document.documentElement.clientWidth)
        );
    }

    /**
     * Add keyboard navigation support
     */
    addKeyboardNavigation(elements, onSelect) {
        let currentIndex = -1;
        
        document.addEventListener('keydown', (e) => {
            if (!elements || elements.length === 0) return;
            
            switch (e.key) {
                case 'ArrowDown':
                    e.preventDefault();
                    currentIndex = (currentIndex + 1) % elements.length;
                    this.highlightElement(elements[currentIndex]);
                    break;
                case 'ArrowUp':
                    e.preventDefault();
                    currentIndex = currentIndex <= 0 ? elements.length - 1 : currentIndex - 1;
                    this.highlightElement(elements[currentIndex]);
                    break;
                case 'Enter':
                    e.preventDefault();
                    if (currentIndex >= 0 && elements[currentIndex] && onSelect) {
                        onSelect(elements[currentIndex], currentIndex);
                    }
                    break;
                case 'Escape':
                    currentIndex = -1;
                    elements.forEach(el => el.classList.remove('highlighted'));
                    break;
            }
        });
    }

    /**
     * Highlight element for keyboard navigation
     */
    highlightElement(element) {
        // Remove highlight from all elements
        document.querySelectorAll('.highlighted').forEach(el => {
            el.classList.remove('highlighted');
        });
        
        // Add highlight to current element
        if (element) {
            element.classList.add('highlighted');
            element.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
        }
    }

    /**
     * Create progress bar
     */
    createProgressBar(containerId, progress = 0) {
        const container = document.getElementById(containerId);
        if (!container) return;

        const progressHtml = `
            <div class="w-full bg-gray-700 rounded-full h-2">
                <div class="bg-blue-500 h-2 rounded-full transition-all duration-300" style="width: ${progress}%"></div>
            </div>
        `;

        container.innerHTML = progressHtml;
    }

    /**
     * Update progress bar
     */
    updateProgressBar(containerId, progress) {
        const container = document.getElementById(containerId);
        if (!container) return;

        const progressBar = container.querySelector('div > div');
        if (progressBar) {
            progressBar.style.width = `${progress}%`;
        }
    }

    /**
     * Clean up UI resources
     */
    cleanup() {
        // Remove event listeners
        const modals = document.querySelectorAll('[id$="Modal"]');
        modals.forEach(modal => modal.remove());

        // Clear notifications
        const notifications = document.querySelectorAll('.notification');
        notifications.forEach(notification => notification.remove());

        // Clear timers if any
        this.clearAllTimers();
    }

    /**
     * Clear all active timers
     */
    clearAllTimers() {
        // Implementation depends on how timers are tracked
        // This is a placeholder for timer cleanup
    }
}

export { UIManager };
