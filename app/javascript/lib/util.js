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
    if (courseCanSchedule(c)) {
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

/* Similar to partitionCoursesByDay, partitionCoursesByMeetingTime
 * returns a structure of partitioned data, however there is
 * additional context here for the use in the actual calendar meeting
 * time; each individual meeting event appears in conjunction with its
 * time and duration at a top level, with the course object referenced
 * as a sub-object.
 *
 * Object data structures are intentionally shared.
 *
 * Example return value, given an input course with one meeting time on Monday
 * { Monday: [[start: 8, duration: 1.5, course: {...}], Tuesday: [], Wednesday: [], Thursday: [], Friday: [], TBD: [] }
 */

function partitionCoursesByMeetingTime (courses) {
  // we leave TBD alone as a straight array of courses; the others we
  // need to invert for all of the meeting times
  const dayIdx = { Monday: 0, Tuesday: 1, Wednesday: 2, Thursday: 3, Friday: 4 }

  return _.mapValues(
    partitionCoursesByDay(courses),
    (dayCourses, key) => {
      if (key === 'TBD') {
        return dayCourses
      }

      var idx = dayIdx[key]

      if (_.isUndefined(idx)) {
        console.error('got unmapped key index as input', key)
        return dayCourses
      }

      var results = []

      _.each(dayCourses, course => {
        /* We are only implementing for simple schedules; this will
         * need to be taught about split schedules.  There should be
         * no cases of this since our data source already sticks these
         * into TBD category, but check anyway.  We also get to assume
         * that since this course appears in the day list then there
         * are already events on this day, so no duplicated checks
         * here.
         */

        if (course.schedule && course.schedule.type === 'simple') {
          results.push(
            ..._.map( // spread required to unpack and not push the whole array
              course.schedule.data[idx],
              meetingTime => {
                return {
                  meetingTime,
                  course
                }
              }
            )
          )
        }
      })
      return _.sortBy(results, 'meetingTime[0]')
    })
}

export { partitionCoursesByMeetingTime }

/* calculate duration given two strings of relative times, i.e.,
 * '8:00' and '10:00'.  Rounds up to the nearest 5 minutes */
function calcDuration (start, end) {
  if (!(start && end)) {
    return 0
  }
  var startPart = start.split(':')
  var endPart = end.split(':')

  var hours = endPart[0] - startPart[0]
  var mins = endPart[1] - startPart[1]

  /* round up to the nearest 5 minutes */
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

/* This routine returns an opaque (to the caller) descriptor of
 * courses in the schedule, to be passed into further calls to
 * courseConflictsWithSchedule().  Intended to minimize the
 * recalculations inherent in any sort of repeated checks on things
 * like the existing schedule or search results, etc.  */

function scheduleMakeDescriptor (courses) {
  var obj = _.partition(
    _.deepClone(
      _.map(
        _.filter(courses, c => c && c.id && c.schedule && c.schedule.type === 'simple'), // basic sanity check
        c => {
          return {
            cid: c.id,
            sch: c.schedule
          }
        }
      )
    ),
    'semester'
  )

  /* some more post-processing things here, expanding out non-simple
   * schedules, etc; for now, make a flag that indicates if all
   * courses are simple (they should be for now).  Since semester is
   * required, we're effectively partitioning and handling everything
   * in a semester-by-semester basis. */

  return _.mapValues(obj, _scheduleProcessOneSemester)
}

export { scheduleMakeDescriptor }

/* This internal routine will process a single semester, aggregating
 * all clist entries into a single list of lists per day.  We will
 * merge overlapping ranges (i.e., no checking) so there is the
 * minimum number of ranges per type, leaving a single array per day,
 * each made up of zero or more time entries.  In the future, we will
 * need to teach this routine about how to handle split schedules, but
 * for now we just assume they are simple.
 */

function _scheduleProcessOneSemester (clist) {
  return clist
}

/* (internal-only: no export) */

/* This routine return true if the given course would conflict with
 * the specific schedule descriptor.  We take a number of short-paths
 * here, so this is intended to be as fast as is reasonable possible.
 * In cases which are provably true or false we return as quickly as
 * possible.  This routine cannot and should not modify the "schedule"
 * object. */

function courseConflictsWithSchedule (course, schedule) {
  // short path 1: no conflicts if course's semester does not exist in
  // the schedule or if course is TBD
  if (!schedule[course.semester] || !courseCanSchedule(course)) {
    return false
  }
}

export { courseConflictsWithSchedule }

/* routine to consolidate checks for whether the give course can be scheduled */

function courseCanSchedule (course) {
  return course && course.schedule && course.schedule.type === 'simple' &&
    course.schedule.data && course.schedule.data.length
}

export { courseCanSchedule }
