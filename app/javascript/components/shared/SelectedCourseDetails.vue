<template >
  <div class="description">
    <div class="row margin-none mx-0">
      <p class="pull-left"><b>{{ course.academic_group }}</b></p>
      <p class="pull-right">Component: <span><b>{{ course.component }}</b></span></p>
    </div>
    <div class="row margin-none mx-0">
      <p class="pull-left"><b>{{ course.term_name }}</b></p>
      <p class="pull-right">Grading basis: <span><b>{{ course.grading_basis_description }}</b></span></p>
    </div>
    <div class="heading">{{ course.class_academic_org_description }}</div>
    <div class="second-description">
      <p>Description</p>
      <p v-html="course.course_description_long"/>
    </div>
    <div class= "reading">
      <p>Readings</p>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: {
    ...mapState('user', {
      course: 'currentCourse'
    })
  }
}
</script>

<style scoped>
  .description {
    display: inline-block;
    width: 100%;
  }
  .description .margin-none {
    display: inline-block;
    width: 100%;
    text-align: right;
    font-size: 12px;
  }
  .description .margin-none p {
  margin-bottom: 0px;
  line-height: 100%;
  }
  .description .margin-none p:nth-child(2) {
    text-align: right;
  }
  .description .margin-none:nth-child(2) p {
    margin-top: -25px;
  }
  .description .margin-none:nth-child(3) p {
    margin-top: -38px;
  }
  .heading {
    display: inline-block;
    width: 100%;
    font-size: 22px;
    color:#00f;
    line-height: 1;
    margin-bottom: 20px;
  }
  .second-description p:nth-child(3) {
    margin-bottom: 30px;
  }
  .reading p:nth-child(1) {
    margin-bottom: 0px;
    margin-top: 10px;
  }
</style>
