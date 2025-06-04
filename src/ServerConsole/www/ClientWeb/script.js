const apiBase = '/api/cache';

function showResponse(text) {
  const pre = document.getElementById('response');
  pre.textContent = text;
}

async function getCacheValue() {
  const key = document.getElementById('getKey').value.trim();
  let url = apiBase;
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
    const res = await fetch(apiBase + '?key=' + encodeURIComponent(key), {
      method: 'POST', // or 'PUT' if you want to test PUT
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
    const res = await fetch(apiBase + '?key=' + encodeURIComponent(key), {
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
