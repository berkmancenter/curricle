import axios from 'axios'

class CoursesAPI {
  static getBaseUrl () {
    return axios.get('/courses')
  }
}

export default {
  CoursesAPI
}
