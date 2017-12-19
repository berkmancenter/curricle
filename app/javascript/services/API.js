// AXIOS setup
let axios = require('axios');
axios.defaults.xsrfHeaderName = "X-CSRFToken";
axios.defaults.xsrfCookieName = "csrftoken";

// import auth from '../_auth';

function getCookie(name) {
    var cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        var cookies = document.cookie.split(';');
        for (var i = 0; i < cookies.length; i++) {
            var cookie = cookies[i].trim();
            // Does this cookie string begin with the name we want?
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}

let xsrfCookie = getCookie('csrftoken');

let axiosAPI = axios.create({
  timeout: 15000,
  headers: {
    'X-CSRFToken': xsrfCookie
  },
});

axiosAPI.interceptors.response.use((response) => {
    // Do something with response data
    return response;
  }, (error) => {
    // is user is not authenticated then clear auth data and
    // redirect to login page that is handled by Django
    if (error.response.status === 401) {
      // auth.logout();
      window.location.href = '';
    }
    if (error.response.status === 404) {
      console.log('error 404');
      // originalRequest._retry = true;
      // window.location.href = '/';
      return;
    }
    // Do something with response error
    console.log('error: ', error);
    return Promise.reject(error);
  });


module.exports = axiosAPI;
