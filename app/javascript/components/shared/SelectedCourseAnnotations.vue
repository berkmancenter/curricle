<template>
  <div class="annotation-container">
    <div class="annotations text-center">
      <p class="annotations-up-arrow">
        <i
          class="fa fa-caret-up"
          v-if="!isExpand"
          @click="expand()"/>
      </p>
      <p>
        <span
          class="fa fa-pencil edit-annotation"
          @click="OpenAnnotationsForm()"/>
        <b>Annotations</b>
      </p>
    </div>
    <div v-if="isExpand">
      <div
        v-if="!editableAnnotation"
        style="word-wrap: break-word;">
        <p>
          {{ editableAnnotationText }}
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
      <p class="annotations-down-arrow text-center">
        <i
          class="fa fa-caret-down"
          v-if="isExpand"
          @click="expand()"/>
      </p>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import gql from 'graphql-tag'
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
import Tagging from './SelectedCourseAnnotationsTagging'

export default {
  components: {
    FontAwesomeIcon,
    Tagging
  },
  data () {
    return {
      editableAnnotation: false,
      editableAnnotationText: '',
      editableText: '',
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
    editableText (newStr) {
      this.editableTextlength = newStr.length
    }
  },
  mounted () {
    if (this.course.annotation) {
      this.editableAnnotationText = this.course.annotation.text
    }
  },
  methods: {
    OpenAnnotationsForm () {
      if (this.isExpand) {
        this.editableAnnotation = !this.editableAnnotation
        this.hideDownCaret = !this.hideDownCaret
        this.editableText = this.editableAnnotationText
      }
    },
    expand () {
      this.isExpand = !this.isExpand
    },
    updateAnnotations () {
      this.$apollo.provider.defaultClient.mutate({
        mutation: gql`
          mutation addAnnotation($text: String!, $course_id: ID!){
            addAnnotation(text: $text, course_id: $course_id) {
              text
              id
            }
          }
        `,
        variables: {
          text: this.editableText,
          course_id: this.course.id
        }
      }).then(response => {
        this.editableAnnotationText = response.data.addAnnotation.text
        this.editableAnnotation = !this.editableAnnotation
        this.hideDownCaret = !this.hideDownCaret
      })
    },
    cancelAnnotations () {
      this.editableText = ''
      this.editableAnnotation = !this.editableAnnotation
      this.hideDownCaret = !this.hideDownCaret
    }
  }
}
</script>

<style scoped>
  .annotations {
    display: inline-block;
    width: 100%;
  }
  .annotations p span {
    display: inline-block;
    text-align: left;
    float: left;
    font-size: 20px;
    color: #0030FF;
  }
  .annotation-container {
    background-color: white;
    border: 2px solid #000;
    bottom: 0;
    padding: 0 20px;
    position: absolute;
    width: 100%;
  }
  .annotations-up-arrow i, .annotations-down-arrow i {
    font-size: 30px;
    cursor: pointer;
  }
  .tags {
    display: inline-block;
    width: 100%;
    text-align: center;
    margin: 20px 0;
  }
  .save-btn button {
    background-color: inherit;
    border: 2px solid #000;
    border-radius: 5px;
    padding: 5px 20px;
    margin-top: 20px;
    margin-bottom: 20px;
    cursor: pointer;
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
