<template>
  <div>
    <b-row v-if="coursesTBD && coursesTBD.length">
      <b-col style="height: 150px;">
        <b-row>
          <b-col class="md-1">
            <strong>Schedule TDB:</strong>
          </b-col>
        </b-row>
        <b-row>
          <b-col
            v-for="course in coursesTBD"
            :key="course.id">
            <calendar-item
              :item="course"
              :scale="scale"
              :offset="0"
              :height="1"
            />
          </b-col>
        </b-row>
      </b-col>
    </b-row>
    <b-row>
      <b-col>
        <b-row>
          <b-col class="header">
            Time
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <span
              v-for="(time,index) in times"
              :key="time"
              :style="{ display: 'block', position: 'absolute', top: index * scale + 'px', width: '575%', 'border-top': '1px solid lightgray' }"
            >
              {{ time }}
            </span>
          </b-col>
        </b-row>
      </b-col>
      <b-col
        v-for="(day,index) in ['Mon','Tue','Wed','Thu','Fri']"
        :key="index"
        class="day-column"
      >
        <b-row>
          <b-col class="header">{{ day }}
          </b-col>
        </b-row>
        <b-row>
          <calendar-item
            v-for="item in currentScheduleByDay[index]"
            :item="item.course"
            :key="item.course.id"
            :scale="scale"
            :offset="item.meetingTime[0] - earliestIdx"
            :height="item.meetingTime[1]"
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

import CalendarItem from 'components/plan/calendar-item'

export default {
  components: {
    CalendarItem
  },
  data () {
    return {
      scale: 80
    }
  },
  computed: {
    ...mapState('plan', ['semester']),
    ...mapGetters('plan', ['sortedSemestersInSchedule', 'scheduledCourses']),
    courses () {
      return _.filter(this.scheduledCourses, { semester: this.semester })
    },
    currentScheduleByDay () {
      return [
        this.coursesByMeetingTime.Monday,
        this.coursesByMeetingTime.Tuesday,
        this.coursesByMeetingTime.Wednesday,
        this.coursesByMeetingTime.Thursday,
        this.coursesByMeetingTime.Friday
      ]
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
          this.currentScheduleByDay,
          days => Math.min(
            ..._.map(days, day => day.meetingTime[0])
          )
        )
      ))
    },
    latestIdx () {
      return Math.ceil(1 + Math.max(
        0,
        ..._.map(
          this.currentScheduleByDay,
          days => Math.max(
            ..._.map(days, day => day.meetingTime[0] + day.meetingTime[1])
          )
        )
      ))
    },
    times () {
      return ['1am', '2am', '3am', '4am', '5am', '6am', '7am', '8am', '9am', '10am', '11am', '12pm',
        '1pm', '2pm', '3pm', '4pm', '5pm', '6pm', '7pm', '8pm', '9pm', '10pm', '11pm', '12am' ]
        .slice(this.earliestIdx, this.latestIdx)
    }
  },
  watch: {
    sortedSemestersInSchedule () {
      if (!this.sortedSemestersInSchedule.includes(this.semester)) {
        this.setSemester(this.sortedSemestersInSchedule[0])
      }
    }
  },
  mounted () {
    if (this.sortedSemestersInSchedule && !this.sortedSemestersInSchedule.includes(this.semester)) {
      this.setSemester(this.sortedSemestersInSchedule[0])
    }
  },
  methods: {
    ...mapActions('plan', ['setSemester'])
  }
}
</script>

<style scoped>
.day-column {

}

.header {
    font-weight: bold;
    text-align: left;
}
</style>
