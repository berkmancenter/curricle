<template lang="pug">
b-navbar(toggleable="md" type="light" variant="light")
  b-navbar-toggle(target="nav-collapse")
  b-navbar-brand(href="#") Curricle
  b-collapse#nav-collapse(is-nav)
    b-navbar-nav
      b-nav-item(href="#") Link
      b-nav-item(href="#" disabled) Disabled
    b-navbar-nav.ml-auto
      b-nav-item-dropdown(text="Lang" right)
        b-dropdown-item(href="#en") EN
        b-dropdown-item(href="#ru") RU
</template>
