<template>
  <div>
    <div class="basic-search mb-3">
      <semester-input :allow-range="true" />

      <div class="mt-4 w-50">
        <b-input-group>
          <b-input-group-prepend is-text>
            <img
              class="icon"
              src="/images/icons/eye_black.png"
            >
          </b-input-group-prepend>

          <input
            v-model="searchQuery"
            type="search"
            class="search pl-0 form-control"
            placeholder="Search courses"
            @keyup.enter="performSearch"
          >

          <b-input-group-append is-text>
            <img
              class="icon pointer"
              src="/images/icons/return_arrow.png"
              @click="performSearch"
            >
          </b-input-group-append>
        </b-input-group>

        <div
          class="mt-4"
        >
          <b-btn
            id="search-tips"
            variant="outline-secondary"
          >
            Search Tips
          </b-btn>

          <b-popover
            placement="bottom"
            target="search-tips"
            triggers="click"
          >
            Use * as a wildcard to search on partial words<br>
            Group search terms using ( )<br>
            Use | for "or" logic<br>
            Use - to exclude a specific term
          </b-popover>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SemesterInput from 'components/shared/SemesterInput'

export default {
  components: {
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

  .input-group-text,
  input.search {
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
