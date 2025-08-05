class GameAPI {
  static async GetProfileGames(userId) {
    const token = API.getToken();
    return await API.fetchData(`/api/games/profile/${userId}`, {
      headers: { 'X_Token_Authorization': `Bearer ${token}` }
    });
  }

  static async GetStats(userId) {
    const token = API.getToken();
    return await API.fetchData(`/api/games/stats/${userId}`, {
      headers: { 'X_Token_Authorization': `Bearer ${token}` }
    });
  }

  static async GetLoggedGames(userId, filter = {}, sort = 'Date Logged', reviewedOnly = false) {
    const token = API.getToken();
    const query = API.buildQuery({ ...filter, sort, reviewedOnly });
    return await API.fetchData(`/api/games/logged/${userId}${query}`, {
      headers: { 'X_Token_Authorization': `Bearer ${token}` }
    });
  }

  static async PutProfileGames(userId, data) {
    const token = API.getToken();
    return await API.fetchData(`/api/games/profile/${userId}`, {
      method: 'PUT',
      headers: { 'X_Token_Authorization': `Bearer ${token}`, 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    });
  }
}

// Ensure API class has these methods
API.buildQuery = function(params) {
  const query = Object.keys(params)
    .filter(key => params[key] !== undefined && params[key] !== '')
    .map(key => `${encodeURIComponent(key)}=${encodeURIComponent(params[key])}`)
    .join('&');
  return query ? `?${query}` : '';
};

API.fetchData = async function(url, options = {}) {
  const response = await fetch(url, options);
  if (!response.ok) throw new Error('Network response was not ok');
  return response.json();
};

API.setToken = function(token) { localStorage.setItem('token', token); };
API.getToken = function() { return localStorage.getItem('token'); };