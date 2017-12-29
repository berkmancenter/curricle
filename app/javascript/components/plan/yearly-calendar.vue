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
      <table class='yearly-view'>
        <thead>          
        </thead>
        <tbody style = "overflow-x: auto;">
          <tr style="border-top: 1px solid;">     
            <td style="width: 20px;"></td>       
            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>
            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>
          </tr>

          <tr>
            <td style="width: 100px;"><strong>1 hr</strong></td>   

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>

            <td style="width: 100px;">
              <div class="fc-content">
                <div class="fc-title"></div>
                <div class="event-description">long description <br> long description</div>
              </div>
            </td>
          </tr>


          <tr>
            <td><strong>2 hr</strong></td>
          </tr>
          <tr>
            <td><strong>3 hr</strong></td>
          </tr>
          <tr>
            <td><strong>4 hr</strong></td>
          </tr>
          <tr>
            <td><strong>5 hr</strong></td>
          </tr>
          <tr>
            <td><strong>5 hr</strong></td>
          </tr>
        </tbody>
      </table>
    </div>
    <div class="col-md-3" v-if="trayVisible">
      <div class="your-tray-parent">
        <p class="your-tray"> Your Tray <span class="fa fa-close"></span></p>          
        <hr>
        <div class="row actions margin-none">
          <i class="fa fa-folder" @click="selectSideBarView('single')"/>
          <i class="fa fa-clock-o" @click="selectSideBarView('multiple')"/>
          <div class="pull-right">See Course History</div>
        </div>
        <div class="row margin-none">
          <calendar-sidebar :calender_events="events_by_date" v-if="sideBarview=='single'"></calendar-sidebar>
        </div>  
        <div class="row margin-none">
          <plan-description :course="course", v-if="sideBarview=='multiple'"></plan-description>
        </div>  
      </div>
    </div>
  </div>
</template>
<script type="text/javascript">
  import CalendarSidebar from 'components/plan/calendar-sidebar'
  import PlanDescription from 'components/plan/plan-description'

  export default {
    components: {
      CalendarSidebar,
      PlanDescription
    },

    props: ['selectedView', 'trayVisible'],

    data(){
      return {
        sideBarview: 'single',
        events_by_date: [
          {
            day: 'Fall 2017',
            courses: [
              { external_id: '003121', title: 'Alquam laoreet lacus ut justo vestibulum'},
              { external_id: '003122', title: 'Alquam laoreet lacus ut justo vestibulum'},
              { external_id: '003123', title: 'Alquam laoreet lacus ut justo vestibulum'}
            ]
          },
          {
            day: 'Spring 2017',
            courses: [
              { external_id: '003121', title: 'Alquam laoreet lacus ut justo vestibulum'},
              { external_id: '003122', title: 'Alquam laoreet lacus ut justo vestibulum'},
              { external_id: '003123', title: 'Alquam laoreet lacus ut justo vestibulum'}
            ]
          },
          {
            day: 'Spring 2017',
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
      selectedFilter (filter, name) {
        let data = this.courses
        if (name == 'Semester') {
          data = this.filteredCourses
        }
        this.filteredCourses = data.filter(item => {
          return item[filter.name] == filter.value
        })
      },
      selectView (type) {
        this.selectedView(type)
      },
      selectSideBarView(view){
        this.sideBarview = view
      }
    }
  }   
</script>
<style type="text/css">
  .yearly-view tr{
    border-bottom: 1px solid;
  }
  .yearly-view table, .yearly-view table tbody {
    display: inline-block;
    width: 100%;
  }  
  .yearly-view table tbody tr {
    display: inline-table;
    width: 100%;
    height: 50px;
  }
</style>