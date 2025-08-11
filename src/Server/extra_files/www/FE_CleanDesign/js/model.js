
export class Model {
    // ======== Data =========
    static CLOUDINARY_CLOUD_NAME = 'dynmsbofr';
    static CLOUDINARY_UPLOAD_PRESET = 'avatar_upload';
    static selectedFile = null;

    // Idle detect
    static idleTimer;
    static idleLimit = 5 * 60 * 1000; // 5 phút


    // ============== Method ===============
    // ===== LocalStorage =====
    static getLocalStorage(key) {
        return localStorage.getItem(key);
    }

    static setLocalStorage(key, value) {
        localStorage.setItem(key, value);
    }

    static deleteLocalStorage(key) {
        localStorage.removeItem(key);
    }

    static clearLocalStorage() {
        localStorage.clear();
    }

    // JSON version
    static getLocalStorageJSON(key) {
        const value = localStorage.getItem(key);
        return value ? JSON.parse(value) : null;
    }

    static setLocalStorageJSON(key, value) {
        localStorage.setItem(key, JSON.stringify(value));
    }

    // ===== SessionStorage =====
    static getSessionStorage(key) {
        return sessionStorage.getItem(key);
    }

    static setSessionStorage(key, value) {
        sessionStorage.setItem(key, value);
    }

    static deleteSessionStorage(key) {
        sessionStorage.removeItem(key);
    }

    static clearSessionStorage() {
        sessionStorage.clear();
    }

    // JSON version
    static getSessionStorageJSON(key) {
        const value = sessionStorage.getItem(key);
        return value ? JSON.parse(value) : null;
    }

    static setSessionStorageJSON(key, value) {
        sessionStorage.setItem(key, JSON.stringify(value));
    }

    // ===== Auth Token =====
    static getAuthToken() {
        return this.getLocalStorage('authToken');
    }

    static deleteAuthToken() {
        this.deleteLocalStorage('authToken');
    }
    static isAuthTokenValid(token) {
        try {
            const decoded = atob(token); // base64 decode
            const [sessionId, expire] = decoded.split(':');
            return parseInt(expire) > Math.floor(Date.now() / 1000);
        } catch {
            return false;
        }
    }

    // ==== User Profile =====
    static getUserProfile() {
        return this.getLocalStorageJSON('userProfile');
    }

    static setUserProfile(userProfile) {
        this.setLocalStorageJSON('userProfile', userProfile);
    }

    static deleteUserProfile() {
        this.deleteLocalStorage('userProfile');
    }

}

