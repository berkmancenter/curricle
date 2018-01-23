<template>
  <div>
    <div class="your-tray-parent">
      <p class="your-tray"> Your Tray
        <span class="fa fa-close"/>
      </p>
      <hr>
      <div class="row actions margin-none">
        <view-selector/>
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
import ViewSelector from 'components/tray/view-selector'
import CalendarSidebar from 'components/plan/calendar-sidebar'

export default {
  components: {
    CourseList,
    CalendarSidebar,
    ViewSelector
  },
  computed: {
    ...mapState('app', ['viewmode'])
  }
}
</script>

<style type="text/css">
  .sidebar{
    margin-top: 28px;
  }
</style>
