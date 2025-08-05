class Handle {
  static async handleProfileGamesFetch(userId) {
    UI.showLoading();
    try {
      const [profileData, stats] = await Promise.all([
        GameAPI.GetProfileGames(userId),
        GameAPI.GetStats(userId)
      ]);
      UI.updateProfileDisplay(profileData, stats);
    } catch (error) {
      UI.showNotification('Failed to load profile data');
    } finally {
      UI.hideLoading();
    }
  }

  static async handleLoggedGamesFetch(userId, filter = {}, sort = 'Date Logged', reviewedOnly = false, loadMore = false) {
    UI.showLoading();
    try {
      const games = await GameAPI.GetLoggedGames(userId, filter, sort, reviewedOnly);
      UI.addLoggedGamesToPage(games, loadMore);
    } catch (error) {
      UI.showNotification('Failed to load games');
    } finally {
      UI.hideLoading();
    }
  }

  static async handleProfileGamesUpdate(userId, data) {
    UI.showLoading();
    try {
      await GameAPI.PutProfileGames(userId, data);
      await Handle.handleProfileGamesFetch(userId); // Refresh display
      UI.showNotification('Profile updated successfully');
    } catch (error) {
      UI.showNotification('Failed to update profile');
    } finally {
      UI.hideLoading();
    }
  }
}