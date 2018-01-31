/* This module is intended for pure JS-related utility functions; no
 * vuex stuff, no state-related management, no
 * side-effects. Everything here should be optionally exported so
 * individual components can pull in the pieces they need. Try to keep
 * this organized by section and export the individual functions by
 * group. */

import _ from 'lodash'

/** ********           Course-list related functions          **********/

/* This utility function will partition an array of courses into an
 * object indexed by day, with each course which appears in a specific
 * day showing up in a slot.  There is a special day named 'TBD' in
 * which all courses which are unschedulable are placed */

function partitionCoursesByDay (courses) {
  const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
  var ret = {
    Monday: [],
    Tuesday: [],
    Wednesday: [],
    Thursday: [],
    Friday: [],
    TBD: []
  }

  _.each(courses, c => {
    if (c.schedule && c.schedule.type === 'simple' && c.schedule.data.length) {
      _.each(c.schedule.data, (dat, idx) => {
        /* logic here is to add the course the corresponding day index
         * if it contains valid data, specifically one or more courses
         * meeting on this day */
        if (dat && dat.length) {
          ret[ days[idx] ].push(c)
        }
      })
    } else {
      /* course is currently not schedulable, report as TBD */
      ret.TBD.push(c)
    }
  })

  return ret
}

export { partitionCoursesByDay }

/** ********          Schedule-specific functions          **********/

function calcDuration (start, end) {
  if (!(start && end)) {
    return 0
  }
  var startPart = start.split(':')
  var endPart = end.split(':')

  var hours = endPart[0] - startPart[0]
  var mins = endPart[1] - startPart[1]

  return hours + Math.ceil(mins / 5) / 12
}

export { calcDuration }

/* transform the core course data into the expected days structure for other times */
function transformSchedule (c) {
  if (c && c.course_meeting_patterns && c.course_meeting_patterns.length) {
    const days = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday']
    const dayFields = _.map(days, d => 'meets_on_' + d)
    var schedule = []
    var courseAddCount = 0

    /* Conceptually, we are iterating over all of the rows and adding
     * to the schedule for the specific days to which this
     * course_meeting_pattern applies.  This will allow us to support disjoint
     * meeting times per day as well as the (unlikely) possibility that there
     * is a single course that meets multiple times per day.
     *
     * We will have to teach the routines which invert this structure
     * to know about the modification here, as well as the specific
     * components which display course times.  (Since these *should*
     * be abstracted out, the rest of the app shouldn't care, but you
     * know how that goes...)
     */
    _.each(
      c.course_meeting_patterns,
      pat => {
        var durs = [
          calcDuration('0:00', pat.meeting_time_start_tod),
          calcDuration(pat.meeting_time_start_tod, pat.meeting_time_end_tod)
        ]
        _.each(
          dayFields,
          (day, idx) => {
            courseAddCount++
            if (pat[day]) {
              if (!schedule[idx]) {
                schedule[idx] = []
              }
              schedule[idx].push(durs)
            }
          }
        )
      }
    )

    return courseAddCount ? { type: 'simple', data: schedule } : {}
  } else {
    // return empty object for no scheduled day/times
    return {}
  }
}

export { transformSchedule }

/* utility function to return a list of sorted semesters in the format "Fall 2011" */

function sortedSemesters (sems) {
  const semOrder = ['Spring', 'Summer', 'Fall']

  if (!sems) return []
  return sems.sort((a, b) => {
    if (a === b) {
      return 0
    }

    var aPart = a.split(' ')
    var bPart = b.split(' ')

    if (aPart[1] !== bPart[1]) {
      return Math.sign(aPart[1] - bPart[1])
    }

    return Math.sign(semOrder.indexOf(aPart[0]) - semOrder.indexOf(bPart[0]))
  })
}

export { sortedSemesters }
