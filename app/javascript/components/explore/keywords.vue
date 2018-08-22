<template>
  <div>
    <div id="interfaceContainer">
      <div id="dimContainer">
        <ul>
          <li
            class="dimSelect active"
            value="component">
          Component</li> |

          <li
            class="dimSelect"
            value="subject_description">
          Subject</li> |

          <li
            class="dimSelect"
            value="division_description">
          Division</li> |

          <li
            class="dimSelect"
            value="units_maximum">
          Units</li> |

          <li
            class="dimSelect"
            value="term_pattern_description">
          Term</li> |

          <li
            class="dimSelect"
            value="class_academic_org_description">
          Department</li> |

          <li
            id="dimClass"
            class="dimSelect"
            value="title">
            Class
          </li>
        </ul>
      </div>

      <div id="searchContainer">
        <div
          id="searchOne"
          class="searchBox">
          <input
            id="searchBoxOne"
            class="searchBoxInput"
            type="text"
            placeholder="search term...">

          <button
            id="searchBoxOneButton"
            class="searchBoxButton">
            &gt;
          </button>
        </div>

        <div
          id="searchTwo"
          class="searchBox">
          <button
            id="searchBoxTwoButton"
            class="searchBoxButton">
            &lt;
          </button>

          <input
            id="searchBoxTwo"
            class="searchBoxInput"
            type="text"
            placeholder="search term...">
        </div>
      </div>

      <div id="visContainer"/>
    </div>

    <div id="vis-description">
      <h3>Explore:</h3>

      <p>
        Visualize the appearance of terms across the curriculum.

        <span
          v-b-tooltip.hover
          title="In this visualization, you can explore the use of key terms in the names and descriptions of courses to reveal compelling combinations of concepts across the curriculum. In the entry fields at left and right, enter two keywords—&quot;truth&quot; and &quot;lies,&quot; or &quot;economics&quot; and &quot;evolution,&quot; perhaps—and the visualization will display the courses using those words, independently or in tandem, in their titles or descriptions. Click on course titles to access full course descriptions or add courses to your tray. To reset the visualization, simply enter new keywords at left and right."
          class="pointer">
          MORE&nbsp;&gt;
        </span>
      </p>

      <semester-input/>
    </div>
  </div>
</template>

<script>
import 'd3'
import 'jquery'
import { initSetup } from 'lib/explore/keywords'
import { mapActions, mapGetters } from 'vuex'
import SemesterInput from 'components/search/SearchFormSemesterInput'

export default {
  components: {
    SemesterInput
  },
  computed: {
    ...mapGetters('search', ['semesterStart'])
  },
  watch: {
    semesterStart (newSemester) {
      initSetup(this.selectCourse, newSemester)
    }
  },
  mounted () {
    initSetup(this.selectCourse, this.semesterStart)
  },
  methods: {
    ...mapActions('app', ['selectCourse'])
  }
}
</script>

<style lang="scss" scoped>
#interfaceContainer {
  /deep/ {
    svg{
      display: block;
      margin: 0;
    }

    .rightSelected, .leftSelected{
      /*text-decoration: underline;*/
      font-weight: 300;
      cursor:pointer;
    }

    .rightSelected:hover, .leftSelected:hover{
      text-decoration: underline;
    }

    .leftSelected{
      fill: green;
    }

    .rightSelected{
      fill: orange;
    }

    .centerText{
      cursor:pointer;
      text-shadow:
      -1px -1px 0 rgba(255,255,255,.5),
        1px -1px 0 rgba(255,255,255,.5),
        -1px 1px 0 rgba(255,255,255,.5),
        1px 1px 0 rgba(255,255,255,.5);
    }

    .centerText:hover{
      text-decoration: underline;
    }

    .centerSelected{
      text-decoration: underline;
      font-weight: 700;
      cursor:pointer;
    }

    .insideText:hover{
      text-decoration: underline;
      cursor:pointer;
    }

    /*------ Search Style -------*/

    .searchBox{
      position: absolute;
      width: 137px;
      top: 50%;
      left: 50%;
      background: none;
    }

    #searchBoxOne{
      text-align: right;
      color: #f0cf61;
    }

    #searchBoxTwo{
      color: #005397;
    }

    #searchBoxOneButton{
      text-align: right;
    }

    .searchBoxInput{
      outline: none;
      font-family: 'IBM Plex Sans', sans-serif;
      border: none;
      border-bottom: 1px solid black;
      font-size: 14px;
      font-weight: 300;
      width: 90px;
    }

    .searchBoxButton{
      outline: none;
      font-family: 'IBM Plex Sans', sans-serif;
      border: none;
      font-size: 14px;
      background: white;
    }

    /*------ Dim. Select Style -------*/

    #dimContainer{
      height: 0px;
      padding-top: 30px;
      text-align: center;
      min-width: 600px;
    }

    #dimContainer ul {
      list-style-type: none;
      margin: auto;
      padding: 0;
      vertical-align: middle;
        }

    #dimContainer li {
        display: inline;
        cursor: pointer;
    }

    .dimSelect:hover{
      text-decoration: underline;
    }

    .dimSelect.active{
      text-decoration: underline;
    }
  }
}

#vis-description {
  position: fixed;
  bottom: 25px;
  margin-left: 10px;
  width: 200px;

  h3 {
    font-size: 18px;
  }

  p {
    font-size: 14px;
  }
}
</style>
