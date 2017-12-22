<template lang="pug">
  #app
    header
      navbar

    router-view
</template>

<script>
import Navbar from 'components/navbar.vue'

export default {
  components: {
    Navbar
  }
}
</script>
