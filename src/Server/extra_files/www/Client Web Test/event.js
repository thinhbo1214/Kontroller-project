import { LoginAPI, CacheAPI } from './api.js';

const loginApi = new LoginAPI();
const cacheApi = new CacheAPI();

// Gắn sự kiện cho nút
document.getElementById('button-post-login').addEventListener('click', () => {
  const username = document.getElementById('inputUsername-post-login').value.trim();
  const password = document.getElementById('inputPassword-post-login').value;
  loginApi.PostLogin(username, password);
});

document.getElementById('button-get-cache').addEventListener('click', () => {
  const key = document.getElementById('inputKey-get-cache').value.trim();
  cacheApi.GetCache(key);
});

document.getElementById('button-post-cache').addEventListener('click', () => {
  const key = document.getElementById('inputKey-post-cache').value.trim();
  const value = document.getElementById('inputValue-post-cache').value;
  cacheApi.PostCache(key, value);
});

document.getElementById('button-put-cache').addEventListener('click', () => {
  const key = document.getElementById('inputKey-put-cache').value.trim();
  const value = document.getElementById('inputValue-put-cache').value;
  cacheApi.PutCache(key, value);
});

document.getElementById('button-delete-cache').addEventListener('click', () => {
  const key = document.getElementById('inputKey-delete-cache').value.trim();
  cacheApi.DeleteCache(key);
});