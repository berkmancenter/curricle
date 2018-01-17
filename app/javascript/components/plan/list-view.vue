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
          <plan-list-item :lists="filteredCourses" :selected-plan="selectedPlan" :isMeetingBelongsToUser="isMeetingBelongsToUser" :getUserCourses="getUserCourses"/>
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
          <plan-description :course="course"/>
        </div>
      </div>
    </div>
  </div>
</template>

<script type="text/javascript">
import { mapState } from 'vuex'
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
        selectedView: 'viewmode',
      })
  },
  mounted () {
    const search_url = '/courses/user_courses'

    // this.course = this.resultSet
    // this.filteredCourses = this.resultSet

    // using Fall Courses
    // axios.get(search_url).then((response) => {
    //   this.courses = response.data
    //   this.filteredCourses = response.data
    // })

    // using User courses
    axios.get(search_url).then((response) => {
      this.courses = response.data.tray
      this.filteredCourses = response.data.tray
    })

    axios.get('/courses/categories').then((response) => {
      this.categories = response.data
    })

    this.getUserCourses()
  },
  data () {
    return {
      categories: [],
      filteredCourses: [],
      sideBarview: 'list-view',
      courses: {},
      course: {},
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
      let data = this.courses
      if (name == 'Semester') {
        data = this.filteredCourses
      }
      this.filteredCourses = data.filter(item => {
        return item[filter.name] == filter.value
      })
    },
    selectedPlan(course) {
      this.course = course
    },
    selectView (type) {
      this.$store.commit("app/CHOOSE_SIDEBAR_VIEW",type)
    },
    selectSideBarView(type){
      this.$store.commit("app/CHOOSE_SIDEBAR_VIEW",type)
    },
    getCoursesByDate(filter){
      if((filter != undefined) && (Object.keys(filter).length > 0)){
        this.events = {};
        const semester = filter.value.split(" ")
        _.forEach(this.user_courses.semester, (day, key) => {
          this.events[key] = day.filter((item) => {
            if (filter.name === 'term_name'){
              return item.term_name ==  semester[0] && item.term_year == semester[1]
            }
            else{
              return item[filter.name] == filter.value
            }
          })
        })
      }else{
        this.events = this.user_courses.semester
      }
    },

    getCoursesByYear(filter){
      if((filter != undefined) && (Object.keys(filter).length > 0)){
        this.yearlyEvents = {};
        const semester = filter.value.split(" ")
        _.forEach(this.user_courses.multi_year, (day, key) => {
          this.yearlyEvents[key] = day.filter((item) => {
            if (filter.name === 'term_name'){
              return item.term_name ==  semester[0] && item.term_year == semester[1]
            }
            else{
              return item[filter.name] == filter.value
            }
          })
        })
      }else{
        this.yearlyEvents = this.user_courses.multi_year
      }
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
