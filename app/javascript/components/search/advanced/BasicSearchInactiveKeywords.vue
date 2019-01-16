<template>
  <div
    v-show="inactiveKeywords.length > 0"
    class="mt-3"
  >
    <b-alert
      show
      variant="secondary"
    >
      <span class="inactive">
        Inactive
      </span>
      <keyword
        v-for="(keyword,idx) in inactiveKeywords"
        :key="idx"
        :keyword-idx="idx"
        :keyword="keyword"
      />
    </b-alert>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import Keyword from './keyword'

export default {
  components: {
    Keyword
  },
  computed: {
    ...mapGetters('search', ['inactiveKeywords'])
  }
}
</script>

<style lang="scss" scoped>
.inactive {
  color: #777;
  margin-right: 15px;
}
</style>
