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
    const course_url = '/courses/fullsearch?term=Fall_2017&keywords[0]=&keyword_options[0][]=title&keyword_options[0][]=description&keyword_weights[0]=47&monday_min=any&monday_max=any&tuesday_min=any&tuesday_max=any&wednesday_min=any&wednesday_max=any&thursday_min=any&thursday_max=any&friday_min=any&friday_max=any&school=all&department=all&subject=all&type=all&units_min=any&units_max=any'
    const category_url = '/courses/categories'

    axios
      .get(course_url)
      .then((response) => {
        this.courses = response.data
        this.getEventData(response.data)
        this.setEvent()
      })

    this.filterCategories()
    this.getCoursesByDate()
    this.getCoursesByYear()

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
      this.course = {}

      let data = this.courses

      if (filter.value != 'none') {
        this.filterData(filter)
        data = data.filter(item => {
          if (filter.name === 'term_name'){
            const semester = filter.value.split(" ")
            return item.term_name ==  semester[0] && item.term_year == semester[1]
          }
          else{
            return item[filter.name] == filter.value
          }
        })
      }
      this.getEventData(data)
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
        events: this.events_arr,
        eventRender: function(event, element) { 
          element.find('.fc-title').after("<div class='event-description'>" + event.description + "</div>" + "<div class='event-description'>" + event.academic_group + "</div>" + "<div class='event-description'>" + event.subject + "</div>"); 
        },
        eventClick: function(calEvent, jsEvent, view) {
          calEvent.self.selectedPlan(calEvent.course)
        }
      })
    },

    getCoursesByDate(filter){
      let url = '/courses/courses_by_day'
      if((filter != undefined) && (Object.keys(filter).length > 0)){
        const semester = filter.value.split(" ")
        url = url + '?term_name=' + semester[0] + '&term_year=' + semester[1]
      }

      axios
        .get(url)
        .then((response) => {
          this.events = response.data
        })
    },

    getCoursesByYear(filter){
      let url = '/courses/courses_by_year'

      if((filter != undefined) && (Object.keys(filter).length > 0)){
        const semester = filter.value.split(" ")
        url = url + '?term_name=' + semester[0] + '&term_year=' + semester[1]
      }

      axios
        .get(url)
        .then((response) => {
          this.yearlyEvents = response.data
        })
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
</style>
