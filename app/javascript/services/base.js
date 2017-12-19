// import axios from './axios';
import axios from 'axios';

class BaseApi {
  static getBaseUrl() {
    throw 'Base resource url is undefined';
  }

  static create(data) {
    return axios.post(this.getBaseUrl(), data);
  }

  static update(data) {
    return axios.put(`${this.getBaseUrl()}${data.id}/`, data);
  }

  static remove(id) {
    return axios.delete(`${this.getBaseUrl()}${id}/`);
  }

  static fetch(id) {
    return axios.get(`${this.getBaseUrl()}${id}/`);
  }

  static fetchList(params) {
    return axios.get(this.getBaseUrl(), {params: params});
  }
}

module.exports = BaseApi;
