<template>
  <div
    class="row"
    v-if="inactiveKeywords.length > 0">
    <div class="col-md-12">
      <b-alert
        show
        variant="secondary">
        <span class="inactive">Inactive</span>
        <keyword
          v-for="keyword in inactiveKeywords"
          :keyword="keyword"
        />
      </b-alert>
    </div>
  </div>
</template>

<script>
import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
import Keyword from 'components/search/keyword'
import { mapGetters } from 'vuex'

export default {
  components: {
    FontAwesomeIcon,
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
