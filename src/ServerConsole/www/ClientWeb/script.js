const apiBaseCache = '/api/cache';
const apiBaseLogin = '/api/login';

function showResponse(text) {
  const pre = document.getElementById('response');
  pre.textContent = text;
}

async function login() {
  const username = document.getElementById('loginUsername').value.trim();
  const password = document.getElementById('loginPassword').value;

  if (!username || !password) {
    alert('Username and password are required!');
    return;
  }

  const payload = { username, password };

  try {
    const res = await fetch(apiBaseLogin, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(payload)
    });

    if (!res.ok) {
      showResponse(`Login failed: ${res.status} ${await res.text()}`);
      return;
    }

    // Giả sử server trả về JSON token hoặc thông báo
    const data = await res.json();
    showResponse('Login success:\n' + JSON.stringify(data, null, 2));
  } catch (err) {
    showResponse('Request failed: ' + err.message);
  }
}

// Các hàm cache hiện tại, chỉ đổi tên apiBase thành apiBaseCache
async function getCacheValue() {
  const key = document.getElementById('getKey').value.trim();
  let url = apiBaseCache;
  if (key) {
    url += '?key=' + encodeURIComponent(key);
  }

  try {
    const res = await fetch(url, { method: 'GET' });
    if (!res.ok) {
      showResponse(`Error ${res.status}: ${await res.text()}`);
      return;
    }
    const contentType = res.headers.get('content-type');
    let data;
    if (contentType && contentType.includes('application/json')) {
      data = await res.json();
      showResponse(JSON.stringify(data, null, 2));
    } else {
      data = await res.text();
      showResponse(data);
    }
  } catch (err) {
    showResponse('Request failed: ' + err.message);
  }
}

async function putCacheValue() {
  const key = document.getElementById('putKey').value.trim();
  const value = document.getElementById('putValue').value;

  if (!key) {
    alert('Key is required for POST/PUT');
    return;
  }

  try {
    const res = await fetch(apiBaseCache + '?key=' + encodeURIComponent(key), {
      method: 'POST',
      headers: {
        'Content-Type': 'text/plain'
      },
      body: value
    });
    if (!res.ok) {
      showResponse(`Error ${res.status}: ${await res.text()}`);
      return;
    }
    showResponse('Success: Value saved for key "' + key + '"');
  } catch (err) {
    showResponse('Request failed: ' + err.message);
  }
}

async function deleteCacheValue() {
  const key = document.getElementById('deleteKey').value.trim();
  if (!key) {
    alert('Key is required for DELETE');
    return;
  }

  try {
    const res = await fetch(apiBaseCache + '?key=' + encodeURIComponent(key), {
      method: 'DELETE'
    });
    if (!res.ok) {
      showResponse(`Error ${res.status}: ${await res.text()}`);
      return;
    }
    const text = await res.text();
    showResponse('Deleted value: ' + text);
  } catch (err) {
    showResponse('Request failed: ' + err.message);
  }
}
