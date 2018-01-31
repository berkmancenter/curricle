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
