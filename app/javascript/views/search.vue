<template>
  <div>
    <div class="row">
      <div class="col-md-8">
        <basic-search @keywordsUpdated="keywords = $event"/>
        <br>
        <curricle-search :keywords="keywords" :getResults="getResults"/>
      </div>
      <div class="col-md-4 sidebar" v-if="trayVisible">
        <div class=".your-tray-parent">
          <p class="your-tray">
            Your Tray
            <span class="fa fa-close">
            </span>
          </p>
          <hr>
          <div class="row actions margin-none">
            <i class="fa fa fa-list-ul" @click="selectSideBarView('single')"/>
            <i class="fa fa-calendar" @click="selectSideBarView('multiple')"/>
            <i class="fa fa-share-alt"/>
            <div class="pull-right"> See Course History</div>
          </div>
        </div>
        <div class="row margin-none">
          <plan-filter
            :title="category.name"
            :items="category.options"
            :field="category.field"
            v-for="category in categories"
            :selected-filter="selectedFilter"
            :name="category.name" 
          />
        </div>
        <div class="row margin-none">
          <course-list 
            :courses = "results"
            v-if="sideBarview=='single'"
          />
        </div>
        <div class="row margin-none">
          <calendar-sidebar 
            :calender_events="events_by_date",
            v-if="sideBarview=='multiple'")
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import BasicSearch from '../components/BasicSearch.vue'
import CurricleSearch from '../components/CurricleSearch.vue'
import CourseList from '../components/tray/list.vue'
import PlanFilter from '../components/plan/plan-filter.vue'
import CalendarSidebar from 'components/plan/calendar-sidebar'
import axios from 'axios'

export default {
  components: {
    BasicSearch,
    CurricleSearch,
    CourseList,
    PlanFilter
  },

  props: ['trayVisible', 'trayToggle'],

  mounted () {
    this.filterCategories()
    // this.getEventsByDate()
  },

  data () {
    return {
      keywords: [],
      sideBarview: '',
      results: [],
      categories: [],
      events: [
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

  methods: {
    selectSideBarView(view){
      this.sideBarview = view
    },

    getResults(results){
      this.results = results
    },

    // getEventsByDate(filter){
    //   let data = {}

    //   if(filter){
    //     const semester = filter.value.split(" ")
    //     data = {term_name: semester[0], term_year: semester[1]}
    //   }

    //   axios
    //     .get('/courses/courses_by_day', {data})
    //     .then((response) => {
    //       this.events = response.data
    //     })
    // },

    filterCategories(){
      axios.get('/courses/categories').then((response) => {
        this.categories = response.data
        .filter(item => item.name == 'Semester')
      })
    },

    selectedFilter (filter, name) {
      let data = this.results

      if (filter.value != 'none') {
        this.getEventsByDate(filter)
      }
    }
  }
}
</script>

<style type="text/css">
  .sidebar{
    margin-top: 28px;
  }
</style>
