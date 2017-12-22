<template lang="pug">
  .row.margin-none
    .col-md-8
      .col
        p Your Tray
        hr
      .drop-down.actions
        i.fa.fa-list-ul(@click="selectView('list-view')")
        i.fa.fa-calendar(@click="selectView('month-view')")
        i.fa.fa-square(@click="selectView('month-view')")
      .full-calendar
    .col-md-4
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
            return { title: (item.external_course_id + item.course_description + item.academic_group + item.subject), start: item.meeting.meeting_time_start, end: item.meeting.meeting_time_end }
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
        columnFormat: 'dddd',
        events: this.events_arr
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

  .fc-title{
    background: blue;
    color: #fff;
  }
  
  .full-calendar table tbody tr td, .full-calendar table thead tr th {
    border: none !important;
    border-bottom: 1px solid gray !important;
  }
</style>
