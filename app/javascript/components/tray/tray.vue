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
      <div class="row actions mx-0">
        <view-selector/>
        <div class="pull-right">See Course History</div>
      </div>
    </div>
    <div class="row mx-0">
      <semester-sidebar
        v-show="viewmode.tray=='semester'"
      />
      <multi-year-sidebar
        v-show="viewmode.tray=='multi-year'"
      />
      <course-list
        v-show="viewmode.tray=='list-view'"
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
