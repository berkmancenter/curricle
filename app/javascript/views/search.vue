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
            <i class="fa fa-list-ul" @click="selectSideBarView('list-view')"/>
            <i class="fa fa-calendar" @click="selectSideBarView('semester')"/>
            <i class="fa fa-square" @click="selectSideBarView('multi-year')"/>
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
            :courses = "filteredResults"
            v-if="sideBarview=='list-view'"
          />
        </div>
        <div class="row margin-none">
          <calendar-sidebar 
            :calenderEvents="events"
            v-if="sideBarview=='semester'"
          />
        </div>
        <div class="row margin-none">
          <calendar-sidebar 
            :calenderEvents="yearlyEvents"
            v-if="sideBarview=='multi-year'"
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
    PlanFilter,
    CalendarSidebar
  },

  props: ['trayVisible', 'trayToggle'],

  mounted () {
    this.filterCategories()
    this.getCoursesByDate()
    this.getCoursesByYear()
  },

  data () {
    return {
      keywords: [],
      sideBarview: 'list-view',
      results: [],
      filteredResults: [],
      categories: [],
      events: [],
      yearlyEvents: [],
      currentFilter: {}
    }
  },

  methods: {
    selectSideBarView(view){
      this.sideBarview = view
      this.filterData(this.currentFilter)
    },

    getResults(results){
      this.results = results
      this.filteredResults = results
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

      if(filter){
        const semester = filter.value.split(" ")
        url = url + '?term_name=' + semester[0] + '&term_year=' + semester[1]
      }

      axios
        .get(url)
        .then((response) => {
          this.yearlyEvents = response.data
        })
    },

    filterCategories(){
      axios.get('/courses/categories').then((response) => {
        this.categories = response.data
        .filter(item => item.name == 'Semester')
      })
    },

    selectedFilter (filter, name) {
      let data = this.results
      this.currentFilter = filter

      if (filter.value != 'none') {
        this.filterData(filter)
      }
    },

    filterInListView (filter) {
      this.filteredResults = this.results
      this.filteredResults = this.results.filter(item => {
        if (filter.name === 'term_name'){
          const semester = filter.value.split(" ")
          return item.term_name ==  semester[0] && item.term_year == semester[1]
        }
        else{
          return item[filter.name] == filter.value
        }
      })
    },

    filterData (filter) {
      if(this.sideBarview == 'semester'){
        this.getCoursesByDate(filter)
      }

      if(this.sideBarview == 'list-view'){
        this.filterInListView(filter)
      }

      if(this.sideBarview == 'multi-year'){
        this.getCoursesByYear(filter)
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
