function showResponse(text) {
  const pre = document.getElementById('response');
  pre.textContent = text;
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

export class LoginAPI extends API{
  static baseUrl = '/api/login';

  // const username = document.getElementById('loginUsername').value.trim();
  // const password = document.getElementById('loginPassword').value;
    async PostLogin(username, password) {
      if (!username || !password) {
        alert('Username and password are required!');
        return;
      }
      const res = await this.POST('', {
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, password })
      });
      if (res.ok) {
        showResponse('Login thành công');
      } else {
        showResponse(`Login thất bại: ${res.status} ${res.data}`);
      }
  }
}

// API để tương tác với cache
export class CacheAPI extends API {
  static baseUrl = '/api/cache';

  async GetCache(key) {
    const query = API.buildQuery({ key }); 
    //const path = key ? '?key=' + encodeURIComponent(key) : '';
    const res = await this.GET(query);

    if (res.ok) {
      showResponse(typeof res.data === 'string' ? res.data : JSON.stringify(res.data, null, 2));
    } else {
      showResponse(`Error ${res.status}: ${res.data}`);
    }
  }

  async PostCache(key, value) {
    if (!key) return alert('Key is required');

    const query = API.buildQuery({ key }); 
    const res = await this.POST(query, {
      headers: { 'Content-Type': 'text/plain' },
      body: value
    });

    showResponse(res.ok ? 'Saved successfully' : `Error ${res.status}: ${res.data}`);
  }

    async PutCache(key, value) {
    if (!key) return alert('Key is required');

    const query = API.buildQuery({ key });     
    const res = await this.PUT(query, {
      headers: { 'Content-Type': 'text/plain' },
      body: value
    });

    showResponse(res.ok ? 'Saved successfully' : `Error ${res.status}: ${res.data}`);
  }

  async DeleteCache(key) {
    if (!key) return alert('Key is required');

    const query = API.buildQuery({ key }); 
    const res = await this.DELETE(query);

    showResponse(res.ok ? `Deleted: ${res.data}` : `Error ${res.status}: ${res.data}`);
  }
}

