class UIManager {
  static updateProfileDisplay(data, stats) {
    document.getElementById('username').value = data.username || '';
    document.getElementById('avatar').value = data.avatar || '';
    document.getElementById('bio').value = data.bio || '';
    document.getElementById('externalLinks').value = data.external_links?.join(', ') || '';
    const favGames = document.getElementById('favoriteGames');
    favGames.innerHTML = data.favorite_games?.slice(0, 5).map(poster => `<img src="${poster}" width="50">`).join('') || '';
    const currPlaying = document.getElementById('currentlyPlaying');
    currPlaying.innerHTML = data.currently_playing?.slice(0, 3).map(title => `<span>${title}</span>`).join(', ') || '';

    document.getElementById('followerCount').textContent = stats.follower_count || 0;
    document.getElementById('followingCount').textContent = stats.following_count || 0;
    document.getElementById('loggedGamesCount').textContent = stats.logged_games_count || 0;
    document.getElementById('listsCount').textContent = stats.lists_count || 0;
    // Add logic for recent logs, reviews, lists (assume IDs exist)
  }

  static addLoggedGamesToPage(games, loadMore = false) {
    const container = document.getElementById('loggedGamesGrid');
    if (!loadMore) container.innerHTML = '';
    games.forEach(game => {
      const card = document.createElement('div');
      card.className = 'game-card';
      card.innerHTML = `<h3>${game.title}</h3><div class="rating">${'★'.repeat(game.rating || 0)}</div>`;
      container.appendChild(card);
    });
    this.showLoadMore(games.length >= 10); // Assume 10 items per page
  }

  static showLoadMore(show) {
    const button = document.getElementById('loadMoreGames');
    if (button) button.style.display = show ? 'block' : 'none';
  }

  static collectProfileData() {
    return {
      username: document.getElementById('username').value,
      avatar: document.getElementById('avatar').value,
      bio: document.getElementById('bio').value,
      external_links: document.getElementById('externalLinks').value.split(',').map(l => l.trim()).filter(l => l),
      favorite_games: Array.from(document.querySelectorAll('#favoriteGames img')).map(img => img.src),
      currently_playing: document.getElementById('currentlyPlaying').textContent.split(',').map(t => t.trim())
    };
  }

  static showNotification(message) {
    const notification = document.createElement('div');
    notification.textContent = message;
    notification.style.cssText = 'position: fixed; top: 10px; left: 50%; transform: translateX(-50%); background: #4a90e2; color: white; padding: 10px; border-radius: 5px; z-index: 1000';
    document.body.appendChild(notification);
    setTimeout(() => notification.remove(), 3000);
  }

  static showLoading() {
    let loading = document.getElementById('loading');
    if (!loading) {
      loading = document.createElement('div');
      loading.id = 'loading';
      loading.textContent = 'Loading...';
      loading.style.cssText = 'position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background: rgba(0,0,0,0.8); color: white; padding: 20px; border-radius: 5px; z-index: 1000';
      document.body.appendChild(loading);
    }
  }

  static hideLoading() {
    const loading = document.getElementById('loading');
    if (loading) loading.remove();
  }
}