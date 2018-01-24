<template>
  <div>
    <p>Semester View</p>
    <b-row>
      <b-col>
        <b-row>
          <b-col>
            Time
          </b-col>
        </b-row>
        <b-row>
          <b-col>
            <span
              v-for="(time,index) in times"
              :key="time"
              :style="{ display: 'block', position: 'absolute', top: index * scale + 'px', width: '600%', 'border-bottom': '2px solid black' }"
            >
              {{ time }}
            </span>
          </b-col>
        </b-row>
      </b-col>
      <b-col
        v-for="(day,index) in ['Monday','Tuesday','Wednesday','Thursday','Friday']"
        :key="index"
        class="day-column"
      >
        <b-row>
          <b-col>{{ day }}
          </b-col>
        </b-row>
        <b-row>
          <calendar-item
            v-for="item in currentScheduleByDay[index]"
            :item="item"
            :key="item.course_id"
            :scale="scale"
            :offset="earliestIdx"
          />
        </b-row>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'
import _ from 'lodash'

import CalendarItem from 'components/plan/calendar-item'

export default {
  components: {
    CalendarItem
  },
  data () {
    return {
      scale: 40
    }
  },
  computed: {
    ...mapState('plan', ['semester']),
    ...mapGetters('plan', ['sortedSemestersInSchedule', 'currentScheduleByDay']),
    earliestIdx () {
      var earliest = 24
      _.each(
        _.flatMap(
          _.filter(
            this.currentScheduleByDay,
            a => a !== undefined
          )
        ),
        k => { earliest = Math.min(earliest, k.day[2]) }
      )
      return Math.floor(earliest - 1)
    },
    latestIdx () {
      var latest = 0
      _.each(
        _.flatMap(
          _.filter(
            this.currentScheduleByDay,
            a => a !== undefined
          )
        ),
        k => { latest = Math.max(latest, k.day[2] + k.day[3]) }
      )
      return Math.ceil(latest)
    },
    times () {
      return ['1am', '2am', '3am', '4am', '5am', '6am', '7am', '8am', '9am', '10am', '11am', '12pm',
        '1pm', '2pm', '3pm', '4pm', '5pm', '6pm', '7pm', '8pm', '9pm', '10pm', '11pm', '12am' ]
        .slice(this.earliestIdx, this.latestIdx)
    }
  },
  watch: {
    sortedSemestersInSchedule () {
      this.setSemester(this.sortedSemestersInSchedule[0])
    }
  },
  mounted () {
    this.setSemester(this.sortedSemestersInSchedule[0])
  },
  methods: {
    ...mapActions('plan', ['setSemester'])
  }
}
</script>

<style>
.day-column {

}
</style>
