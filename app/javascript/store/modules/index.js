import actions from './actions';
import getters from './getters';
import mutations from './mutations';
import constants from './constants';

const state = {
  courses: []
}

export default {
  namespaced: true,
  state,
  actions,
  getters,
  mutations,
  constants,
};