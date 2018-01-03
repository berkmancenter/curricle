<template>
  <div class="row margin-none">
    <div class="col-md-9">
      <div> <p class= "your-tray">Your Tray</p>
        <hr>
        <div class="drop-down actions">
          <i class="fa fa-list-ul" @click="selectView('list-view')"/>
          <i class="fa fa-calendar" @click="selectView('month-view')"/>
          <i class="fa fa-square" @click="selectView('year-view')"/>
        </div>
      </div>
      <strong>Fall 2017</strong>
      <div class="yearly-calendar" >
        <div class="bannner">
          <div style="height: 300px;">
            <ul>
              <li v-for="event in courses" v-bind:style="{height: height()}" @click="selectedPlan(course)">
                <div class="fc-title"></div>
                <p>
                  {{ event.external_id }} <br>
                  {{ event.title }}
                </p>
              </li>
            </ul>
          </div>
        </div> 
        <div class="hr-breif">    
          <div class="col100">
            <ul>
              <p> </p>
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
      <strong>Fall 2016</strong>
      <div class="yearly-calendar" >
        <div class="bannner">
          <div style="height: 300px;">
            <ul>
              <li v-for="event in courses" style="height: 300px;" @click="selectedPlan(course)">
                <div class="fc-title"></div>
                <p>
                  {{ event.external_id }} <br>
                  {{ event.title }}
                </p>
              </li>
            </ul>
          </div>
        </div> 
        <div class="hr-breif">    
          <div class="col100">
            <ul>
              <p> </p>
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
    <div class="col-md-3" v-if="trayVisible">
      <div class="your-tray-parent">
        <p class="your-tray"> Your Tray
          <span class="fa fa-close"></span>
        </p>
        <hr>
        <div class="row actions margin-none">
          <i class="fa fa-list-ul" @click="selectSideBarView('list-view')"/>
          <i class="fa fa-calendar" @click="selectSideBarView('semester')"/>
          <i class="fa fa-square" @click="selectSideBarView('multi-year')"/>
          <div class="pull-right">See Course History</div>
        </div>
      </div>
      <div class="row margin-none">
        <calendar-sidebar :calenderEvents="events" v-if="sideBarview=='semester'"></calendar-sidebar>
      </div>
      <div class="row margin-none">
        <calendar-sidebar :calenderEvents="yearlyEvents" v-if="sideBarview=='multi-year'"></calendar-sidebar>
      </div>
      <div class="row margin-none">
        <plan-description :course="event" v-if="sideBarview=='list-view'"></plan-description>
      </div>  
    </div>
  </div>
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
      event: [],
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
      })

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
          // this.courses = response.data
          this.yearlyEvents = response.data
        })
    },
    selectedPlan (course) {
      this.event = course
    },

    filterData (filter) {
      if(this.sideBarview == 'semester'){
        this.getCoursesByDate(filter)
      }

      if(this.sideBarview == 'multi-year'){
        this.getCoursesByYear(filter)
      }
    },
    height(){
      Math.floor(Math.random() * 2)
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
    text-align: center;
  }
  .bannner ul li:hover {
    background-color: #C0C0C0;
    cursor: pointer;
  }
</style>