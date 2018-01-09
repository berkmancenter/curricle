<template lang="pug">
b-navbar(toggleable="md" type="light" variant="light")
  b-navbar-toggle(target="nav-collapse")
  b-navbar-brand
    b-navbar-nav
      b-nav-item-dropdown(text="<strong>The Catalog</strong> Spring 2018")
        b-dropdown-item(href="#") Spring 2018
  b-collapse#nav-collapse(is-nav)
    b-navbar-nav.ml-auto
      b-nav-item(to='search') Search
      b-nav-item(to='explore') Explore
      b-nav-item(to='plan') Plan
    b-navbar-nav.ml-auto.tray-li
      b-nav-item(@click='logout') Logout
      b-nav-item(href='' @click="trayToggle" v-bind:class="{'tray-active': trayVisible}") Tray
</template>

<script>
  import axios from 'axios'
  export default {
    props: ['trayToggle', 'trayVisible'],
    methods: {
      logout () {
        axios.get('/users/sign_out')
          .then(response => {
            this.$router.go('/users/sign_in')
          })
      }
    }
  }
</script>
<style type="text/css">  
  .tray-li:last-child a{
    padding: 5px 25px !important;    
  }
  .tray-active .nav-link{
    color: #FFF !important;
    background-color: #000;  
    border-radius: 2px;    
  }
</style>
