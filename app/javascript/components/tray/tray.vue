<template>
  <div>
    <div class="your-tray-parent">
      <p class="your-tray"> Your Tray
        <span
          class="fa fa-close"
          @click="hideTray"
        />
      </p>
      <hr>
      <div class="row actions margin-none">
        <view-selector/>
        <div class="pull-right">See Course History</div>
      </div>
    </div>
    <div class="row margin-none">
      <semester-sidebar
        v-if="viewmode.tray=='semester'"
      />
      <multi-year-sidebar
        v-if="viewmode.tray=='multi-year'"
      />
      <course-list
        v-if="viewmode.tray=='list-view'"
        :courses="trayCourses"
      />
    </div>
  </div>
</template>

<script>
import { mapState, mapGetters, mapActions } from 'vuex'
import CourseList from 'components/shared/course-list'
import ViewSelector from 'components/shared/view-selector'
import MultiYearSidebar from 'components/tray/multi-year-sidebar'
import SemesterSidebar from 'components/tray/semester-sidebar'

export default {
  components: {
    CourseList,
    MultiYearSidebar,
    SemesterSidebar,
    ViewSelector
  },
  computed: {
    ...mapState('app', ['viewmode']),
    ...mapGetters('user', ['trayCourses'])
  },
  methods: {
    ...mapActions('app', ['hideTray'])
  }
}
</script>

<style type="text/css">
  .sidebar{
    margin-top: 28px;
  }
</style>
