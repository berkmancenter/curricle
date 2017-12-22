<template >
  <div class="row margin-none">
    <div class="col-md-8">
      <div class="col"> Your Tray
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
    <div class="col-md-4">
      <div class="col"> Selected Course
        <hr>
        <div class="row actions margin-none">
          <i class="fa fa-list-ul" @click="selectView('list-view')"/>
          <i class="fa fa-calendar" @click="selectView('month-view')"/>
          <i class="fa fa-square" @click="selectView('year-view')"/>
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
    PlanDescription
  },
  props: ['selectedView'],
  mounted () {
    axios.get('/courses/search').then((response) => {
      this.courses = response.data
      this.filteredCourses = response.data
      this.course = this.courses[0]
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
      planView: 'list-view'
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
    selectedPlan (course) {
      course['instructor'] = 'first name'
      this.course = course
    },
    selectView (type) {
      this.selectedView(type)
    }
  }
}
</script>
