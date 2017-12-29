<template>
  <table class="course-list-iltem table">
    <thead></thead>
    <tbody>
      <tr v-for="course in courses">
        <td>{{ course.external_course_id }}</td>
        <td>{{ course.title }}</td>            
        <td style="border-right: 5px solid #000;"><i class= "fa fa-clock-o"></i></td>
      </tr>
    </tbody>
  </table>
</template>
<script type="text/javascript">
  export default {
    props: ['courses']
  }
</script>