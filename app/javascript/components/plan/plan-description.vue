<template >
  <div class="description">
    <div class="row margin-none">
      <p class="pull-left"><b>{{ course.academic_group }}</b></p>
      <p class="pull-right">Component: <span><b>{{ course.component }}</b></span></p>
    </div>
    <div class="row margin-none">
      <p class="pull-left"><b>{{ course.term_name }}</b></p>
      <p class="pull-right">Grading basis: <span><b>{{ course.grading_basis_description }}</b></span></p>
    </div>
    <div class="row margin-none">
      <p class="pull-left"><b>{{ course.external_course_id }}</b></p>
      <p class="pull-right">Instructor: <span><b>{{ course.instructor.first_name }}</b></span></p>
    </div>
    <div class="heading">{{ course.class_academic_org_description }}</div>
    <div class="second-description">
      <p>Description</p>
      <p v-html="course.course_description_long"/>
    </div>
    <div class="instruction">
      <p>Instruction</p>
      <div class="row margin-none">
        <p class="pull-left"><b>{{ course.instructor.first_name }} {{ course.instructor.last_name }}</b></p>
        <p class="pull-right">More Courses</p>
      </div>
    </div>
    <div class= "reading">
      <p>Reading</p>
      <div class="annotation-border">
        <div class="annotations">
          <p><a href="#"><span class="fa fa-pencil"/></a><b>Annotations</b></p>
        </div>
        <div class="annotation-para">
          <p>
            Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
          </p>
        </div>
        <div class= "annonation-tag">
          <tags
            :active-tags="course.user_tags"
            :tag="tag"
            :course-id="course.id"
            @deactivateTag="deactivateTag($event)" />
        </div>
      </div>
    </div>
  </div>
</template>

<script type="text/javascript">
import Tags from './tags.vue'

export default {
  props: ['course'],
  components: {
    Tags,
  },
  data () {
    return {
      tag: ''
    }
  }
}
</script>

<style>
  .bottom-border {
    border-bottom: 1px gray solid;
  }
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
    color:#ff00ff;
    line-height: 1;
    margin-bottom: 20px;
  }
  .instruction .margin-none{
    display: inline-block;
    width: 100%;
    text-align: right;
    border-bottom: 1px solid #bcbaba;
  }
  .instruction {
     display: inline-block;
    width: 100%;
  }
  .instruction  .margin-none p:nth-child(2) {
    text-align: right;
  }
  .annotations {
    display: inline-block;
    width: 100%;
    text-align: center;
  }
  .annotations p span {
    display: inline-block;
    text-align: left;
    float: left;
    font-size: 25px;
    color: #ff00ff;
  }
  .annotation-border {
    border: 1px solid #000;
    padding: 20px;
    border-radius: 5px;
  }
  .annotation-para p {
    text-align: justify;
  }
  .second-description p:nth-child(3) {
    margin-bottom: 30px;
  }
  .reading p:nth-child(1) {
    margin-bottom: 0px;
    margin-top:
  }
</style>
