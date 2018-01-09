<template lang="pug">
  .row.margin-none
    .col-md-9      
      p.your-tray Your Tray
      hr
      .drop-down.actions
        i.fa.fa-list-ul(@click="selectView('list-view')")
        i.fa.fa-calendar(@click="selectView('month-view')")
        i.fa.fa-square(@click="selectView('year-view')")
        plan-filter(:title="category.name" :items="category.options" :field="category.field" v-for="category in categories" :selected-filter="selectedFilter" :name="category.name") Filter By :
      .full-calendar
      .full-calendar1
    .col-md-3(v-if="trayVisible")
      .your-tray-parent
        p.your-tray Your Tray 
          span.fa.fa-close
        hr
        .row.actions.margin-none
          i.fa.fa-list-ul(@click="selectSideBarView('list-view')")
          i.fa.fa-calendar(@click="selectSideBarView('semester')")
          i.fa.fa-square(@click="selectSideBarView('multi-year')")
          .pull-right See Course History

      .row.margin-none
        calendar-sidebar(:calenderEvents="events", v-if="sideBarview=='semester'")
      .row.margin-none
        calendar-sidebar(:calenderEvents="yearlyEvents", v-if="sideBarview=='multi-year'")  
      .row.margin-none
        plan-description(:course="course", v-if="sideBarview=='list-view'")
</template>

<script type="text/javascript">
  import lodash from 'lodash'
  import fullCalendar from 'fullcalendar'
  import CalendarSidebar from 'components/plan/calendar-sidebar'
  import PlanFilter from 'components/plan/plan-filter'
  import PlanDescription from 'components/plan/plan-description'
  import axios from 'axios'
  import _ from 'lodash'
  // var events_arr = [];

  export default {
    components: {
      CalendarSidebar,
      PlanFilter,
      PlanDescription
    },
    props: ['selectedView', 'trayVisible'],
    data () {
      return {
        user_courses: [],
        courses: [],
        events_arr: [],
        categories: [],
        course: {},
        filteredCourses: [],
        sideBarview: 'list-view',
        events: [],
        yearlyEvents: [],
        currentFilter: {}
      }
    },
    mounted () {
      const course_url = '/courses/user_courses'
      const category_url = '/courses/categories'

      axios
        .get(course_url)
        .then((response) => {
          this.user_courses = response.data
          this.courses = this.user_courses.tray
          this.getEventData(this.courses)
          this.setEvent()
          this.filterCategories()
          this.getCoursesByDate()
          this.getCoursesByYear()
        })
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

      selectedFilter (filter, name) {
        this.currentFilter = filter
        this.removeEvents()
        if (filter.value != 'none') {
          this.filterData(this.currentFilter)
        }
        this.getEventData(this.courses)
        this.addEvents()
      },

      getEventData(data){
        this.events_arr = data
          .filter(item => !!item.meeting)
          .map(item => {
            return { 
              title  : " ",
              start  : item.meeting.meeting_time_start,
              end    : item.meeting.meeting_time_end,
              description: item.subject_description,
              course : item,
              self   : this
            }
          })
      },

      setEvent () {
        $('.full-calendar').fullCalendar({
          defaultView: 'agendaWeek',
          allDaySlot: false,
          displayEventTime: false,
          slotDuration: '00:60:00',
          columnFormat: 'ddd',
          weekends: false,
          events: this.events_arr,
          eventRender: function(event, element) { 
            console.log(event, 'event')
            element.find('.fc-title').after("<div class='event-description'>" + "<p>" + event.course.external_course_id   + "</p>" + "<p>" + event.description + "</p>" + "<p>" + "<b>" + event.course.academic_group + "</b>" + "</p>"+ "<p>" + "<b>" + event.course.subject + "</b>" + "</p>" + "</div>"); 
          },
          eventClick: function(calEvent, jsEvent, view) {
            calEvent.self.selectedPlan(calEvent.course)
          }
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

      removeEvents(){
        $('.full-calendar').fullCalendar('clientEvents').map(function(event) {
          $('.full-calendar').fullCalendar('removeEvents', event._id);
        });
      },

      addEvents(){
        this.events_arr.map(function(event){
          $('.full-calendar').fullCalendar('renderEvent', event)
        });
      },

      selectedPlan (course) {
        this.course = course
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
      }
    }
  }
</script>
<style>
  .fc-event, .fc-event-dot {
    background-color: inherit !important;
    border: none !important;
  }

  .fc-slats table tbody tr {
    height: 60px;
  }

  .fc-title {    
    color: #fff;
    background-color: #000;
    height: 10px;    
  }
  .fc-title .black{    
    color: #fff;
    background-color: #000;
    height: 10px;    
  }
  .fc-title .red{    
    color: #fff;
    background-color: #ff0000;
    height: 10px;    
  }
  .fc-title .green{    
    color: #fff;
    background-color: #008000;
    height: 10px;    
  }
  .fc-title .purple{    
    color: #fff;
    background-color: #800080;
    height: 10px;    
  }
  
  .full-calendar table tbody tr td, .full-calendar table thead tr th {
    border: none !important;
    border-bottom: 1px solid gray !important;
  }
  .your-tray {
    color: #000;
    font-weight: bold;
    margin-bottom: 0px;
  }
  .col {
    padding: 0px;
  }
  .fc-head tr td, .fc-row.fc-widget-header{
    border: none;
  }
  .fc-toolbar.fc-header-toolbar {
    display: none;
  }
  .event-description .green{
    background-color: #cecece;
    color: #000;
  }
  .event-description {
    background: #EFEFEF;
    padding: 0 5px;
    padding-bottom: 10px;
  }
  .event-description:hover {
    background: #C4C4C4;
    cursor: pointer;
  }
  .event-description p {
    margin-bottom: 5px;
  }
  .event-description p:nth-last-child(2), .event-description p:nth-last-child(1) {
    margin-bottom: 0;
  }
  a.fc-time-grid-event.fc-v-event.fc-event.fc-start.fc-end {
    border-radius: 0;
  }
</style>
