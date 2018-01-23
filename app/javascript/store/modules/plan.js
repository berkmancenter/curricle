// Manipulation of plan-related data

import _ from 'lodash'
import $ from 'jquery'

function extractSchedule (courses) {
  return _.map(
    _.filter(courses, e => e.meeting_with_tods !== null),
    c => {
      var m = c.meeting_with_tods
      return {
        course_id: c.id,
        semester: c.term_name + ' ' + c.term_year,
        term_name: c.term_name,
        term_year: c.term_year,
        title: c.title,
        days: [
          m.meets_on_sunday ? [ m.meeting_time_start_tod, m.meeting_time_end_tod ] : undefined,
          m.meets_on_monday ? [ m.meeting_time_start_tod, m.meeting_time_end_tod ] : undefined,
          m.meets_on_tuesday ? [ m.meeting_time_start_tod, m.meeting_time_end_tod ] : undefined,
          m.meets_on_wednesday ? [ m.meeting_time_start_tod, m.meeting_time_end_tod ] : undefined,
          m.meets_on_thursday ? [ m.meeting_time_start_tod, m.meeting_time_end_tod ] : undefined,
          m.meets_on_friday ? [ m.meeting_time_start_tod, m.meeting_time_end_tod ] : undefined,
          m.meets_on_saturday ? [ m.meeting_time_start_tod, m.meeting_time_end_tod ] : undefined
        ]
      }
    }
  )
}

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
  ]
}

const getters = {
  filteredCourses (state, getters) {
    // per lodash docs, empty object is true for all
    return _.filter(getters.trayCourses, state.filters)
  },
  // this is to import the vuex user.trayCourses and use locally as dependent
  trayCourses (state, getters, rootState, rootGetters) {
    var courses = rootGetters['user/trayCourses']
    if (!courses) {
      return []
    }
    return courses
  },
  departmentsInTray (state, getters) {
    return _.uniq(getters.trayCourses.map(k => k.academic_group_description).sort())
  },
  semestersInTray (state, getters) {
    return _.uniq(getters.trayCourses.map(k => k.semester).sort())
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
  },
  // returns all courses which are currently scheduled in the tray ()
  scheduledCourses (state, getters) {
    return getters.trayCourses
      .filter(item => !!item.user_schedule[0].course_meeting_pattern_id)
  },
  scheduledCoursesBySemester (state, getters) {
    return _.groupBy(extractSchedule(getters.scheduledCourses), 'semester')
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
  setEvent ({getters}) {
    var events = getters.eventData

    $('.full-calendar').fullCalendar({
      defaultView: 'agendaWeek',
      allDaySlot: false,
      displayEventTime: false,
      slotDuration: '00:60:00',
      columnFormat: 'ddd',
      weekends: false,
      events: events,
      eventRender: function (event, element) {
        element.find('.fc-title').after("<div class='event-description'>" + '<p>' + event.course.external_course_id + '</p>' + '<p>' + event.description + '</p>' + '<p>' + '<b>' + event.course.academic_group + '</b>' + '</p>' + '<p>' + '<b>' + event.course.subject + '</b>' + '</p>' + '</div>')
      },
      eventClick: function (calEvent, jsEvent, view) {
        // calEvent.self.selectedPlan(calEvent.course)
      }
    })
  }
}

const mutations = {
  SET_FILTER (state, {name, value}) {
    if (value === '') {
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
