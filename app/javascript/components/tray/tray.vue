<template>
  <div>
    <div class="your-tray-parent">
      <p class="your-tray">Your Tray
        <span
          class="fa fa-close pull-right"
          @click="closeSidebar"
        />
      </p>
      <hr>
      <div class="actions mx-0">
        <view-selector/>
        <p class="share pull-right text-right">
          Share
          <font-awesome-icon icon="share" />
        </p>
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
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
import CourseList from 'components/shared/course-list'
import ViewSelector from 'components/shared/view-selector'
import MultiYearSidebar from 'components/tray/multi-year-sidebar'
import SemesterSidebar from 'components/tray/semester-sidebar'

export default {
  components: {
    CourseList,
    FontAwesomeIcon,
    MultiYearSidebar,
    SemesterSidebar,
    ViewSelector
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
.fa.fa-close {
  padding-right: 0.5em;
}

.fa.fa-close:hover {
  color: gray;
}

p.share {
  font-size: 13px;
  font-weight: bold;
}
</style>
