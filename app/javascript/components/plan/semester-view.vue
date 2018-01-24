<template>
  <div>
    <p>Semester View</p>
    <b-row>
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
            :scale="30"
          />
        </b-row>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'

import CalendarItem from 'components/plan/calendar-item'

export default {
  components: {
    CalendarItem
  },
  computed: {
    ...mapState('plan', ['semester']),
    ...mapGetters('plan', ['scheduledCoursesBySemester', 'sortedSemestersInSchedule', 'currentSchedule', 'currentScheduleByDay'])
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
