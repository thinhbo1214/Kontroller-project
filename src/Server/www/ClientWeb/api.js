function showResponse(text) {
  const pre = document.getElementById('response');
  pre.textContent = text;
}
class API {
  static baseUrl = ''; // Class con override

  async request(method, path, options = {}) {
    const url = this.constructor.baseUrl + path;

    // fetch để gửi request và nhận response
    const res = await fetch(url, {
      ...options, // Tham số bổ sung từ options
      method, // Phương thức HTTP (GET, POST, PUT, DELETE)
      credentials: 'include' // Gửi cookie (sessionId) kèm theo request
    });

    const contentType = res.headers.get('content-type') || ''; // Lấy header Content-Type
    const isJson = contentType.includes('application/json'); // Kiểm tra xem response có phải JSON không
    const data = isJson ? await res.json() : await res.text(); // Đọc dữ liệu từ response

    return { ok: res.ok, status: res.status, data }; // Trả về đối tượng chứa thông tin response
  }

  GET(path, options = {}) {
    return this.request('GET', path, options);
  }

  POST(path, options = {}) {
    return this.request('POST', path, options);
  }

  PUT(path, options = {}) {
    return this.request('PUT', path, options);
  }

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
    const path = key ? '?key=' + encodeURIComponent(key) : '';
    const res = await this.GET(path);

    if (res.ok) {
      showResponse(typeof res.data === 'string' ? res.data : JSON.stringify(res.data, null, 2));
    } else {
      showResponse(`Error ${res.status}: ${res.data}`);
    }
  }

  async PostCache(key, value) {
    if (!key) return alert('Key is required');

    const res = await this.POST('?key=' + encodeURIComponent(key), {
      headers: { 'Content-Type': 'text/plain' },
      body: value
    });

    showResponse(res.ok ? 'Saved successfully' : `Error ${res.status}: ${res.data}`);
  }

    async PutCache(key, value) {
    if (!key) return alert('Key is required');

    const res = await this.PUT('?key=' + encodeURIComponent(key), {
      headers: { 'Content-Type': 'text/plain' },
      body: value
    });

    showResponse(res.ok ? 'Saved successfully' : `Error ${res.status}: ${res.data}`);
  }

  async DeleteCache(key) {
    if (!key) return alert('Key is required');

    const res = await this.DELETE('?key=' + encodeURIComponent(key));

    showResponse(res.ok ? `Deleted: ${res.data}` : `Error ${res.status}: ${res.data}`);
  }
}

