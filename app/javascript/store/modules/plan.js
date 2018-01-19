// Manipulation of plan-related data

import { mapGetters } from 'vuex'
import _ from 'lodash'

const state = {
  filters: {},
  filterCategories: [
    {
      field: 'department',
      title: 'Department'
    },
    {
      field: 'semester',
      title: 'Semester'
    }
  ],
  selectedCourse: {}
}

const getters = {
  filteredCourses (state, getters) {
    // per lodash docs, empty object is true for all
    return _.filter(getters.trayCourses, state.filters)
  },
  // this is to import the vuex user.trayCourses and use locally as dependent
  trayCourses (state, getters, rootState, rootGetters) {
    return rootGetters['user/trayCourses']
  },
  departmentsInTray (state, getters) {
    console.log(getters.trayCourses)
    return _.uniq(getters.trayCourses.map(k => k.department).sort)
  },
  semestersInTray (state, getters) {
    return _.uniq(getters.trayCourses.map(k => k.semester).sort)
  },
  eventData (state, getters) {
    return getters.trayCourses
      .filter(item => !!item.user_schedule[0].course_meeting_pattern_id)
      .map(item => {
        return {
          title: ' ',
          start: item.meeting_with_tods.meeting_time_start,
          end: item.meeting_with_tods.meeting_time_end,
          description: item.subject_description,
          course: item
        }
      })
  }
}

const actions = {
  setFilter ({commit}, filter) {
    commit('SET_FILTER', filter)
  },
  populateEvents ({state}) {
    _.each(state.eventData, event => $('.full-calendar').fullCalendar('renderEvent', event))
  },
  removeEvents () {
    $('.full-calendar').fullCalendar('clientEvents').map(function (event) {
      $('.full-calendar').fullCalendar('removeEvents', event._id)
    })
  },
  setEvent () {
    $('.full-calendar').fullCalendar({
      defaultView: 'agendaWeek',
      allDaySlot: false,
      displayEventTime: false,
      slotDuration: '00:60:00',
      columnFormat: 'ddd',
      weekends: false,
      events: this.events_arr,
      eventRender: function (event, element) {
        element.find('.fc-title').after("<div class='event-description'>" + '<p>' + event.course.external_course_id + '</p>' + '<p>' + event.description + '</p>' + '<p>' + '<b>' + event.course.academic_group + '</b>' + '</p>' + '<p>' + '<b>' + event.course.subject + '</b>' + '</p>' + '</div>')
      },
      eventClick: function (calEvent, jsEvent, view) {
        console.log('XXX - need click event handler')
        // calEvent.self.selectedPlan(calEvent.course)
      }
    })
  }
}

const mutations = {
  SET_FILTER (state, {name, value}) {
    if (value == '') {
      delete state.filters[name]
    } else {
      state.filters[name] = value
    }
  }
}

export default {
  namespaced: true,
  state,
  getters,
  actions,
  mutations
}
