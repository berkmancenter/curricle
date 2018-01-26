<template>
  <div>
    <div
      v-for="(courses, year, index) in courses"
      :key="year">
      <strong v-if="index === 0 || index === 1">{{ year }}</strong>
      <div
        class="yearly-calendar"
        v-if="index === 0 || index === 1">
        <div class="bannner">
          <div style="height: 300px;">
            <ul>
              <li
                v-for="event in courses"
                :key="event.id"
                :style="{height: height(event)}"
                @click="selectCourse(event)"
                v-if="event.meeting_with_tods && isMeetingBelongsToUser(event.meeting_with_tods.id)">
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
</template>

<script>
import { mapGetters, mapActions } from 'vuex'
import CalendarSidebar from 'components/plan/calendar-sidebar'
import PlanFilter from 'components/plan/plan-filter'
import SelectedCourse from 'components/shared/SelectedCourse'
import ViewSelector from 'components/tray/view-selector'
import Tray from 'components/tray/tray'
import axios from 'axios'

export default {
  components: {
    CalendarSidebar,
    PlanFilter,
    SelectedCourse,
    ViewSelector,
    Tray
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
      results: []
    }
  },
  computed: {
    ...mapGetters('user', ['trayCourses', 'userCoursesScheduleIds'])
  },
  methods: {
    ...mapActions('user', ['selectCourse']),
    filterCategories () {
      axios.get('/courses/categories').then((response) => {
        this.categories = response.data
          .filter(item => item.name === 'Semester')
      })
    },

    height (course) {
      return '100px'
    },
    isMeetingBelongsToUser (id) {
      return this.userCoursesScheduleIds.includes(id)
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
