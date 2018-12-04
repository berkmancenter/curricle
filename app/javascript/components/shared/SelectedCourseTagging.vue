<template>
  <div class="mt-4">
    <p class="heading">
      Tags
    </p>

    <input
      v-model="tagInput"
      class="input-tag text-white w-100 p-2"
      placeholder="Enter a tag"
      @keyup.enter="addTag()"
    >

    <span
      v-for="tag of course.tags"
      :key="tag.id"
      class="active-tag mt-3 mr-2"
      @click="removeTag(tag.id)"
    >
      {{ tag.name }}&nbsp;&nbsp;<font-awesome-icon icon="times" />
    </span>
  </div>
</template>

<script>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import TAG_REMOVE_MUTATION from '../../graphql/TagRemove.gql'
import TAG_SET_MUTATION from '../../graphql/TagSet.gql'
import COURSE_QUERY from '../../graphql/Course.gql'

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
  components: {
    FontAwesomeIcon
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
      tagInput: ''
    }
  },
  methods: {
    removeTag (id) {
      this.$apollo.mutate({
        mutation: TAG_REMOVE_MUTATION,
        variables: {
          id: id
        }
      })
    },
    addTag () {
      if (this.tagInput) {
        this.$apollo.mutate({
          mutation: TAG_SET_MUTATION,
          variables: {
            name: this.tagInput,
            course_id: this.course.id
          }
        })

        this.tagInput = ''
      }
    }
  }
}
</script>

<style scoped lang="scss">
.active-tag {
  cursor: pointer;
  padding: 5px 10px;
  display: inline-block;
  color: black;
  background-color: white;
  font-size: 12px;

  &:hover {
    background-color: #eee;
  }
}

.input-tag {
  background-color: #555;
  border: none;
  font-size: 12px;
}

::placeholder {
  color: white;
}

p.heading {
  border-bottom: 1px solid #999;
  font-size: 12px;
  margin-bottom: 8px;
}
</style>
