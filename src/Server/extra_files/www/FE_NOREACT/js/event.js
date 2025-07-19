import { LoginAPI, CacheAPI } from './api.js';

const loginApi = new LoginAPI();
const cacheApi = new CacheAPI();


// button-auth LOGIN
document.getElementById('button-auth').addEventListener('click', () => {
  const username = document.getElementById('loginUsername').value.trim();
  const password = document.getElementById('loginPassword').value;
  loginApi.PostLogin(username, password);
  
});
