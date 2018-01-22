<template>
  <div class="row margin-none">
    <div class="col-md-9">
      <div> <p class= "your-tray">Your Tray</p>
        <hr>
        <div class="drop-down actions">
          <i class="fa fa-list-ul" @click="selectView('list-view')"/>
          <i class="fa fa-calendar" @click="selectView('semester')"/>
          <i class="fa fa-square" @click="selectView('multi-year')"/>
        </div>
      </div>
      <div v-for="(courses, year, index) in courses">
        <strong v-if="index == 0 || index == 1">{{ year }}</strong>
        <div class="yearly-calendar" v-if="index == 0 || index == 1">
          <div class="bannner">
            <div style="height: 300px;">
              <ul>
                <li v-for="event in courses" :style="{height: height(event)}" @click="selectedPlan(event)" v-if="event.meeting_with_tods && isMeetingBelongsToUser(event.meeting_with_tods.id)">
                  <div class="fc-title"/>
                  <p>{{ event.external_course_id }}</p>
                  <p>{{ event.title }}</p>
                  <p><b>{{ event.academic_group }}</b></p>
                  <p><b>{{ event.subject }}</b></p>
                </li>
              </ul>
            </div>
          </div>
          <div class="hr-breif">
            <div class="col100">
              <ul>
                <p/>
              </ul>
            </div>
            <div class="col100">
              <ul>
                <p>1hr</p>
              </ul>
            </div>
            <div class="col100">
              <ul>
                <p>2hr</p>
              </ul>
            </div>
            <div class="col100">
              <ul>
                <p>3hr</p>
              </ul>
            </div>
            <div class="col100">
              <ul>
                <p>4hr</p>
              </ul>
            </div>
            <div class="col100">
              <ul>
                <p>5hr</p>
              </ul>
            </div>
          </div>
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
import { mapState } from 'vuex'
import lodash from 'lodash'
import fullCalendar from 'fullcalendar'
import CalendarSidebar from 'components/plan/calendar-sidebar'
import PlanFilter from 'components/plan/plan-filter'
import SelectedCourse from 'components/plan/selected-course'
import Tray from 'components/tray/tray'
import moment from 'moment'
import axios from 'axios'
// var events_arr = [];

export default {
  components: {
    CalendarSidebar,
    PlanFilter,
    SelectedCourse,
    Tray
  },
  computed: {
    ...mapState('app', {
      trayVisible: 'trayVisible',
      selectedView: 'viewmode'
    })
  },
  data () {
    return {
      courses: [],
      event: [],
      categories: [],
      course: {},
      filteredCourses: [],
      sideBarview: 'multi-year',
      events: [],
      yearlyEvents: [],
      currentFilter: {},
      results: [],
      userCoursesScheduleIds: []
    }
  },
  mounted () {
    this.getUserCourses()
  },
  methods: {
    selectView (type) {
      this.$store.commit('app/CHOOSE_SIDEBAR_VIEW', type)
    },

    selectSideBarView (view) {
      this.sideBarview = view
      this.filterData(this.currentFilter)
    },

    filterCategories () {
      axios.get('/courses/categories').then((response) => {
        this.categories = response.data
          .filter(item => item.name == 'Semester')
      })
    },
    getCoursesByDate (filter) {
      // if((filter != undefined) && (Object.keys(filter).length > 0)){
      //   this.events = {};
      //   const semester = filter.value.split(" ")
      //   _.forEach(this.user_courses.semester, (day, key) => {
      //     this.events[key] = day.filter((item) => {
      //       if (filter.name === 'term_name'){
      //         return item.term_name ==  semester[0] && item.term_year == semester[1]
      //       }
      //       else{
      //         return item[filter.name] == filter.value
      //       }
      //     })
      //   })
      // }else{
      //   this.events = this.user_courses.semester
      // }
    },

    getCoursesByYear (filter) {
      // if((filter != undefined) && (Object.keys(filter).length > 0)){
      //   this.yearlyEvents = {};
      //   const semester = filter.value.split(" ")
      //   _.forEach(this.user_courses.multi_year, (day, key) => {
      //     this.yearlyEvents[key] = day.filter((item) => {
      //       if (filter.name === 'term_name'){
      //         return item.term_name ==  semester[0] && item.term_year == semester[1]
      //       }
      //       else{
      //         return item[filter.name] == filter.value
      //       }
      //     })
      //   })
      // }else{
      //   this.yearlyEvents = this.user_courses.multi_year
      // }
    },

    selectedPlan (course) {
      this.event = course
    },

    filterData (filter) {
      if (this.sideBarview == 'semester') {
        this.getCoursesByDate(filter)
      }

      if (this.sideBarview == 'multi-year') {
        this.getCoursesByYear(filter)
      }
    },
    height (course) {
      if (course && course.meeting_with_tods) {
        const start_time = moment(course.meeting_with_tods.meeting_time_start)
        const end_time = moment(course.meeting_with_tods.meeting_time_end)
        end_time.diff(start_time, 'hours') * 72 + 'px'
      } else {
        '100px'
      }
    },
    isMeetingBelongsToUser (id) {
      return this.userCoursesScheduleIds.includes(id)
    },
    getUserCourses () {
      const course_url = '/courses/user_courses'
      axios
        .get(course_url)
        .then((response) => {
          this.user_courses = response.data
          this.courses = this.user_courses.multi_year
          this.results = this.user_courses.tray
          this.filterCategories()
          this.getUserScheduleCourseByDate()
          this.getUserScheduleCourseByYear()
          this.userCoursesScheduleIds = this.user_courses.tray.filter(item => !!item.user_schedule).map(item => { return item.user_schedule[0].course_meeting_pattern_id })
        })
    },
    getUserScheduleCourseByDate () {
      this.events = {}
      _.forEach(this.user_courses.semester, (day, key) => {
        this.events[key] = day.filter(item =>
          !!item.user_schedule && !!item.user_schedule[0].course_meeting_pattern_id
        )
      })
    },
    getUserScheduleCourseByYear () {
      this.yearlyEvents = {}
      _.forEach(this.user_courses.multi_year, (day, key) => {
        this.yearlyEvents[key] = day.filter(item =>
          !!item.user_schedule && !!item.user_schedule[0].course_meeting_pattern_id
        )
      })
    }
  }
}
</script>
<style type="text/css">
  .yearly-calendar{width: 100%; display: table;}

  .yearly-view table, .yearly-view table tbody {
    display: inline-block;
    width: 100%;
  }
  .yearly-view table tbody tr {
    display: inline-table;
    width: 100%;
    height: 50px;
  }
  .col100{
    display: table;
    width: 100%;
    height: 70px;
  }
  .col100 ul{
    display: table;
    width: 100%;
    padding: 0px;
    margin: 0px;
    border-top: 1px solid #000;
  }
  .col100 ul li{
    display: table;
    width: calc(100% / 10 - 10px);
    float: left;
    border-top: 1px solid #000;
    margin-right: 10px;
  }

  .hr-breif{position: relative;}

  .bannner{
    position: absolute;
    height: 100%;
    left: 50px;
    z-index: 99;
  }
  .bannner ul{
    display: inline-block;
    width: 100%;
    height: 100%;
    padding: 0px;
    margin: 0px;
  }
  .bannner ul li{
    display: table;
    background: #dcdcdc;
    width: calc(100% / 10 - 20px);
    float: left;
    margin-right: 13px;
    width: 142px;
    font-size: 13px;
  }
  .bannner ul li p{
    margin-bottom: 5px;
    padding: 0 5px;
  }
  .bannner ul li p:nth-last-child(2), .bannner ul li p:nth-last-child(1){
    margin-bottom: 0px;
  }
  .bannner ul li:hover {
    background-color: #C0C0C0;
    cursor: pointer;
  }
</style>
