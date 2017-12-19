<template>
  <div class="calendar-sidebar">
    <div v-for="event in calender_events">
      <strong>{{ event.day }}</strong>
      <b-list-group >
        <b-list-group-item v-for="course in event.courses" @click="selectItem(event)"> {{ course.external_id }} {{ course.title }}</b-list-group-item>
      </b-list-group>
    </div>  
  </div>    
</template>

<script type="text/javascript">
  export default {
    props: ['calender_events']
  }
</script>
