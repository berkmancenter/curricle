<template lang="pug">
  .row.margin-none
    .col-md-9      
      p.your-tray Your Tray
      hr
      .drop-down.actions
        i.fa.fa-list-ul(@click="selectView('list-view')")
        i.fa.fa-calendar(@click="selectView('month-view')")
        i.fa.fa-square(@click="selectView('month-view')")
      .full-calendar
    .col-md-3
      .your-tray-parent
        p.your-tray Your Tray 
          span.fa.fa-close
        hr
        .row.actions.margin-none
          i.fa.fa-folder
          i.fa.fa-clock-o
          i.fa.fa-share-alt

          .pull-right See Course History

      .row.margin-none
        calendar-sidebar(:calender_events="events_by_date")
</template>

<script type="text/javascript">
import lodash from 'lodash'
import fullCalendar from 'fullcalendar'
import CalendarSidebar from 'components/plan/calendar-sidebar'
import axios from 'axios'
// var events_arr = [];

export default {
  components: {
    CalendarSidebar
  },
  props: ['selectedView'],
  data () {
    return {
      courses: [],
      events_arr: [],
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
        const courses = response.data
        this.events_arr = courses
          .filter(item => !!item.meeting)
          .map(item => {
            return { title: (item.external_course_id + item.course_description + item.academic_group + item.subject), start: item.meeting.meeting_time_start, end: item.meeting.meeting_time_end, description: course.subject_description }
          })
        this.setEvent()
      })
  },
  methods: {
    selectView (type) {
      this.selectedView(type)
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
        } 
      })
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
