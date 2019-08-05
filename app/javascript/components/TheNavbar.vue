<template>
  <nav
    id="nav-main"
    class="d-none d-md-block pt-5 px-4"
  >
    <div
      id="logo"
      class="text-center"
    >
      <router-link to="/">
        <img
          class="w-100"
          src="/images/logos/curricle-black-bg.svg"
        >
      </router-link>
    </div>

    <div
      id="nav-primary-container"
      class="mt-5"
    >
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
        content="Expand your horizon with interactive visualizations of the course catalog"
        placement="right"
        target="explore-link"
        triggers="hover"
      />

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
        content="Narrow down your choices with a range of filters and parameters"
        placement="right"
        target="search-link"
        triggers="hover"
      />

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
        content="Plan out your schedule, whether for this semester or for the long haul"
        placement="right"
        target="plan-link"
        triggers="hover"
      />

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
        content="Your one-stop shop for all links important to the course selection process"
        placement="right"
        target="tools-link"
        triggers="hover"
      />

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
        content="Find answers to the most common questions or ask one yourself"
        placement="right"
        target="faq-link"
        triggers="hover"
      />

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
        content="Read about Curricle and the team that has brought it to you"
        placement="right"
        target="about-link"
        triggers="hover"
      />

      <br>

      <a
        id="news-link"
        class="nav secondary"
        target="_blank"
        href="https://curricledev.wpengine.com"
      >
        News
      </a>

      <b-popover
        boundary="viewport"
        content="Keep up to date with the latest features and project updates"
        placement="right"
        target="news-link"
        triggers="hover"
      />
    </div>
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

      &:hover {
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
</style>
