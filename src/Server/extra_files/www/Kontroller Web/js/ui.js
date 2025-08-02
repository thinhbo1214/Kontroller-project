export class UI {
    static toast(msg, duration = 3000) {
        const toast = document.createElement('div');
        toast.textContent = msg;
        toast.style.position = 'fixed';
        toast.style.bottom = '20px';
        toast.style.left = '50%';
        toast.style.transform = 'translateX(-50%)';
        toast.style.backgroundColor = '#333';
        toast.style.color = '#fff';
        toast.style.padding = '10px 20px';
        toast.style.borderRadius = '5px';
        toast.style.boxShadow = '0 0 10px rgba(0,0,0,0.3)';
        toast.style.zIndex = 1000;
        toast.style.opacity = '0';
        toast.style.transition = 'opacity 0.3s ease';

        document.body.appendChild(toast);
        setTimeout(() => toast.style.opacity = '1', 10);
        setTimeout(() => {
            toast.style.opacity = '0';
            setTimeout(() => toast.remove(), 300);
        }, duration);
    }

    static showLoading() {
        if (document.getElementById('ui-loading')) return;
        const loading = document.createElement('div');
        loading.id = 'ui-loading';
        loading.style.position = 'fixed';
        loading.style.top = 0;
        loading.style.left = 0;
        loading.style.width = '100%';
        loading.style.height = '100%';
        loading.style.background = 'rgba(0,0,0,0.3)';
        loading.style.display = 'flex';
        loading.style.alignItems = 'center';
        loading.style.justifyContent = 'center';
        loading.style.zIndex = 999;
        loading.innerHTML = `<div style="padding:20px; background:white; border-radius:8px; box-shadow:0 0 10px rgba(0,0,0,0.2);">Loading...</div>`;
        document.body.appendChild(loading);
    }

    static hideLoading() {
        const loading = document.getElementById('ui-loading');
        if (loading) loading.remove();
    }

    static goTo(page) {
        window.location.href = page;
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
    REGISTER: 'rigister.html',
    REVIEW: 'review.html' 
};
