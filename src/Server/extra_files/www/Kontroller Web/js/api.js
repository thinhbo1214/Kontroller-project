function showResponse(text) {
  const pre = document.getElementById('response');
  pre.textContent = text;
}
function isTokenValid(token) {
  try {
    const decoded = atob(token); // base64 decode
    const [sessionId, expire] = decoded.split(':');
    return parseInt(expire) > Math.floor(Date.now() / 1000);
  } catch {
    return false;
  }
}


// === Base API ===
class API {
  static baseUrl = ''; // Override ở class con

  // Hàm để gửi request đến API
  // method: 'GET', 'POST', 'PUT', 'DELETE'
  async request(method, path, options = {}) {
    const url = this.constructor.baseUrl + path; // url của API

    const headers = options.headers || {}; // Tạo headers từ options
    const token = API.getToken();  // Lấy token từ localStorage

    if (token) {
      headers['X_Token_Authorization'] = token; // Gửi token nếu có
    }

    options.headers = headers; // thêm dòng này để đảm bảo headers có token

    // fetch để gửi request và nhận response
    const res = await fetch(url, {
      ...options, // Tham số bổ sung từ options
      method, // Phương thức HTTP (GET, POST, PUT, DELETE)
      credentials: 'include' // Gửi cookie (sessionId) kèm theo request  (nếu server dùng cookie, vẫn giữ)
    });

    // === Nhận token mới nếu có ===
    const newToken = res.headers.get('X_Token_Authorization');
    if (newToken) { // Nếu có header X_Token_Authorization trong response
      API.setToken(newToken); // Lưu lại token mới
    }

    const contentType = res.headers.get('content-type') || ''; // Lấy header Content-Type
    const isJson = contentType.includes('application/json'); // Kiểm tra xem response có phải JSON không
    const data = isJson ? await res.json() : await res.text(); // Đọc dữ liệu từ response

    return { ok: res.ok, status: res.status, data }; // Trả về đối tượng chứa thông tin response
  }

  // Hàm để xây dựng query string từ đối tượng params
  // Ví dụ: buildQuery({ key1: 'value1', key2: 'value2' }) => '?key1=value1&key2=value2'
  static buildQuery(params = {}) {
    const query = Object.entries(params)
      .map(([k, v]) => `${encodeURIComponent(k)}=${encodeURIComponent(v)}`)
      .join('&');
    return query ? `?${query}` : '';
  }
  static buildPathWithQuery(path = '', params = {}) {
    const query = this.buildQuery(params);
    const prefix = path.startsWith('/') ? path : `/${path}`;
    return query ? `${prefix}${query}` : `${prefix}`;
  }
  // Hàm để lấy token từ localStorage
  static getToken() {
    return localStorage.getItem('token');
  }

  // Hàm để lưu token vào localStorage
  static setToken(token) {
    localStorage.setItem('token', token);
  }

  // Hàm GET để lấy dữ liệu từ API
  GET(path, options = {}) {
    return this.request('GET', path, options);
  }

  // Hàm POST để gửi dữ liệu đến API
  POST(path, options = {}) {
    return this.request('POST', path, options);
  }

  // Hàm PUT để cập nhật dữ liệu trên API
  PUT(path, options = {}) {
    return this.request('PUT', path, options);
  }

  // Hàm DELETE để xóa dữ liệu trên API
  DELETE(path, options = {}) {
    return this.request('DELETE', path, options);
  }
}

export class APIAuth extends API {
  static baseUrl = '/api/auth';

  static isLoggedIn() {
    const token = localStorage.getItem('token');
    return token && isTokenValid(token);


  }
  // kiểm tra tài khoản mật khẩu trả về okay 
  async PostLogin(username, password) {
    if (!username || !password) {
      alert('Username and password are required!');
      return;
    }
    const payload = { username, password }
    const query = API.buildPathWithQuery('login');
    const res = await this.POST(query, {
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    return res;
  }

  async PostLogout() {
    const query = API.buildPathWithQuery('logout');
    const res = await this.POST(query, {
      headers: { 'Content-Type': 'application/json' },
      body: '{}' // hoặc có thể bỏ hẳn nếu server không cần body
    });

    return res;
  }
}


// API để tương tác với user
export class APIUser extends API {
  static baseUrl = '/api/user';

  async GetSelf() {
    const query = API.buildQuery({});
    const res = await this.GET(query);
    return res;
  }

  async GetUser(userId) {
    const query = API.buildQuery({ userId });
    const res = await this.GET(query);
    return res;
  }

  async PostUser(username, password, email) {
    const payload = { username, password, email };

    const res = await this.POST('', {
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    return res;
  }


  async PutUserEmail(email = '') {
    const payload = { email }
    const query = API.buildPathWithQuery('email');
    const res = await this.PUT(query, {
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    return res;
  }
  async PutUserAvatar(avatar = '') {
    const payload = { avatar }
    const query = API.buildPathWithQuery('avatar');

    const res = await this.PUT(query, {
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    return res;
  }
  async PutUserUsername(username = '') {
    const payload = { username }
    const query = API.buildPathWithQuery('username');

    const res = await this.PUT(query, {
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    return res;
  }
  async PutUserPassword(oldpassword = '', newpassword = '') {
    const payload = { oldpassword, newpassword }
    const query = API.buildPathWithQuery('password');

    const res = await this.PUT(query, {
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });
    return res;
  }

  async DeleteUser() {
    const query = API.buildQuery({});
    const res = await this.DELETE(query);
    return res;
  }
}
// API để tương tác với review
export class ReviewAPI extends API {
  static baseUrl = '/api/review';

  async GetReview(reviewId) {
    const query = API.buildQuery({ reviewId });
    const res = await this.GET(query);
    return res;
  }

  async PostReview(content, author, rating) {
    const payload = { content, author, rating };

    const res = await this.POST('', {
      headers: { 'Content-Type': 'application/json' },
      body: payload
    });

    return res;
  }

  async PutReview(reviewId, content, rating = null) {
    const payload = {}

    const res = await this.PUT(`?reviewId = ${reviewId}`, {
      headers: { 'Content-Type': 'application/json' },
      body: payload
    });
    return res;
  }

  async DeleteReview(reviewId) {
    const query = API.buildQuery({ reviewId });
    const res = await this.DELETE(query);
    return res;
  }
}
// API để tương tác với game
export class GameAPI extends API {
  static baseUrl = '/api/game';

  async GetGame(gameId = '') {
    const query = API.buildQuery({ gameId });
    const res = await this.GET(query);
    return res;
  }

  async PostGame(title = '', description = '', genre = '', poster = '', backdrop = '', details = [], services = []) {
    const payload = { title, description, genre, poster, backdrop, details, services };

    const res = await this.POST('', {
      headers: { 'Content-Type': 'application/json' },
      body: payload
    });

    return res;
  }


  async PutGame(gameId, title = '', description = '', genre = '', poster = '', backdrop = '', details = [], services = []) {
    const payload = { title, description, genre, poster, backdrop, details, services };

    const res = await this.PUT(`?gameId = ${gameId}`, {
      headers: { 'Content-Type': 'application/json' },
      body: payload
    });
    return res;
  }

  async DeleteGame(gameId) {
    const query = API.buildQuery({ gameId });
    const res = await this.DELETE(query);
    return res;
  }
}


// API để tương tác với cache

export class CacheAPI extends API {
  static baseUrl = '/api/cache';

  async GetCache(key) {
    const query = API.buildQuery({ key });
    const res = await this.GET(query);
    return res;
  }


  async PostCache(key, value) {
    if (!key) return alert('Key is required');

    const query = API.buildQuery({ key });
    const res = await this.POST(query, {
      headers: { 'Content-Type': 'text/plain' },
      body: value
    });

    return res;
  }

  async PutCache(key, value) {
    if (!key) return alert('Key is required');

    const query = API.buildQuery({ key });
    const res = await this.PUT(query, {
      headers: { 'Content-Type': 'text/plain' },
      body: value
    });
    return res;
  }

  async DeleteCache(key) {
    if (!key) return alert('Key is required');

    const query = API.buildQuery({ key });
    const res = await this.DELETE(query);
    return res;
  }
}