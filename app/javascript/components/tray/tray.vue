<template>
  <div>
    <div class="your-tray-parent clearfix">
      <p class="your-tray">Your Tray
        <font-awesome-icon
          class="pointer float-right"
          icon="times"
          @click="closeSidebar"
        />
      </p>
      <hr>
      <div class="actions mx-0">
        <view-selector/>
        <share-link/>
      </div>
    </div>

    <div class="mx-0">
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
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
import ViewSelector from 'components/shared/view-selector'
import MultiYearSidebar from 'components/tray/multi-year-sidebar'
import SemesterSidebar from 'components/tray/semester-sidebar'
import ShareLink from 'components/tray/TrayShareLink'

export default {
  components: {
    CourseList,
    FontAwesomeIcon,
    MultiYearSidebar,
    SemesterSidebar,
    ViewSelector,
    ShareLink
  },
  computed: {
    ...mapState('app', ['viewmode']),
    ...mapGetters('user', ['trayCourses'])
  },
  methods: {
    ...mapActions('app', ['closeSidebar'])
  }
}
</script>

<style scoped>
.pointer {
  cursor: pointer;
}
</style>
