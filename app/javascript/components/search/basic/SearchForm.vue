<template>
  <div>
    <div class="basic-search mb-3">
      <semester-input/>

      <div class="mt-4 w-50">
        <b-input-group>
          <b-input-group-prepend is-text>
            <img
              class="icon"
              src="/images/icons/eye_black.png">
          </b-input-group-prepend>

          <input
            v-model="searchQuery"
            class="search pl-0 form-control"
            placeholder="Search courses"
            @keyup.enter="performSearch">

          <b-input-group-append is-text>
            <img
              class="icon pointer"
              src="/images/icons/return_arrow.png"
              @click="performSearch">
          </b-input-group-append>
        </b-input-group>
      </div>
    </div>
  </div>
</template>

<script>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import SemesterInput from 'components/shared/SemesterInput'

export default {
  components: {
    FontAwesomeIcon,
    SemesterInput
  },
  data () {
    return {
      searchQuery: ''
    }
  },
  methods: {
    performSearch () {
      if (!this.searchQuery) { return }

      this.$store.commit('search/SET_BASIC_SEARCH', this.searchQuery)
      this.$store.dispatch('search/runBasicSearch')
    }
  }
}
</script>

<style lang="scss" scoped>
.basic-search {
  .form-control:focus {
    box-shadow: none;
  }

  span.invert {
    background: #000;
    color: #fff;
    padding: 5px 8px;
  }

  .input-group-text, input.search {
    background-color: #ddd;
    border: 0;
    color: black;
  }
}

::placeholder {
  color: black !important;
}

img.icon {
  height: 12px;
  width: auto;
}
</style>
