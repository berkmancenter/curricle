<template>
  <home-anonymous v-if="!userAuthenticated" />
  <home-authenticated v-else />
</template>

<script>
import HomeAnonymous from './HomeAnonymous'
import HomeAuthenticated from './HomeAuthenticated'

export default {
  components: {
    HomeAnonymous,
    HomeAuthenticated
  },
  props: {
    userAuthenticated: {
      type: Boolean,
      required: true
    }
  }
}
</script>
