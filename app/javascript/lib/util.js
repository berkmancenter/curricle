/* This module is intended for pure JS-related utility functions; no
 * vuex stuff, no state-related management, no
 * side-effects. Everything here should be optionally exported so
 * individual components can pull in the pieces they need. Try to keep
 * this organized by section and export the individual functions by
 * group. */

import _ from 'lodash'
import SemesterWeeks from 'lib/semester-weeks.json'

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
          calcDuration(pat.meeting_time_start_tod, pat.meeting_time_end_tod),
          c.id
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
  var ret = {}

  // populate the list of course ids in this semester
  ret.courses = {}
  _.each(clist, c => { ret.courses[c.cid] = c.cid })

  // split the input into simple/split types
  var [simple, split] = _.partition(clist, c => c.sch.type === 'simple')

  var simpleWeeks = _mergeDaysMultiple(_.map(simple, 'sch.data'))

  if (!split.length) {
    ret.type = 'simple'
    ret.data = simpleWeeks
  } else {
    console.error('no full support for split weeks')
    // merge all of the weeks currently in use by the other split schedules
    var weekStore = {}

    _(split)
      .each(c => {
        _.each(
          c.sch.data,
          (days, week) => {
            if (!weekStore[week]) {
              weekStore[week] = []
            }
            weekStore[week].push([days, c.id]) // stash the days and the courseid
          }
        )
      }
      )
  }

  return ret
}

/* (internal-only: no export) */

/* combine a list of courses with individual schedules into one larger
 * schedule structure.  This routine will ensure the merged structures
 * are sorted per day, plus stash the course id for the course in
 * question as the 2'th offset of the resulting array
 *
 * Essentially, this turns a 4-dimensionsal array into a 3-dimensional one, so:
 *
 * [[[[start, duration, course]]]] -> [[[start, duration, course]]]
 *
 * with the first level of the array being the offest schedule by day
 * 0..6 for Monday..Sunday, the second level being the sorted list of
 * events by day, and the third being the individual event data. */

/* takes days1 array to add the events from days2; sorts the
 * days events in question and returns the result */

function _mergeDayArrays (days1, days2) {
  if (!(days2 && days2.length)) {
    return days1
  }
  return _(days1)
    .zip(days2)
    .map(([di, df]) => {
      return _([...(di || [])])
        .concat(df || [])
        .filter(_.isArray)
        .sortBy('[0]')
        .value()
    })
    .value()
}

/* takes days1 array to add the events from days2; does not sort, as
 * this is used for reduce(), and we'll sort 'em after all are added.
 */

function _mergeDayArraysNosort (days1, days2) {
  // console.log('_mergeDatArraysNosort', days1, days2)
  if (!(days2 && days2.length)) {
    return days1
  }
  return _(days1)
    .zip(days2)
    .map(([di, df]) => {
      return _([...(di || [])])
        .concat(df || [])
        .filter(_.isArray)
        .value()
    })
    .value()
}

function _mergeDaysMultiple (daysArray) {
  if (daysArray.length <= 1) {
    return daysArray[0] || []
  }
  if (daysArray.length === 2) {
    return _mergeDayArrays(...daysArray)
  }
  var ret = _.reduce(daysArray, _mergeDayArraysNosort, [])
  // items will be merged but unsorted, so sort now...
  return _.map(ret, e => _.sortBy(e, '[0]'))
}

/* This routine will add a new course to an existing schedule object
 * incrementally, to prevent the need to rebuild the entire schedule
 * object when adding a single course. */

function scheduleAddCourse (schedule, course) {
  if (!courseCanSchedule(course)) {
    // do we want to add to the TBD list instead of skipping?
    return false
  }
  if (!schedule[course.semester]) {
    // take advantage of the fact that a course.schedule struct is the
    // same as an individual schedule; will inherit type and data from there
    schedule[course.semester] = _.cloneDeep(course.schedule)
    schedule[course.semester].courses = {}
    schedule[course.semester].courses[course.id] = course.id
    return true
  }
  var semSemester = schedule[course.semester]
  if (semSemester.type === 'simple' &&
      course.schedule.type === 'simple') {
    semSemester.data = _mergeDayArrays(semSemester.data, course.schedule.data)
    if (!semSemester.courses) {
      semSemester.courses = {}
    }
    semSemester.courses[course.id] = course.id
    return true
  }
  console.error('scheduleAddCourse: unknown type combo')
  return false
}

export { scheduleAddCourse }

/* This routine return true if the given course would conflict with
 * the specific schedule descriptor.  We take a number of short-paths
 * here, so this is intended to be as fast as is reasonable possible.
 * In cases which are provably true or false we return as quickly as
 * possible.  This routine cannot and should not modify the "schedule"
 * object. */

function courseConflictsWithSchedule (course, schedule) {
  // short path 1: no conflicts if course's semester does not exist in
  // the schedule or if course is TBD
  if (!(schedule && course && schedule[course.semester] && courseCanSchedule(course))) {
    // console.log('short path for aborting with no conflicts', course, schedule)
    return false
  }
  var semSchedule = schedule[course.semester]
  if (semSchedule.courses && semSchedule.courses[course.id]) {
    // course is already in the schedule; can't conflict with itself
    return false
  }
  if (course.schedule.type === 'simple' && semSchedule.type === 'simple') {
    // easy path; compare conflict
    return _simpleScheduleOverlaps(course.schedule.data, semSchedule.data)
  } else {
    /* we only care about weeks which are in common for complex cases;
     * we can't conflict on weeks which are disjoint, so look at the
     * intersecting weeks only. */

    var semester = course.semester

    var weeks = _.intersection(
      _getWeekRange(course.schedule, semester),
      _getWeekRange(semSchedule, semester)
    )
    /* could probably improve things here as well by also using
     * existing "template" weeks for any simple schedule and first
     * checking explicitly the split weeks instead of always using the
     * expanded weeks for all. */

    return _(weeks)
      .some(
        w => _simpleScheduleOverlaps(
          _getWeeklySchedule(course.schedule, w),
          _getWeeklySchedule(semSchedule, w)
        )
      )
  }
}

export { courseConflictsWithSchedule }

/* This routine return an array of booleans, one per day, to indicate
 * which days this course has conflicts on.  Because this has to
 * iterate over all days, there is no short-circuiting possible.  This
 * function can return less than the total number of days, in which
 * case the caller should assume that there is no conflict for any
 * non-represented day.  This routine cannot and should not modify the
 * "schedule" object. */

function courseConflictsWithScheduleByDay (course, schedule) {
  // short path 1: no conflicts if course's semester does not exist in
  // the schedule or if course is TBD
  if (!(schedule && course && schedule[course.semester] && courseCanSchedule(course))) {
    // console.log('short path for aborting with no conflicts', course, schedule)
    return []
  }
  var semSchedule = schedule[course.semester]
  if (semSchedule.courses && semSchedule.courses[course.id]) {
    // course is already in the schedule; can't conflict with itself
    return []
  }
  if (course.schedule.type === 'simple' && semSchedule.type === 'simple') {
    // easy path; compare conflict
    return _simpleScheduleOverlapsByDay(course.schedule.data, semSchedule.data)
  } else {
    console.error('Error: other types not implemented')

    /*
    var semester = course.semester

    var weeks = _.intersection(
      _getWeekRange(course.schedule, semester),
      _getWeekRange(semSchedule, semester)
    )

    return _(weeks)
      .some(
        w => _simpleScheduleOverlaps(
          _getWeeklySchedule(course.schedule, w),
          _getWeeklySchedule(semSchedule, w)
        )
      ) */
  }
}

export { courseConflictsWithScheduleByDay }

/* routine to consolidate validity checks for whether the give course can be scheduled */

function courseCanSchedule (course) {
  return course && course.schedule && course.schedule.type === 'simple' &&
    course.schedule.data && course.schedule.data.length
}

export { courseCanSchedule }

/* Returns an object of arrays of any course ids with conflicts in the
 * current schedule object, indexed by semester.  If no conflicts returns
 * an empty array for the semester in question.  By necessity, there will
 * always be at least two courses returned for a conflict, or there would
 * be no conflict.  */

function scheduleCurrentConflicts (schedule) {
  return _.mapValues(schedule, _semesterScheduleCurrentConflicts)
}

export { scheduleCurrentConflicts }

function _semesterScheduleCurrentConflicts (semesterSchedule) {
  return []
}

/* internal only, no export */

/* Returns an array of weeks for this specific course, to be used to
 * iterate over the weekly schedules available.  It is the
 * responsibility of the schedule parser to ensure that the weeks in a
 * particular semesters are returned the same way for any/all courses
 * mapped in this way.  Format of weeks are YYYY-MM-DD, each week
 * starting on the earliest Monday.  Scheduled weeks are assumed to be
 * an entire week in duration.  */

function _getWeekRange (obj, semester) {
  // we need to ensure that simple courses return valid week ranges here
  if (obj.type === 'split') {
    return _.keys(obj.data)
  }
  if (obj.type === 'simple') {
    return _calculateWeeksInSemester(semester)
  }
  console.error('Unknown object type', obj, semester)
}

function courseGetWeekRange (course) {
  return _getWeekRange(course.schedule, course.semester)
}

export { courseGetWeekRange }

/* Returns the schedule for the course for the given week.  It is
 * assumed that the "week" param is returned by the courseGetWeekRange
 * function. */

function _getWeeklySchedule (obj, week) {
  if (obj.type === 'simple') {
    return obj.data
  }
  if (obj.type === 'split') {
    // currently assuming it's all split or all simple; might move to
    // mixed for efficiency in representation
    return obj.data[week]
  }
  console.error('Unknown schedule type')
}

function courseGetWeeklySchedule (course, week) {
  return _getWeeklySchedule(course.schedule, week)
}

export { courseGetWeeklySchedule }

/* Returns the official list of weeks for a specific semester that we can iterate through */

function _calculateWeeksInSemester (semester) {
  return SemesterWeeks[semester]
}

/* routine to compare if two simple schedules overlap; returns bool
 * if so; will short-circuit on first issues encountered */

function _simpleScheduleOverlaps (sched1, sched2) {
  // sched1, sched2 are arrays of array (or undefined)
  return _.some(
    _.zip(sched1, sched2),
    _overlapOneDay
  )
}

/* routine to return the set of days for which two simple schedules
 * overlap; returns true for every day for which this holds.  Cannot
 * short circuit, can return less than a full array, in which case the
 * caller can assume there is no overlap for any remaining days */

function _simpleScheduleOverlapsByDay (sched1, sched2) {
  // sched1, sched2 are arrays of array (or undefined)
  return _.map(
    _.zip(sched1, sched2),
    _overlapOneDay
  )
}

/* common helper function for both _simpleScheduleOverlapsByDay and _simpleScheduleOverlaps */

function _overlapOneDay ([s1, s2]) {
  if (!(s1 && s2 && s1.length && s2.length)) {
    // if any of the days are missing then we know there's no conflict here
    return false
  } else {
    /* s1, s2 are sorted lists of day schedules, so we can iterate
     * over the lowest indexes of each until we run into a
     * conflict, then return true in that case */

    /* alternately, and easier to code (though less efficient),
     * concatenate and sort the array by start time and abort
     * early if we run into any overlapping pieces.  As a
     * side-consequence, this will detect any overlaps in the
     * source data itself. */

    var end = 0 // state var to track the highest time we've encountered

    return _(s1)
      .concat(s2) // concatenate the two arrays and then sort by first index
      .sortBy('[0]')
      .findIndex(e => {
        var ret = e[0] < end // it's a conflict if the start time is before highest end time
        end = e[0] + e[1] // calculate new end time
        return ret // if this is true then we short-circuit
      }) !== -1
  }
}

/* routines to serialize/deserialize search object state from a URL.
 * This might get ugly... */

function deserializeSearch (route) {
  var obj = {}
  var p = route.params[0]

  /* first pull the semester range to search the catalog */
  var s = /^(Spring|Summer|Fall)(\d+)(?:-(Spring|Summer|Fall)(\d+))?\/(.*)/.exec(p)

  /* minimum requirements for continuing */
  if (s[1] && s[2]) {
    obj.searchTermStart = s[1]
    obj.searchYearStart = s[2]
    obj.searchTermUseRange = !!s[4]
    obj.searchTermEnd = s[3]
    obj.searchYearEnd = s[4]

    p = s[5]

    var tokens = {}
    /* gather keywords */
    _.each(
      p.split('/'),
      e => {
        if (e) {
          var res = /^([a-z]):(.*)/.exec(e)
          var [ , type, rest ] = res
          if (type) {
            if (!tokens[type]) { tokens[type] = [] }
            tokens[type].push(rest)
          }
        }
      }
    )

    /* handle keywords */
    if (tokens.k) {
      var kw = []
      _.each(
        tokens.k,
        k => {
          // format is type, optional weight, colon, encoded search term
          var res = /^([atdirc]+)(\d*):(.*)$/.exec(k)
          if (res) {
            var [ , types, weight, term ] = res
            kw.push({ applyTo: searchTypes(types), weight, text: decodeURI(term) })
          }
        }
      )
      obj.keywords = kw
    }

    /* handle sort by */
    if (tokens.s && tokens.s.length === 1) {
      obj.sortBy = tokens.s[0]
    }

    /* handle time ranges */
    if (tokens.r && tokens.r.length === 1) {
      var ranges = []
      _.each(
        tokens.r[0].split(':'),
        r => {
          // format is either empty (i.e., disabled) or \d+-\d+
          var res = /^(\d+)-(\d+)$/.exec(r)
          if (res) {
            ranges.push([res[1], res[2]])
          } else {
            ranges.push(undefined)
          }
        }
      )
      obj.timeRanges = ranges
    }
  } else {
    console.error('couldn\'t parse catalog range')
  }
  return obj
}

function searchTypes (str) {
  // special-case:
  if (str === 'a') {
    str = 'tdirc'
  }
  const lkup = {
    t: 'TITLE',
    d: 'DESCRIPTION',
    i: 'INSTRUCTOR',
    r: 'READINGS',
    c: 'COURSE_ID'
  }
  var types =
      _(str.split(''))
        .uniq()
        .sort()
        .value()
  return _(lkup).pick(types).values().value()
}

export {deserializeSearch}

function serializeSearch (obj) {
  // TODO: sanity-checks?

  var cat = obj.searchTermStart + obj.searchYearStart
  if (obj.searchTermUseRange) {
    cat += '-' + obj.searchTermEnd + obj.searchYearEnd
  }

  var elems = {}

  /* keywords */
  if (obj.keywords) {
    elems.k = _.map(
      obj.keywords,
      ({text, applyTo, weight}) => applyToString(applyTo) + weight + ':' + encodeURI(text)
    )
  }

  /* sortBy */
  if (obj.sortBy) {
    elems.s = [obj.sortBy]
  }

  /* time ranges */
  if (obj.timeRanges) {
    elems.r = [_.at(obj.timeRanges, ['Mon', 'Tue', 'Wed', 'Thu', 'Fri']).map(a => a ? a[0] + '-' + a[1] : '').join(':')]
  }

  var rest = []
  _.each(
    elems,
    (v, k) => _.each(v, e => rest.push(k + ':' + e))
  )
  return [cat, ...rest].join('/')
}

function applyToString (arr) {
  var str =
      _(arr)
        .map(e => e.charAt(0).toLowerCase())
        .uniq()
        .filter(/^[tdlir]/)
        .join('')
  // since Readings is disabled we have a special-case category here
  if (str.length === 4 + (str.match(/r/) ? 1 : 0)) {
    str = 'a'
  }
  return str
}

export {serializeSearch}
