<template>
  <div>
    <semester-selector
      mode="state"
      source="schedule"
    />

    <b-row v-show="coursesTBD && coursesTBD.length">
      <b-col style="height: 150px;">
        <b-row>
          <b-col class="md-1 font-weight-bold text-uppercase">
            Schedule TBD:
          </b-col>
        </b-row>
        <b-row>
          <b-col
            v-for="course in coursesTBD"
            :key="course.id"
          >
            <calendar-item
              :item="course"
              :scale="scale"
              :offset="0"
              :height="1"
              :nudge="-65"
              :provisional="provisionalCourseIds.includes(course.id)"
              :selected="currentCourse && currentCourse.id == course.id"
              :hidden="!courseIdInSchedule(course.id)"
            />
          </b-col>
        </b-row>
      </b-col>
    </b-row>
    <b-row v-show="hasCourses">
      <b-col>
        <b-row class="header-row">
          <b-col class="header">
            &nbsp;
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <span
              v-for="(time,index) in times"
              :key="time"
              :style="{ display: 'block', position: 'absolute', top: index * scale + 'px', width: '575%', 'border-top': '1px solid lightgray' }"
              class="time-label"
            >
              {{ time }}
            </span>
          </b-col>
        </b-row>
      </b-col>
      <b-col
        v-for="(day,index) in daylist"
        :key="index"
        class="day-column"
      >
        <b-row>
          <b-col class="header">
            {{ day }}
          </b-col>
        </b-row>
        <b-row>
          <calendar-item
            v-for="item in currentTrayByDay[index]"
            :key="item.course.id"
            :item="item.course"
            :scale="scale"
            :offset="item.meetingTime[0] - earliestIdx"
            :height="item.meetingTime[1]"
            :provisional="provisionalCourseIds.includes(item.course.id)"
            :selected="currentCourse && currentCourse.id == item.course.id"
            :conflicted="item.course.id in scheduledCourseConflictsByDay"
            :conflict-info="courseConflictInfoForDay(item.course.id, day)"
            :hidden="!courseIdInSchedule(item.course.id)"
          />
        </b-row>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'
import _ from 'lodash'
import { partitionCoursesByMeetingTime } from 'lib/util'
import CalendarItem from 'components/plan/CalendarItem'
import SemesterSelector from 'components/plan/SemesterSelector'

export default {
  components: {
    CalendarItem,
    SemesterSelector
  },
  data () {
    return {
      daylist: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
    }
  },
  computed: {
    ...mapGetters('app', ['currentCourse']),
    ...mapState('plan', ['semester', 'provisionalCourses']),
    ...mapGetters('plan', ['sortedSemestersInTray', 'trayCourses', 'scheduledCourseConflictsByDay', 'courseConflictInfoForDay']),
    ...mapGetters('user', ['courseIdInSchedule']),
    courses () {
      return _.uniqBy(
        _.filter(
          _.concat(this.trayCourses, _.values(this.provisionalCourses)),
          { semester: this.semester }
        ),
        'id'
      )
    },
    scale () {
      return (this.latestIdx - this.earliestIdx) > 7 ? 50 : 80
    },
    // Determine if there are any courses with meeting times in the user's schedule
    hasCourses () {
      const coursesByDay = _.at(this.coursesByMeetingTime, this.daylist)

      return !!_.find(coursesByDay, 'length')
    },
    currentTrayByDay () {
      return _.at(this.coursesByMeetingTime, this.daylist)
    },
    coursesTBD () {
      return this.coursesByMeetingTime.TBD
    },
    coursesByMeetingTime () {
      return partitionCoursesByMeetingTime(this.courses)
    },
    earliestIdx () {
      return Math.floor(Math.min(
        24,
        ..._.map(
          this.currentTrayByDay,
          days => Math.min(
            ..._.map(days, 'meetingTime[0]')
          )
        )
      ))
    },
    latestIdx () {
      return Math.ceil(1 + Math.max(
        0,
        ..._.map(
          this.currentTrayByDay,
          days => Math.max(
            ..._.map(days, day => day.meetingTime[0] + day.meetingTime[1])
          )
        )
      ))
    },
    times () {
      return ['00:00', '01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '12:00',
        '01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '12:00' ]
        .slice(this.earliestIdx, this.latestIdx)
    },
    provisionalCourseIds () {
      /* exclude ids in case there are already scheduled ones */
      return _.without(
        _.keys(this.provisionalCourses),
        _.map(this.trayCourses, 'id')
      )
    }
  },
  mounted () {
    if (this.sortedSemestersInTray && !this.sortedSemestersInTray.includes(this.semester)) {
      this.setSemester(this.sortedSemestersInTray[0])
    }
  },
  methods: {
    ...mapActions('plan', ['setSemester'])
  }
}
</script>

<style lang="scss" scoped>
.header-row {
  margin-bottom: 40px;
}

.header {
  font-weight: bold;
  text-align: left;
  text-transform: uppercase;
}

.time-label {
  font-size: 12px;
  font-family: 'IBM Plex Mono', sans-serif;
}
</style>
