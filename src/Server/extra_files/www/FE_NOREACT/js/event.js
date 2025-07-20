import { LoginAPI, CacheAPI } from './api.js';

const loginApi = new LoginAPI();


// button-auth LOGIN
document.getElementById('button-auth').addEventListener('click', async () => {
  const username = document.getElementById('loginUsername').value;
  const password = document.getElementById('loginPassword').value;
  const res = await loginApi.PostLogin(username, password);
  if (res.ok){
    window.location.href = 'profile.html';
  }
  else{
    alert(res.data.message || 'Login failed');
  }
});
