<template>
  <div class="mt-4">
    <p class="heading">
      Annotations
    </p>

    <div>
      <textarea
        v-model="editableText"
        :maxlength="maxLength"
        rows="5"
        class="p-1 w-100"
      />

      <span class="word-count">
        {{ editableTextLength }} / {{ maxLength }} characters
      </span>

      <div class="button-container">
        <button
          class="btn clearfix"
          @click="updateAnnotations"
        >
          Save
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import ANNOTATION_SET_MUTATION from '../../graphql/AnnotationSet.gql'
import COURSE_QUERY from '../../graphql/Course.gql'
import { mapMutations } from 'vuex'

export default {
  apollo: {
    course: {
      query: COURSE_QUERY,
      variables () {
        return {
          id: this.courseId
        }
      }
    }
  },
  props: {
    courseId: {
      type: String,
      required: true
    }
  },
  data () {
    return {
      course: {},
      editableText: '',
      maxLength: 500,
      editableTextLength: 0
    }
  },
  computed: {
    savedAnnotation () {
      return this.course.annotation ? this.course.annotation.text : ''
    }
  },
  watch: {
    editableText (newStr) {
      this.editableTextLength = newStr.length
    },
    course () {
      this.editableText = this.savedAnnotation
    }
  },
  mounted () {
    this.editableText = this.savedAnnotation
  },
  methods: {
    ...mapMutations('app', ['SET_ALERT_TEXT']),
    updateAnnotations () {
      this.$apollo.mutate({
        mutation: ANNOTATION_SET_MUTATION,
        variables: {
          text: this.editableText,
          course_id: this.course.id,
          id: this.course.annotation && this.course.annotation.id
        }
      }).then(
        this.SET_ALERT_TEXT('Annotation saved')
      )
    }
  }
}
</script>

<style lang="scss" scoped>
  .word-count {
    position: relative;
    color: #ccc;
    bottom: 30px;
    left: 5px;
    font-size: 10px;
  }

  .button-container {
    margin-top: -15px;
  }

  p.heading {
    border-bottom: 1px solid #999;
    margin-bottom: 8px;
  }

  textarea {
    background-color: black;
    border: none;
    color: white;
    font-size: 12px;
  }

  button.btn {
    background-color: white;
    color: black;

    &:hover {
      background-color: #ccc;
    }
  }
</style>
