<template >
  <div class="row margin-none">
    <div class="col-md-9">
      <div> <p class= "your-tray">Your Tray</p>
        <hr>
        <div class="drop-down actions">
          <i class="fa fa-list-ul" @click="selectView('list-view')"/>
          <i class="fa fa-calendar" @click="selectView('semester')"/>
          <i class="fa fa-square" @click="selectView('multi-year')"/>
          <plan-filter :title="category.name" :items="category.options" :field="category.field" v-for="category in categories" :selected-filter="selectedFilter" :name="category.name"/>
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
      <div> <p class ="select-course">Selected Course</p>
        <hr>
        <div class="row actions margin-none">
          <i class="fa fa-folder-open"/>
          <i class="fa fa-clock-o" />
          <i class="fa fa-share-alt" />
          <div class="pull-right"> See Course History</div>
        </div>
        <div class="row margin-none">
          <plan-description/>
        </div>
      </div>
    </div>
  </div>
</template>

<script type="text/javascript">
import { mapState, mapGetters } from 'vuex'
import Tray from 'components/tray/tray'
import PlanFilter from 'components/plan/plan-filter'
import PlanListItem from 'components/plan/list-item'
import PlanDescription from 'components/plan/plan-description'
import CalendarSidebar from 'components/plan/calendar-sidebar'
import CourseList from 'components/tray/list.vue'
import _ from 'lodash'
import axios from 'axios'

export default {
  components: {
    PlanFilter,
    PlanListItem,
    PlanDescription,
    CalendarSidebar,
    CourseList,
    Tray,
  },
  props: ['resultSet'],
  computed: {
    ...mapState('app',{
      trayVisible: 'trayVisible',
      selectedView: 'viewmode'
    }),
  },
  mounted () {
    this.$store.dispatch('user/getCourses')

    axios.get('/courses/categories').then((response) => {
      this.categories = response.data
    })

    this.getUserCourses()
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
    selectedFilter (filter, name) {
    },
    selectView (type) {
      this.$store.commit("app/CHOOSE_SIDEBAR_VIEW",type)
    },
    selectSideBarView(type){
      this.$store.commit("app/CHOOSE_SIDEBAR_VIEW",type)
    },
    getCoursesByDate(filter){
    },

    getCoursesByYear(filter){
    },
    filterData (filter) {
      if(this.sideBarview == 'semester'){
        this.getCoursesByDate(filter)
      }

      if(this.sideBarview == 'multi-year'){
        this.getCoursesByYear(filter)
      }

      if(this.sideBarview == 'list-view'){
        this.courses = this.user_courses.tray
        this.courses = this.courses.filter(item => {
          if (filter.name === 'term_name'){
            const semester = filter.value.split(" ")
            return item.term_name ==  semester[0] && item.term_year == semester[1]
          }
          else{
            return item[filter.name] == filter.value
          }
        })
      } 
    },
    isMeetingBelongsToUser(id){
      return this.userCoursesScheduleIds.includes(id)    
    },
    getUserCourses(){
      const course_url = '/courses/user_courses'
      axios
        .get(course_url)
        .then((response) => {
          this.user_courses = response.data
          this.courses = this.user_courses.tray
          this.results = this.user_courses.tray
          this.getCoursesByDate()
          this.getCoursesByYear()
          this.userCoursesScheduleIds = this.user_courses.tray.filter(item => !!item.user_schedule).map(item => { return item.user_schedule[0].course_meeting_pattern_id })
        })
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
