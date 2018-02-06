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

/* format a float as a pretty time; example: 8.5 for 8:30; only shows minutes if not a whole number */
function prettyTime (time) {
  // hours or fraction of hours

  var hours = Math.floor(time)
  var mins = Math.ceil(60 * (time - hours))
  var isPm = hours >= 12
  var ret = hours > 12 ? hours - 12 : hours

  if (mins) {
    ret += ':' + mins
  }

  ret += isPm ? 'pm' : 'am'

  return ret
}

export { prettyTime }

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

/* ============================================================ *

Some notes about the data structure in use for the schedule detection
code:

The basic data structure mirrors largely the data structure used for
an individual course, which has two basic cases:

- "simple" -- all courses here meet at the same time or times per week.

- "split" -- at least one of the courses has a split schedule; i.e.,
  the course meets at different times depending on the week.

When a schedule is "simple", we just treat the schedule as a list of
lists, with the individual offset being the day number, followed by
zero or more three-element arrays for the start time, course duration,
and course id.  These are given as floats relative to eastern time.
The 0'th day is Monday, 1st Tueday, etc, with 5 and 6 being the
relatively infrequent Saturday and Sunday courses.  (Full support is
not yet here for Saturday and Sunday, to be fleshed out after MVP.)

An example structure is here:

[
  [                             // Monday's schedule
    [8, 1.5, 12345],            // course 12345 meets at 8 AM for 1.5 hour
    [9.5, 2.5, 54321],          // course 54321 meets at 9:30 AM for 2.5 hour
    [15.5, 2, 56789]            // course 56789 meets at 3:30 PM for 2 hours
  ],
  undefined,                    // no courses on Tuesday
  [                             // Wednesday; much like Monday but meets at different times
    [8, 1.5, 12345],            // course 12345 meets at 8 AM for 1.5 hour
    [11.5, 2.5, 54321],         // course 54321 meets at 11:30 AM for 2.5 hour
    [15.5, 2, 56789]            // course 56789 meets at 3:30 PM for 2 hours
  ]
]                               // no Thursday or Friday, coasting!

This structure makes up the bones of the schedule, and most routines
that expect to operate on schedules will deal with something along
these lines.  Of note, days can be missing or contain empty arrays, so
anything processing these should be expecting this.  Each day's
individual events should be sorted by start time.  We assume that
events are exclusive of end time and inclusive of start time, so if
two events are back-to-back there is no conflict (though it'd be hard
to teleport between locations, so practically speaking we might want
some sort of padding here).

This structure is only a single week, however; in the split schedule
case, we need a way to generate the given schedule for a particular
week and return this basic structure.  Since the vast majority of
courses are simple, we don't need the overhead of calculating each
week when these will be duplicated *until* we hit a course with the
split schedule.

At a high level, conflicts are tested to see if there are any overlaps
between a course's schedule and the user's existing schedule.  If
either the course or the schedule has "split" courses we need to check
for conflicts on a week-by-week basis, otherwise we can just check for
conflicts on the template week.  The first time we add a split course
to a schedule, we transform the template week into a series of weeks
which make up the semester.  Once converted, we will not attempt to
unconvert, even if we remove the offending split course from the
schedule.

Since these can be potentially costly checks, particularly when
checking multiple courses at the same time (think search results) we
calculate things once and reuse this data structure against these
standard routines so checks should at least be faster.  We also make
it possible to incrementally update this schedule object when
adding/removing schedule items.

Events are always distinct by semester, so we end up treating the
schedule as an object mapping semesters into the schedule-related data
structures.  Most external routines are wrappers which map to internal
routines which assume the individual list of courses are already
vetted to belong to the same semester.

* ============================================================ */

/* this routine returns an opaque (to the caller) descriptor of
 * courses in the schedule, to be passed into further calls to
 * courseConflictsWithSchedule().  Intended to minimize the
 * recalculations inherent in any sort of repeated checks on things
 * like the existing schedule or search results, etc.  */

function scheduleMakeDescriptor (courses) {
  return _(courses)
    .filter(courseCanSchedule)
    .map(c => { return { semester: c.semester, cid: c.id, sch: c.schedule } })
    .groupBy('semester')
    .mapValues(_scheduleProcessOneSemester)
    .value()
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

/* routine to consolidate validity checks for whether the give course can be scheduled */

function courseCanSchedule (course) {
  return course && course.schedule && course.schedule.type === 'simple' &&
    course.schedule.data && course.schedule.data.length
}

export { courseCanSchedule }
