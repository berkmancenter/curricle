<template>
  <div class="mt-4">
    <keyword
      v-for="keyword in activeKeywords"
      :key="keyword.ident"
      :keyword="keyword"
    />
  </div>
</template>

<script>
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import Keyword from './keyword'
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
