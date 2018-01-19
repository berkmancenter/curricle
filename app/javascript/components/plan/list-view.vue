<template >
  <div class="row margin-none">
    <div class="col-md-9">
      <div> <p class= "your-tray">Your Tray</p>
        <hr>
        <div class="drop-down actions">
          <i class="fa fa-list-ul" @click="selectView('list-view')"/>
          <i class="fa fa-calendar" @click="selectView('semester')"/>
          <i class="fa fa-square" @click="selectView('multi-year')"/>
          <plan-filter
            :title="category.name"
            :items="category.options"
            :field="category.field"
            v-for="category in categories"
            :name="category.name"
            :key="category.id"
          />
        </div>
        <div class="plan">
          <plan-list-item/>
        </div>
      </div>
    </div>
    <div class="col-md-3" v-if="trayVisible">
      <tray/>
    </div>
    <div class="col-md-3" v-else>
      <selected-course/>
    </div>
  </div>
</template>

<script type="text/javascript">
import { mapState, mapGetters } from 'vuex'
import Tray from 'components/tray/tray'
import PlanFilter from 'components/plan/plan-filter'
import PlanListItem from 'components/plan/list-item'
import SelectedCourse from 'components/plan/selected-course'
import CourseList from 'components/tray/list.vue'
import _ from 'lodash'
import axios from 'axios'

export default {
  components: {
    PlanFilter,
    PlanListItem,
    SelectedCourse,
    CourseList,
    Tray
  },
  computed: {
    ...mapState('app', {
      trayVisible: 'trayVisible',
      selectedView: 'viewmode'
    })
  },
  mounted () {
    this.$store.dispatch('user/getCourses')

    axios.get('/courses/categories').then((response) => {
      this.categories = response.data
    })
  },
  data () {
    return {
      categories: [],
      sideBarview: 'list-view',
      courses: {},
      events: [],
      results: [],
      yearlyEvents: [],
      planView: 'list-view',
      sideBarToggle: false,
      user_courses: [],
      userCoursesScheduleIds: []
    }
  },
  methods: {
    selectView (type) {
      this.$store.commit('app/CHOOSE_SIDEBAR_VIEW', type)
    },
    selectSideBarView (type) {
      this.$store.commit('app/CHOOSE_SIDEBAR_VIEW', type)
    }
  }
}
</script>
<style type="text/css">
  #app header .navbar-light .navbar-nav a {
    color: #000;
  }
  .your-tray, .select-course {
    color: #000;
    font-weight: bold;
    margin-bottom: 0px;
  }
  .actions .fa-calendar, .actions .fa-square {
    color: gray;
  }
  .dropdown button, .dropdown button:hover, .dropdown button:focus {
    background-color: inherit;
    color: #000;
    border: none;
  }
  .btn-secondary:not([disabled]):not(.disabled):active, .btn-secondary:not([disabled]):not(.disabled).active, .show > .btn-secondary.dropdown-toggle {
    background-color: inherit !important;
    color: #000 !important;
    border: none !important;
    box-shadow: inherit !important;
  }
  hr {
    border-color: #000 !important;
    border-width: 2px !important;
    margin-top: 0px !important;
  }
</style>
