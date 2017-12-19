import axios from 'axios';

class CoursesAPI {
  static getBaseUrl() {
  	var url = '/courses'
    return axios.get(url);
  }
}

export default {
  CoursesAPI
}
