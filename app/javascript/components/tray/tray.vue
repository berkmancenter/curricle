<template>
  <div>
    <div class="your-tray-parent">
      <p class="your-tray"> Your Tray
        <span class="fa fa-close"/>
      </p>
      <hr>
      <div class="row actions margin-none">
        <i
          class="fa fa-list-ul"
          @click="selectViewMode('list-view')"/>
        <i
          class="fa fa-calendar"
          @click="selectViewMode('semester')"/>
        <i
          class="fa fa-square"
          @click="selectViewMode('multi-year')"/>
        <div class="pull-right">See Course History</div>
      </div>
    </div>
    <div class="row margin-none">
      <calendar-sidebar
        v-if="viewmode=='semester' || viewmode=='multi-year'"
      />
      <course-list
        v-if="viewmode=='list-view'"
      />
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import CourseList from 'components/tray/list'
import CalendarSidebar from 'components/plan/calendar-sidebar'

export default {
  components: {
    CourseList,
    CalendarSidebar
  },
  computed: {
    ...mapState('app', ['viewmode'])
  },
  methods: {
    selectViewMode (view) {
      this.$store.commit('app/CHOOSE_SIDEBAR_VIEW', view)
    }
  }
}
</script>

<style type="text/css">
  .sidebar{
    margin-top: 28px;
  }
</style>
