<template>
  <div>
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
            :item="item"
            :key="item.course_id"
            :scale="scale"
            :offset="item.day[2] - earliestIdx"
            :height="item.day[3]"
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
      scale: 80
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
      return Math.floor(earliest)
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
      return Math.ceil(latest + 1)
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
    this.setSemester(this.sortedSemestersInSchedule[0])
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
