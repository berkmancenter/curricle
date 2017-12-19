import coursesAPI from '../../services/coursesAPI';

const getCourses = (context) => {

    coursesAPI.getBaseUrl()
      .then((response) => {
        context.commit('COURSES', response.data.results);
      })
    .catch((error) => {
      // eslint-disable-next-line
      console.error(error);
    }
  );
};

export default {
  getCourses
}