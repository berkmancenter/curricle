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
          i.fa.fa-folder(@click="selectSideBarView('single')")
          i.fa.fa-clock-o(@click="selectSideBarView('multiple')")

          .pull-right See Course History

      .row.margin-none
        calendar-sidebar(:calender_events="events_by_date", v-if="sideBarview=='single'")
      .row.margin-none
        plan-description(:course="course", v-if="sideBarview=='multiple'")
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
      sideBarview: 'single',
      events_by_date: [
        {
          day: 'Monday',
          courses: [
            { external_id: '003121', title: 'Alquam laoreet lacus ut justo vestibulum'},
            { external_id: '003122', title: 'Alquam laoreet lacus ut justo vestibulum'},
            { external_id: '003123', title: 'Alquam laoreet lacus ut justo vestibulum'}
          ]
        },
        {
          day: 'Tuesday',
          courses: [
            { external_id: '003121', title: 'Alquam laoreet lacus ut justo vestibulum'},
            { external_id: '003122', title: 'Alquam laoreet lacus ut justo vestibulum'},
            { external_id: '003123', title: 'Alquam laoreet lacus ut justo vestibulum'}
          ]
        },
        {
          day: 'Wednesday',
          courses: [
            { external_id: '003121', title: 'Alquam laoreet lacus ut justo vestibulum'},
            { external_id: '003122', title: 'Alquam laoreet lacus ut justo vestibulum'},
            { external_id: '003123', title: 'Alquam laoreet lacus ut justo vestibulum'}
          ]
        }
      ]
    }
  },
  mounted () {
    const course_url = '/courses/fullsearch?term=&keywords[0]=&keyword_options[0][]=title&keyword_options[0][]=description&keyword_weights[0]=47&monday_min=any&monday_max=any&tuesday_min=any&tuesday_max=any&wednesday_min=any&wednesday_max=any&thursday_min=any&thursday_max=any&friday_min=any&friday_max=any&school=all&department=all&subject=all&type=all&units_min=any&units_max=any'
    const category_url = '/courses/categories'

    axios
      .get(course_url)
      .then((response) => {
        this.courses = response.data
        this.getEventData(this.courses)
        this.course = this.courses[0]
        this.setEvent()
      })

    axios.get('/courses/categories').then((response) => {
      this.categories = response.data
        .filter(item => item.name == 'Semester')
    })  
  },
  methods: {
    selectView (type) {
      this.selectedView(type)
    },

    selectSideBarView(view){
      this.sideBarview = view
    },

    selectedFilter (filter, name) {
      this.removeEvents()

      let data = this.courses

      if (filter.value != 'none') {
        data = data.filter(item => {
          return item[filter.name] == filter.value
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
          element.find('.fc-title').after("<div class='event-description'>" + event.description + "</div>"); 
        },
        eventClick: function(calEvent, jsEvent, view) {
          calEvent.self.selectedPlan(calEvent.course)
        }
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
