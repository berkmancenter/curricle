<template>
  <div class="annotation-border">
    <div class="annotations">
      <p class="annotations-up-arrow">
        <i
          class="fa fa-caret-up"
          v-if="!isExpand"
          @click="expand()"/>
      </p>
      <p
      :class="{ 'annotations-margin-top': isExpand }">
        <span
          class="fa fa-pencil edit-annotation"
          @click="OpenAnnotationsForm()"/>
        <b>Annotations</b>
      </p>
    </div>
    <div v-if="isExpand">
      <div
        v-if="!editableAnnotations"
        style="word-wrap: break-word;">
        <p>
          {{ editableAnnotationsText }}
        </p>
      </div>
      <div v-else>
        <p>
          <textarea
            rows="10"
            style="width: 100%"
            maxlength="500"
            v-model="editableText"/>
          <span class="word-count">{{ editableTextlength }} / {{ maxLength }} characters</span>
          <span
            class=""
            v-for="(text, index) of annotationTags"
            @click="removeTags(index)"
            :key="index">
            {{ text }}&nbsp;&nbsp;<font-awesome-icon icon="times"/>
          </span>
        </p>
        <div class="save-btn">
          <button @click="updateAnnotations">Update</button>
          <button @click="cancelAnnotations">Cancel</button>
        </div>
      </div>
      <tagging
        :active-tags="course.user_tags"
        :course-id="course.id"
        @deactivateTag="deactivateTag($event)" />
    </div>
    <div>
      <p class="annotations-down-arrow">
        <i
          class="fa fa-caret-down"
          :class="{ 'hide-down-caret': hideDownCaret }"
          v-if="isExpand"
          @click="expand()"/>
      </p>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import axios from 'axios'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
import lodash from 'lodash/isEmpty'
import Tagging from './SelectedCourseAnnotationsTagging'

export default {
  components: {
    FontAwesomeIcon,
    Tagging
  },
  data () {
    return {
      editableAnnotations: false,
      editableAnnotationsText: '',
      editableText: '',
      annotationTags: [],
      isExpand: false,
      hideDownCaret: false,
      maxLength: 500,
      editableTextlength: 0,
      isPresent: false
    }
  },
  computed: {
    ...mapState('user', {
      course: 'currentCourse'
    })
  },
  watch: {
    course () {
      this.setCourse()
    },
    editableText (newStr) {
      this.editableTextlength = newStr.length
    }
  },
  methods: {
    OpenAnnotationsForm () {
      if (this.isExpand) {
        this.editableAnnotations = !this.editableAnnotations
        this.hideDownCaret = !this.hideDownCaret
        this.editableText = this.editableAnnotationsText
      }
    },
    expand () {
      this.isExpand = !this.isExpand
    },
    updateAnnotations () {
      axios
        .post('annotations', {course_id: this.course.id, annotation: this.editableText}).then((response) => {
          this.editableAnnotationsText = response.data.annotation
          this.editableAnnotations = !this.editableAnnotations
          this.hideDownCaret = !this.hideDownCaret
        })
    },
    cancelAnnotations () {
      this.annotationTags = []
      this.editableText = ''
      this.editableAnnotations = !this.editableAnnotations
      this.hideDownCaret = !this.hideDownCaret
    },
    fetchAnnotation () {
      axios
        .get('/annotations/get_annotations?course_id=' + this.course.id).then((response) => {
          if (response.data) {
            this.editableAnnotationsText = response.data.annotation
          } else {
            this.editableAnnotationsText = ''
          }
          this.editableText = this.editableAnnotationsText
        })
    },
    setCourse () {
      this.fetchAnnotation()
      this.isPresent = !lodash(this.course || {})
      if (this.isPresent) {
        this.isExpand = false
        this.editableAnnotation = false
        this.hideDownCaret = false
        this.editableText = false
      }
    },
    mounted () {
      this.setCourse()
    }
  }
}
</script>

<style scoped>
  .annotations {
    display: inline-block;
    width: 100%;
    text-align: center;
  }
  .annotations p span {
    display: inline-block;
    text-align: left;
    float: left;
    font-size: 20px;
    color: #0030FF;
  }
  .annotation-border {
    border: 2px solid #000;
    padding: 0 20px;
  }
  .annotation-para p {
    text-align: justify;
  }
  .annotation-border p:nth-child(2){
    margin-bottom: 0px;
  }
  .annotations-up-arrow i, .annotations-down-arrow i {
    font-size: 30px;
    cursor: pointer;
  }
  .annotations-down-arrow {
    text-align: center;
  }
  .annotations-margin-top {
    margin-top: 10px;
  }
  .tags{
    display: inline-block;
    width: 100%;
    text-align: center;
    margin: 20px 0;
  }
  .save-btn button{
    background-color: inherit;
    border: 2px solid #000;
    border-radius: 5px;
    padding: 5px 20px;
    margin-top: 20px;
    margin-bottom: 20px;
    cursor: pointer;
  }
  .hide-down-caret{
    display: none;
  }
  .annotations textarea{
    resize: none !important;
  }
  .word-count{
    position: relative;
    color: gray;
    bottom: 25px;
    left: 100px;
    font-size: 10px;
  }
  .edit-annotation{
    cursor: pointer;
  }
</style>
