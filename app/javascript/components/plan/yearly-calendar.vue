<template>
  <div class="row margin-none">
    <div class="col-md-9">
      <div> <p class= "your-tray">Your Tray</p>
        <hr>
        <div class="drop-down actions">
          <i class="fa fa-list-ul" @click="selectView('list-view')"/>
          <i class="fa fa-calendar" @click="selectView('month-view')"/>
          <i class="fa fa-square" @click="selectView('year-view')"/>
        </div>
      </div>
      <div v-for="(courses, year, index) in courses">
        <strong v-if="index == 0 || index == 1">{{ year }}</strong>
        <div class="yearly-calendar" v-if="index == 0 || index == 1">
          <div class="bannner">
            <div style="height: 300px;">
              <ul>
                <li v-for="event in courses" v-bind:style="{height: height(event)}" @click="selectedPlan(event)" v-if="event.meeting && isMeetingBelongsToUser(event.meeting.id)">
                  <div class="fc-title"></div>
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
                <p> </p>
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
      <div class="your-tray-parent">
        <p class="your-tray"> Your Tray
          <span class="fa fa-close"></span>
        </p>
        <hr>
        <div class="row actions margin-none">
          <i class="fa fa-list-ul" @click="selectSideBarView('list-view')"/>
          <i class="fa fa-calendar" @click="selectSideBarView('semester')"/>
          <i class="fa fa-square" @click="selectSideBarView('multi-year')"/>
          <div class="pull-right">See Course History</div>
        </div>
      </div>
      <div class="row margin-none">
        <calendar-sidebar :calendarEvents="events" :getUserCourses="getUserCourses" :isMeetingBelongsToUser="isMeetingBelongsToUser" v-if="sideBarview=='semester'"></calendar-sidebar>
      </div>
      <div class="row margin-none">
        <calendar-sidebar :calendarEvents="yearlyEvents" :getUserCourses="getUserCourses" :isMeetingBelongsToUser="isMeetingBelongsToUser" v-if="sideBarview=='multi-year'"></calendar-sidebar>
      </div>
      <div class="row margin-none">
        <course-list :courses = "results" :getUserCourses="getUserCourses" :isMeetingBelongsToUser="isMeetingBelongsToUser" v-if="sideBarview=='list-view'"
        />
      </div>
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
          <plan-description :course="event"/>
        </div>
      </div>
    </div>
  </div>
</template>
<script type="text/javascript">
import lodash from 'lodash'
import fullCalendar from 'fullcalendar'
import CalendarSidebar from 'components/plan/calendar-sidebar'
import PlanFilter from 'components/plan/plan-filter'
import PlanDescription from 'components/plan/plan-description'
import CourseList from 'components/tray/list.vue'
import moment from 'moment'
import axios from 'axios'
// var events_arr = [];

export default {
  components: {
    CalendarSidebar,
    PlanFilter,
    PlanDescription,
    CourseList
  },
  props: ['selectedView', 'trayVisible'],
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
      this.selectedView(type)
    },

    selectSideBarView(view){
      this.sideBarview = view
      this.filterData(this.currentFilter)
    },

    filterCategories(){
      axios.get('/courses/categories').then((response) => {
        this.categories = response.data
        .filter(item => item.name == 'Semester')
      })
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

    selectedPlan (course) {
      this.event = course
    },

    filterData (filter) {
      if(this.sideBarview == 'semester'){
        this.getCoursesByDate(filter)
      }

      if(this.sideBarview == 'multi-year'){
        this.getCoursesByYear(filter)
      }
    },
    height(course){
      if(course && course.meeting){
        const start_time  = moment(course.meeting.meeting_time_start)
        const end_time  = moment(course.meeting.meeting_time_end)
        end_time.diff(start_time, 'hours') * 72 + 'px'
      }else{
        '100px'
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
        this.courses = this.user_courses.multi_year
        this.results = this.user_courses.tray
        this.filterCategories()
        this.getCoursesByDate()
        this.getCoursesByYear()
        this.userCoursesScheduleIds = this.user_courses.tray.filter(item => !!item.user_schedule).map(item => { return item.user_schedule[0].course_meeting_pattern_id })
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