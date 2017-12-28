<template >
  <div class="row margin-none">
    <div class="col-md-9">
      <div> <p class= "your-tray">Your Tray</p>
        <hr>
        <div class="drop-down actions">
          <i class="fa fa-list-ul" @click="selectView('list-view')"/>
          <i class="fa fa-calendar" @click="selectView('month-view')"/>
          <i class="fa fa-square" @click="selectView('year-view')"/>
          <plan-filter :title="category.name" :items="category.options" :field="category.field" v-for="category in categories" :selected-filter="selectedFilter" :name="category.name"/>
        </div>
        <div class="plan">
          <plan-list-item :lists="filteredCourses" :selected-plan="selectedPlan"/>
        </div>
      </div>
    </div>
    <div class="col-md-3" v-if="trayVisible">
      <div> <p class ="select-course">Selected Course</p>
        <hr>
        <div class="row actions margin-none">
          <i class="fa fa-folder-open" @click="selectView('list-view')"/>
          <i class="fa fa-clock-o" @click="selectView('month-view')"/>
          <i class="fa fa-share-alt" @click="selectView('year-view')"/>
          <div class="pull-right"> See Course History</div>
        </div>
        <div class="row margin-none">
          <plan-description :course="course"/>
        </div>
      </div>
    </div>
  </div>
</template>

<script type="text/javascript">
import PlanFilter from 'components/plan/plan-filter'
import PlanListItem from 'components/plan/list-item'
import PlanDescription from 'components/plan/plan-description'
import axios from 'axios'

export default {
  components: {
    PlanFilter,
    PlanListItem,
    PlanDescription,
  },
  props: ['selectedView', 'trayVisible'],

  mounted () {
    axios.get('/courses/search').then((response) => {
      this.courses = response.data
      this.filteredCourses = response.data
    })

    axios.get('/courses/categories').then((response) => {
      this.categories = response.data
    })
  },
  data () {
    return {
      categories: [],
      filteredCourses: [],
      courses: {},
      course: {},
      planView: 'list-view',
      sideBarToggle: false
    }
  },
  methods: {
    selectedFilter (filter, name) {
      let data = this.courses
      if (name == 'Semester') {
        data = this.filteredCourses
      }
      this.filteredCourses = data.filter(item => {
        return item[filter.name] == filter.value
      })
    },
    selectedPlan(course) {
      this.course = course
    },
    selectView (type) {
      this.selectedView(type)
    }
  }
}
</script>
<style type="text/css">
  .navbar-light .navbar-nav .nav-link {
    color: #000 !important;
  }
  .your-tray, .select-course {
    color: #000;
    font-weight: bold;
    margin-bottom: 0px;
  }
  .actions .fa-calendar, .actions .fa-square {
    color: gray;
  }
  .dropdown button, .dropdown button:hover, .dropdown button:focus {
    background-color: inherit;
    color: #000;
    border: none;
  }
  .btn-secondary:not([disabled]):not(.disabled):active, .btn-secondary:not([disabled]):not(.disabled).active, .show > .btn-secondary.dropdown-toggle {
    background-color: inherit !important;
    color: #000 !important;
    border: none !important; 
    box-shadow: inherit !important;
  }
  hr {
    border-color: #000 !important;
    border-width: 2px !important;
    margin-top: 0px !important; 
  }
</style>