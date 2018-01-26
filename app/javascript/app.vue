<template>
  <div id="app">
    <header>
      <navbar/>
      <keep-alive>
        <router-view/>
      </keep-alive>
    </header>
    <course-observer/>
  </div>
</template>

<script>
import Navbar from 'components/TheNavbar'
import CourseObserver from 'components/course-observer'

export default {
  components: {
    Navbar,
    CourseObserver
  },
  mounted () {
    // load initial data
    this.$store.dispatch('user/getUserData')
  }
}
</script>
