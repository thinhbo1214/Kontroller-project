import { Handle } from './handle.js';

document.getElementById('button-auth').addEventListener('click', () => {
    const username = document.getElementById('loginUsername').value;
    const password = document.getElementById('loginPassword').value;
    Handle.Login(username, password);
});
