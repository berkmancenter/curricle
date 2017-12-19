<template>
  <div class="table-responsive">          
    <table class="course-list-iltem table">
      <thead>        
      </thead>
      <tbody>
        <tr v-for="list in lists" @click="selectItem(list)">
          <td>{{list.external_course_id}}</td>
          <td>{{list.course_description}}</td>
          <td>{{list.academic_group}} <br> {{ list.subject }}</td>
          <td>{{list.term_name}} <br> {{list.units_maximum}} units</td>
          <td>{{list.course_description_long}}</td>
          <td style="border-right: 8px solid #660000; position: relative;">USA </td>
          <span><input type= "checkbox" name ="" value= ""/></span>         
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script type="text/javascript">
  export default {
    props: ['selectedPlan', 'lists'],
    methods: {
      selectItem: function (value) {
        this.selectedPlan(value)
      }
    }  
  }
</script>

<style type="text/css">
  .course-list-iltem tbody tr{
    background: #DCDCDC;
    font-size: 10px;
  }
  .course-list-iltem tbody tr:hover {
    background: gray;
  }
  .course-list-iltem tbody tr {
    margin-bottom: 5px;
    display: table;
    width: 100%;
  }
  .course-list-iltem thead {
    display: table-caption;
    width: 100%;
  }
  .course-list-iltem tbody tr span {
    display: inline-block;
    margin-top: 14px;
    position: absolute;
    right: 0px;
  }
  .course-list-iltem tbody tr {
    vertical-align: middle;
  }
</style>

