<template>
  <div class="row">
    <div class="col-md-12">
      <keyword
        v-for="keyword in activeKeywords"
        :key="keyword.ident"
        :keyword="keyword"
      />
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
    ...mapGetters('search', ['activeKeywords'])
  }
}
</script>

<style lang="scss" scoped>

</style>
