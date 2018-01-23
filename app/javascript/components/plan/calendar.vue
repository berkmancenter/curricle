<template>
  <div class="row margin-none">
    <div class="col-md-9">
      <p class="your-tray">Your Tray</p>
      <hr>
      <div class="drop-down actions">
        <view-selector/>
        <plan-filter
          :title="category.name"
          :items="category.options"
          :field="category.field"
          v-for="category in categories"
          :key="category.name"
          :name="category.name">
          Filter By :
        </plan-filter>
      </div>
      <div class="full-calendar"/>
      <div class="full-calendar1"/>
    </div>
    <div
      class="col-md-3"
      v-if="trayVisible">
      <tray/>
    </div>
    <div
      class="col-md-3"
      v-else>
      <selected-course/>
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters } from 'vuex'
import PlanFilter from 'components/plan/plan-filter'
import SelectedCourse from 'components/plan/selected-course'
import ViewSelector from 'components/tray/view-selector'
import Tray from 'components/tray/tray'

export default {
  components: {
    PlanFilter,
    SelectedCourse,
    ViewSelector,
    Tray
  },
  computed: {
    ...mapState('app', ['trayVisible']),
    ...mapState('plan', ['filters']),
    ...mapGetters('user', ['coursesByYear', 'coursesByDate']),
    ...mapGetters('plan', ['filteredCourses', 'departmentsInTray', 'semestersInTray', 'eventData']),
    categories () {
      var filters = this.filters
      return [
        { name: 'semesters', title: 'Semester', options: this.semestersInTray, field: filters.semester },
        { name: 'department', title: 'Department', options: this.departmentsInTray, field: filters.department }
      ]
    }
  },
  watch: {
    eventData () {
      this.$store.dispatch('plan/populateEvents')
    }
  },
  mounted () {
    this.$store.dispatch('plan/setEvent')
  }
}
</script>

<style>
  .fc-event, .fc-event-dot {
    background-color: inherit !important;
    border: none !important;
  }

  .fc-slats table tbody tr {
    height: 60px;
  }

  .fc-title {
    color: #fff;
    background-color: #000;
    height: 10px;
  }
  .fc-title .black{
    color: #fff;
    background-color: #000;
    height: 10px;
  }
  .fc-title .red{
    color: #fff;
    background-color: #ff0000;
    height: 10px;
  }
  .fc-title .green{
    color: #fff;
    background-color: #008000;
    height: 10px;
  }
  .fc-title .purple{
    color: #fff;
    background-color: #800080;
    height: 10px;
  }

  .full-calendar table tbody tr td, .full-calendar table thead tr th {
    border: none !important;
    border-bottom: 1px solid gray !important;
  }
  .your-tray {
    color: #000;
    font-weight: bold;
    margin-bottom: 0px;
  }
  .col {
    padding: 0px;
  }
  .fc-head tr td, .fc-row.fc-widget-header{
    border: none;
  }
  .fc-toolbar.fc-header-toolbar {
    display: none;
  }
  .event-description .green{
    background-color: #cecece;
    color: #000;
  }
  .event-description {
    background: #EFEFEF;
    padding: 0 5px;
    padding-bottom: 10px;
  }
  .event-description:hover {
    background: #C4C4C4;
    cursor: pointer;
  }
  .event-description p {
    margin-bottom: 5px;
  }
  .event-description p:nth-last-child(2), .event-description p:nth-last-child(1) {
    margin-bottom: 0;
  }
  a.fc-time-grid-event.fc-v-event.fc-event.fc-start.fc-end {
    border-radius: 0;
  }
</style>
