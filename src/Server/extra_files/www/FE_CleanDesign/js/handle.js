// handle.js - Xử lý logic xác thực và API calls
import { LoginAPI } from './api.js';

class AuthHandler {
    constructor() {
        this.loginAPI = new LoginAPI();
        this.maxRetries = 3;
        this.retryDelay = 1000; // 1 second
    }

    /**
     * Xử lý đăng nhập
     * @param {string} username - Tên đăng nhập
     * @param {string} password - Mật khẩu
     * @returns {Promise<{success: boolean, message?: string, data?: any}>}
     */
    async login(username, password) {
        try {
            // Validate inputs
            const validation = this.validateCredentials(username, password);
            if (!validation.valid) {
                return {
                    success: false,
                    message: validation.message
                };
            }

            // Attempt login with retry mechanism
            const result = await this.loginWithRetry(username, password);
            
            if (result.ok) {
                // Login successful
                const userData = result.data;
                
                // Store user data and token
                this.storeAuthData(userData);
                
                // Log successful login
                this.logActivity('login_success', { username });
                
                return {
                    success: true,
                    data: userData
                };
            } else {
                // Login failed
                const errorMessage = this.getErrorMessage(result.status, result.data);
                
                // Log failed login
                this.logActivity('login_failed', { username, status: result.status });
                
                return {
                    success: false,
                    message: errorMessage
                };
            }

        } catch (error) {
            console.error('Login handler error:', error);
            
            // Log error
            this.logActivity('login_error', { username, error: error.message });
            
            return {
                success: false,
                message: 'Network error. Please check your connection and try again.'
            };
        }
    }

    /**
     * Đăng nhập với cơ chế retry
     */
    async loginWithRetry(username, password, attempt = 1) {
        try {
            const result = await this.loginAPI.PostLogin(username, password);
            return result;
        } catch (error) {
            if (attempt < this.maxRetries && this.isRetryableError(error)) {
                console.warn(`Login attempt ${attempt} failed, retrying...`);
                await this.delay(this.retryDelay * attempt);
                return this.loginWithRetry(username, password, attempt + 1);
            }
            throw error;
        }
    }

    /**
     * Kiểm tra xem lỗi có thể retry được không
     */
    isRetryableError(error) {
        // Network errors, timeouts, và 5xx server errors có thể retry
        return (
            error.name === 'TypeError' || // Network error
            error.name === 'TimeoutError' ||
            (error.status >= 500 && error.status < 600)
        );
    }

    /**
     * Delay utility function
     */
    delay(ms) {
        return new Promise(resolve => setTimeout(resolve, ms));
    }

    /**
     * Validate credentials
     */
    validateCredentials(username, password) {
        if (!username || !password) {
            return {
                valid: false,
                message: 'Username and password are required'
            };
        }

        if (typeof username !== 'string' || typeof password !== 'string') {
            return {
                valid: false,
                message: 'Invalid credential format'
            };
        }

        if (username.trim().length < 3) {
            return {
                valid: false,
                message: 'Username must be at least 3 characters long'
            };
        }

        if (password.length < 4) {
            return {
                valid: false,
                message: 'Password must be at least 4 characters long'
            };
        }

        // Check for potentially dangerous characters
        const dangerousChars = /[<>\"'&]/;
        if (dangerousChars.test(username) || dangerousChars.test(password)) {
            return {
                valid: false,
                message: 'Invalid characters in credentials'
            };
        }

        return { valid: true };
    }

    /**
     * Get error message based on status code
     */
    getErrorMessage(status, data) {
        switch (status) {
            case 400:
                return data?.message || 'Invalid request. Please check your credentials.';
            case 401:
                return 'Invalid username or password. Please try again.';
            case 403:
                return 'Access denied. Your account may be suspended.';
            case 404:
                return 'Login service not found. Please contact support.';
            case 429:
                return 'Too many login attempts. Please wait a moment and try again.';
            case 500:
                return 'Server error. Please try again later.';
            case 502:
            case 503:
            case 504:
                return 'Service temporarily unavailable. Please try again later.';
            default:
                return data?.message || 'Login failed. Please try again.';
        }
    }

    /**
     * Store authentication data
     */
    storeAuthData(userData) {
        try {
            // Store user data
            if (userData.user) {
                this.setUserData(userData.user);
            }

            // Store token if provided
            if (userData.token) {
                this.setAuthToken(userData.token);
            }

            // Store login timestamp
            this.setLoginTime();

        } catch (error) {
            console.error('Error storing auth data:', error);
        }
    }

    /**
     * Set user data in localStorage
     */
    setUserData(user) {
        try {
            const userData = JSON.stringify(user);
            localStorage.setItem('user', userData);
        } catch (error) {
            console.error('Error storing user data:', error);
        }
    }

    /**
     * Set auth token
     */
    setAuthToken(token) {
        try {
            localStorage.setItem('authToken', token);
            // Also set in API class for future requests
            if (window.API) {
                window.API.setToken(token);
            }
        } catch (error) {
            console.error('Error storing auth token:', error);
        }
    }

    /**
     * Set login time
     */
    setLoginTime() {
        try {
            localStorage.setItem('loginTime', Date.now().toString());
        } catch (error) {
            console.error('Error storing login time:', error);
        }
    }

    /**
     * Get stored user data
     */
    getUserData() {
        try {
            const userData = localStorage.getItem('user');
            return userData ? JSON.parse(userData) : null;
        } catch (error) {
            console.error('Error retrieving user data:', error);
            return null;
        }
    }

    /**
     * Get stored auth token
     */
    getAuthToken() {
        try {
            return localStorage.getItem('authToken');
        } catch (error) {
            console.error('Error retrieving auth token:', error);
            return null;
        }
    }

    /**
     * Check if user is logged in
     */
    isLoggedIn() {
        const token = this.getAuthToken();
        const user = this.getUserData();
        const loginTime = localStorage.getItem('loginTime');
        
        if (!token || !user || !loginTime) {
            return false;
        }

        // Check if login is not too old (24 hours)
        const twentyFourHours = 24 * 60 * 60 * 1000;
        const isTokenValid = (Date.now() - parseInt(loginTime)) < twentyFourHours;
        
        return isTokenValid;
    }

    /**
     * Logout user
     */
    logout() {
        try {
            localStorage.removeItem('user');
            localStorage.removeItem('authToken');
            localStorage.removeItem('loginTime');
            localStorage.removeItem('token'); // Remove API token as well
            
            // Log logout activity
            this.logActivity('logout');
            
            // Redirect to login page
            window.location.href = 'auth.html';
        } catch (error) {
            console.error('Error during logout:', error);
        }
    }

    /**
     * Log user activity
     */
    logActivity(action, details = {}) {
        try {
            const logEntry = {
                action,
                timestamp: new Date().toISOString(),
                userAgent: navigator.userAgent,
                url: window.location.href,
                ...details
            };

            // Store in localStorage for debugging (keep only last 10 entries)
            const logs = JSON.parse(localStorage.getItem('activityLogs') || '[]');
            logs.unshift(logEntry);
            logs.splice(10); // Keep only last 10 entries
            localStorage.setItem('activityLogs', JSON.stringify(logs));

            // Could also send to server for analytics
            console.log('Activity logged:', logEntry);
        } catch (error) {
            console.error('Error logging activity:', error);
        }
    }

    /**
     * Clear old activity logs
     */
    clearOldLogs() {
        try {
            localStorage.removeItem('activityLogs');
        } catch (error) {
            console.error('Error clearing logs:', error);
        }
    }
}

export { AuthHandler };