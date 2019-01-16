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
import { mapGetters } from 'vuex'
import Keyword from './keyword'

export default {
  components: {
    Keyword
  },
  computed: {
    ...mapGetters('search', ['activeKeywords'])
  }
}
</script>
