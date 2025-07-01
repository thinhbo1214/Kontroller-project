class CacheApp {
  constructor(apiBaseCache, apiBaseLogin, responseElementId = 'response') {
    this.apiBaseCache = apiBaseCache;
    this.apiBaseLogin = apiBaseLogin;
    this.responseElement = document.getElementById(responseElementId);
  }

  fetchWithSession(url, options = {}) {
    return fetch(url, {
      ...options,
      credentials: 'include'
    });
  }

  showResponse(text) {
    if (this.responseElement) {
      this.responseElement.textContent = text;
    }
  }

  async login(usernameId = 'loginUsername', passwordId = 'loginPassword') {
    const username = document.getElementById(usernameId)?.value.trim();
    const password = document.getElementById(passwordId)?.value;

    if (!username || !password) {
      alert('Username and password are required!');
      return;
    }

    const payload = { username, password };

    try {
      const res = await this.fetchWithSession(this.apiBaseLogin, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      });

      if (res.ok) {
        this.showResponse('Login thành công');
      } else {
        const text = await res.text();
        this.showResponse(`Login thất bại: ${res.status} ${text}`);
      }
    } catch (err) {
      this.showResponse('Request failed: ' + err.message);
    }
  }

  async getCacheValue(keyInputId = 'getKey') {
    const key = document.getElementById(keyInputId)?.value.trim();
    let url = this.apiBaseCache;
    if (key) {
      url += '?key=' + encodeURIComponent(key);
    }

    try {
      const res = await this.fetchWithSession(url, { method: 'GET' });
      if (!res.ok) {
        const errText = await res.text();
        this.showResponse(`Error ${res.status}: ${errText}`);
        return;
      }

      const contentType = res.headers.get('content-type');
      let data;
      if (contentType && contentType.includes('application/json')) {
        data = await res.json();
        this.showResponse(JSON.stringify(data, null, 2));
      } else {
        data = await res.text();
        this.showResponse(data);
      }
    } catch (err) {
      this.showResponse('Request failed: ' + err.message);
    }
  }

  async putCacheValue(keyInputId = 'putKey', valueInputId = 'putValue') {
    const key = document.getElementById(keyInputId)?.value.trim();
    const value = document.getElementById(valueInputId)?.value;

    if (!key) {
      alert('Key is required for POST/PUT');
      return;
    }

    try {
      const res = await this.fetchWithSession(
        `${this.apiBaseCache}?key=${encodeURIComponent(key)}`,
        {
          method: 'POST',
          headers: { 'Content-Type': 'text/plain' },
          body: value
        }
      );

      if (!res.ok) {
        const errText = await res.text();
        this.showResponse(`Error ${res.status}: ${errText}`);
        return;
      }

      this.showResponse(`Success: Value saved for key "${key}"`);
    } catch (err) {
      this.showResponse('Request failed: ' + err.message);
    }
  }

  async deleteCacheValue(keyInputId = 'deleteKey') {
    const key = document.getElementById(keyInputId)?.value.trim();
    if (!key) {
      alert('Key is required for DELETE');
      return;
    }

    try {
      const res = await this.fetchWithSession(
        `${this.apiBaseCache}?key=${encodeURIComponent(key)}`,
        { method: 'DELETE' }
      );

      if (!res.ok) {
        const errText = await res.text();
        this.showResponse(`Error ${res.status}: ${errText}`);
        return;
      }

      const text = await res.text();
      this.showResponse(`Deleted value: ${text}`);
    } catch (err) {
      this.showResponse('Request failed: ' + err.message);
    }
  }
}
