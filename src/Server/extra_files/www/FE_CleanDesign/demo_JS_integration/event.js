document.addEventListener('DOMContentLoaded', () => {
  const userId = localStorage.getItem('userId'); // Assume userId is stored

  function getCurrentFilters() {
    return {
      genre: document.getElementById('genreFilter')?.value || 'All Genres',
      platform: document.getElementById('platformFilter')?.value || 'All Platforms'
    };
  }

  Handle.listenIfExists = function(selector, event, callback) {
    const element = document.querySelector(selector);
    if (element) element.addEventListener(event, callback);
  };

  Handle.listenIfExists('#genreFilter', 'change', () => Handle.handleLoggedGamesFetch(userId, getCurrentFilters(), document.getElementById('sortOption').value, document.getElementById('reviewedFilter').checked));
  Handle.listenIfExists('#platformFilter', 'change', () => Handle.handleLoggedGamesFetch(userId, getCurrentFilters(), document.getElementById('sortOption').value, document.getElementById('reviewedFilter').checked));
  Handle.listenIfExists('#sortOption', 'change', () => Handle.handleLoggedGamesFetch(userId, getCurrentFilters(), document.getElementById('sortOption').value, document.getElementById('reviewedFilter').checked));
  Handle.listenIfExists('#reviewedFilter', 'change', () => Handle.handleLoggedGamesFetch(userId, getCurrentFilters(), document.getElementById('sortOption').value, document.getElementById('reviewedFilter').checked));
  Handle.listenIfExists('#loadMoreGames', 'click', () => Handle.handleLoggedGamesFetch(userId, getCurrentFilters(), document.getElementById('sortOption').value, document.getElementById('reviewedFilter').checked, true));
  Handle.listenIfExists('.edit-profile', 'click', () => Handle.handleProfileGamesUpdate(userId, UI.collectProfileData()));

  // Initial load
  if (userId) Handle.handleProfileGamesFetch(userId);
  if (userId) Handle.handleLoggedGamesFetch(userId, getCurrentFilters(), 'Date Logged', false);
});