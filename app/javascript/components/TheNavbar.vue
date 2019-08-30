<template>
  <nav
    id="nav-main"
    class="d-none d-md-block pt-5 px-4"
  >
    <div
      id="logo"
      class="text-center mb-4"
    >
      <router-link to="/">
        <img
          class="w-100"
          src="/images/logos/curricle-black-bg-16861.svg"
        >
      </router-link>
    </div>

    <hr>

    <router-link
      id="explore-link"
      class="nav primary"
      :class="classObject"
      to="/explore"
    >
      Explore
    </router-link>

    <b-popover
      boundary="viewport"
      placement="right"
      target="explore-link"
      triggers="hover"
    >
      Expand your horizons by exploring
      <br>
      visualizations of the course catalog
    </b-popover>

    <br>

    <div
      v-show="activeNavPrimary === 'explore'"
      class="nav-sub-container"
    >
      <router-link
        class="nav sub"
        to="/explore/keyword-comparisons"
      >
        Keyword Comparisons
      </router-link>

      <br>

      <router-link
        class="nav sub"
        to="/explore/learning-styles"
      >
        Learning Styles
      </router-link>

      <br>

      <router-link
        class="nav sub"
        to="/explore/instructor-networks"
      >
        Instructor Networks
      </router-link>

      <br>

      <router-link
        class="nav sub"
        to="/explore/course-universe"
      >
        Course Universe
      </router-link>
    </div>

    <router-link
      id="search-link"
      class="nav primary"
      :class="classObject"
      to="/search"
    >
      Search
    </router-link>

    <b-popover
      boundary="viewport"
      placement="right"
      target="search-link"
      triggers="hover"
    >
      Narrow down your choices by applying
      <br>
      custom filters and parameters
    </b-popover>

    <br>

    <div
      v-show="activeNavPrimary === 'search'"
      class="nav-sub-container"
    >
      <router-link
        class="nav sub"
        to="/search/advanced"
      >
        Advanced Search
      </router-link>
    </div>

    <hr>

    <router-link
      id="plan-link"
      class="nav primary"
      :class="classObject"
      to="/plan"
    >
      Plan
    </router-link>

    <b-popover
      boundary="viewport"
      placement="right"
      target="plan-link"
      triggers="hover"
    >
      Plan out your schedule, whether
      <br>
      for this semester or the long haul
    </b-popover>

    <br>

    <div
      v-show="activeNavPrimary === 'plan'"
      class="nav-sub-container"
    >
      <router-link
        class="nav sub"
        to="/plan/week"
      >
        Week
      </router-link>

      <br>

      <router-link
        class="nav sub"
        to="/plan/semester"
      >
        Semester
      </router-link>

      <br>

      <router-link
        class="nav sub"
        to="/plan/list"
      >
        List
      </router-link>
    </div>

    <hr>

    <router-link
      id="tools-link"
      class="nav secondary"
      :class="classObject"
      to="/tools"
    >
      Tools
    </router-link>

    <b-popover
      boundary="viewport"
      placement="right"
      target="tools-link"
      triggers="hover"
    >
      Your one-stop shop for links important
      <br>
      for the course selection process
    </b-popover>

    <br>

    <router-link
      id="faq-link"
      class="nav secondary"
      to="/faq"
    >
      FAQ
    </router-link>

    <b-popover
      boundary="viewport"
      placement="right"
      target="faq-link"
      triggers="hover"
    >
      Find answers to common
      <br>
      questions &mdash; or ask one yourself
    </b-popover>

    <br>

    <router-link
      id="about-link"
      class="nav secondary"
      to="/about"
    >
      About
    </router-link>

    <b-popover
      boundary="viewport"
      placement="right"
      target="about-link"
      triggers="hover"
    >
      Read about Curricle and the
      <br>
      Curricle development team
    </b-popover>

    <br>

    <a
      id="news-link"
      class="nav secondary"
      target="_blank"
      href="http://curricle.wpengine.com/"
    >
      News
    </a>

    <b-popover
      boundary="viewport"
      placement="right"
      target="news-link"
      triggers="hover"
    >
      Keep up to date on the latest
      <br>
      features and project updates
    </b-popover>

    <hr>

    <p
      id="curricle-lens-link"
      class="nav pointer secondary"
    >
      Curricle Lens

      <br>

      <span
        id="coming-soon"
        class="font-italic"
      >
        Coming Oct. 1st!
      </span>
    </p>

    <b-popover
      boundary="viewport"
      placement="right"
      target="curricle-lens-link"
      triggers="hover"
    >
      Dig into data-driven stories about the
      <br>
      history of the Harvard curriculum
    </b-popover>

    <hr>
  </nav>
</template>

<script>

export default {
  props: {
    userAuthenticated: {
      type: Boolean,
      required: true
    }
  },
  computed: {
    activeNavPrimary () {
      return this.$route.path.split('/')[1]
    },
    classObject () {
      return {
        anonymous: !this.userAuthenticated
      }
    }
  }
}
</script>

<style lang="scss" scoped>
  #nav-main {
    .nav-sub-container {
      margin: 10px 0;
    }

    .nav {
      padding: 4px 6px;
      display: inline-block;

      a:hover {
        cursor: pointer;
        text-decoration: underline;
      }

      &.primary,
      &.secondary {
        color: #999;
        margin: 4px 0;
        text-transform: uppercase;

        &.anonymous {
          color: #555;
        }
      }

      &.sub {
        color: #777;
        margin-bottom: 4px;
        margin-left: 10px;
      }

      &.router-link-active {
        color: white;
      }

      &.router-link-exact-active {
        background: white;
        color: black;
        border-radius: 4px;
      }
    }

    hr {
      border-top-color: #999;
    }
  }

  #coming-soon {
    font-size: .9em;
    text-transform: none;
  }
</style>
