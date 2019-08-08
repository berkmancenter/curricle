import * as d3 from 'd3'
import apolloClient from 'apollo'
import cssesc from 'cssesc'
import COURSES_CONNECTED_BY_INSTRUCTOR_QUERY from '../../graphql/CoursesConnectedByInstructor.gql'
import { transformSchedule } from 'lib/util'

var colorLeft = '#D10F84'
var colorRight = '#00ADF0'
var colorMix = '#2C3194'

var maxTextLength = 50

// main 'container' area is 10 columns wide (out of 12 total) with 5% padding on left/right
const documentWidth = window.innerWidth * 0.8333333 * 0.9

var margin = { top: 50, right: 100, bottom: 150, left: 50 }
var width = documentWidth - margin.left - margin.right
var height = 1200 - margin.top - margin.bottom
var svg
var classScale, instructorTextPosScale, subjectPosScale, instructorTextScale, subjectTextScale

let courseIdStyles
let courseLevels
let selectCourse
let semester
let showLoaderOverlay
let setTitleName
let showNoResultsContainer

function initSetup (selectCourseFunction, showLoaderOverlayFunction, setTitleNameFunction, showNoResultsContainerFunction, courseIdStylesFunction, selectedCourseLevel) {
  courseIdStyles = courseIdStylesFunction
  courseLevels = [selectedCourseLevel]
  selectCourse = selectCourseFunction
  showLoaderOverlay = showLoaderOverlayFunction
  setTitleName = setTitleNameFunction
  showNoResultsContainer = showNoResultsContainerFunction

  svg = d3.select('#visContainer').append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
    .append('g')
    .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

  classScale = d3.scalePoint()
    .range([margin.top, height])

  instructorTextPosScale = d3.scalePoint()
    .range([margin.top, height])

  subjectPosScale = d3.scalePoint()
    .range([margin.top, height])

  instructorTextScale = d3.scaleLinear()
    .range([8, 19])

  subjectTextScale = d3.scaleLinear()
    .range([9, 20])

  var gradientLeft = svg.append('defs')
    .append('linearGradient')
    .attr('id', 'gradientLeft')
    .attr('x1', '0%')
    .attr('y1', '0%')
    .attr('x2', '100%')
    .attr('y2', '0%')

  gradientLeft.append('stop')
    .attr('offset', '0%')
    .attr('stop-color', colorLeft)
    .attr('stop-opacity', 0)

  gradientLeft.append('stop')
    .attr('offset', '20%')
    .attr('stop-color', colorLeft)
    .attr('stop-opacity', 0.7)

  gradientLeft.append('stop')
    .attr('offset', '80%')
    .attr('stop-color', colorMix)
    .attr('stop-opacity', 0.7)

  gradientLeft.append('stop')
    .attr('offset', '100%')
    .attr('stop-color', colorMix)
    .attr('stop-opacity', 0)

  var gradientRight = svg.append('defs')
    .append('linearGradient')
    .attr('id', 'gradientRight')
    .attr('x1', '0%')
    .attr('y1', '0%')
    .attr('x2', '100%')
    .attr('y2', '0%')

  gradientRight.append('stop')
    .attr('offset', '0%')
    .attr('stop-color', colorMix)
    .attr('stop-opacity', 0)

  gradientRight.append('stop')
    .attr('offset', '20%')
    .attr('stop-color', colorMix)
    .attr('stop-opacity', 0.7)

  gradientRight.append('stop')
    .attr('offset', '80%')
    .attr('stop-color', colorRight)
    .attr('stop-opacity', 0.7)

  gradientRight.append('stop')
    .attr('offset', '100%')
    .attr('stop-color', colorRight)
    .attr('stop-opacity', 0)
}

function loadLecturerData (coursesConnectedByInstructor) {
  // unfreeze the data object being passed in
  const data = JSON.parse(JSON.stringify(coursesConnectedByInstructor))

  data.forEach(function (d) {
    d.subjectClass = cssesc(d.subjectDescription, { isIdentifier: true })
    d.courseTypeClass = cssesc(d.component, { isIdentifier: true })
  })

  data.sort(function (a, b) {
    return d3.ascending(a.subjectDescription, b.subjectDescription)
  })

  monadicView(data)
}

function requestData (instructorName, selectedSemester, selectedCourseLevel) {
  courseLevels = [selectedCourseLevel]

  semester = {
    termName: selectedSemester.termName.toUpperCase(),
    termYear: selectedSemester.termYear
  }

  setTitleName(instructorName)

  showLoaderOverlay(true)

  apolloClient.query({
    query: COURSES_CONNECTED_BY_INSTRUCTOR_QUERY,
    variables: { courseLevels, instructorName, semester }
  }).then(function (response) {
    const courses = response.data.coursesConnectedByInstructor

    if (courses.length) {
      showNoResultsContainer(false)
      loadLecturerData(courses)
    } else {
      showNoResultsContainer(true)
    }

    showLoaderOverlay(false)
  })
}

function monadicView (data) {
  svg.select('#loadingOverlay').remove()

  // -------------------------------------------------------------
  //  Data Transformation

  var nestedCourseData = d3.nest()
    .key(function (d) { return d.id })
    .rollup()
    .entries(data)

  var nestedSubjectData = d3.nest()
    .key(function (d) { return d.subjectDescription })
    .rollup(function (v) {
      return {
        count: v.length,
        classes: v[0].subjectClass
      }
    })
    .entries(data)

  var nestedInstructorData = d3.nest()
    .key(function (d) { return d.courseInstructors[0].displayName })
    .rollup(function (v) {
      return {
        count: v.length,
        classes: v[0].subjectClass,
        // classes: function(d) { return d.amount; })
        name: v[0].courseInstructors[0].displayName,
        eMail: v[0].courseInstructors[0].email
      }
    })
    .entries(data)

  height = ((nestedCourseData.length * 16) + 300)

  d3.select('svg').attr('height', height + margin.top + margin.bottom)

  classScale.range([margin.top, height])
  instructorTextPosScale.range([margin.top + 50, height - 50])
  subjectPosScale.range([margin.top + 50, height - 50])

  classScale.domain(data.map(function (d) { return d.id }))

  instructorTextScale.domain([0, Math.max(d3.max(nestedInstructorData, function (d) { return d.value.count }), 5)])

  subjectTextScale.domain([0, Math.max(d3.max(nestedSubjectData, function (d) { return d.value.count }), 5)])

  instructorTextPosScale.domain(nestedInstructorData.map(function (d) { return d.key }))

  subjectPosScale.domain(nestedSubjectData.map(function (d) { return d.key }))

  //  CenterVis

  var classText = svg.selectAll('.classText')
    .data(nestedCourseData, function (d) { return d.key })

  classText.exit().remove()

  classText.transition().duration(500)
    .attr('y', function (d) { return classScale(d.key) - 2 })
    .attr('x', function (d) { return width / 2 })

  classText
    .enter()
    .append('text')
    .attr('class', function (d) {
      const classes = 'classText ' + d.values[0].subjectClass + ' ' + d.values[0].courseTypeClass + ' ' + courseIdStyles(d.key)
      return classes
    })
    .attr('y', function (d) { return classScale(d.key) - 4 })
    .attr('x', function (d) { return width / 2 })
    .style('text-anchor', 'middle')
    .style('font-size', '12px')
    .attr('dy', '0.8em')
    .text(function (d) {
      if (d.values[0].title.length > maxTextLength) { return d.values[0].title.substring(0, maxTextLength) + '...' } else { return d.values[0].title }
    })
    .on('click', courseClick)

  // -------------------------------------------------------------
  //  LeftVis

  var instructorText = svg.selectAll('.instructorText')
    .data(nestedInstructorData, function (d) { return d.key })

  instructorText.exit().remove()

  instructorText.transition().duration(500)
    .attr('transform', function (d, i) { return 'translate(' + 150 + ',' + (instructorTextPosScale(d.key) - 2) + ')' })
    .attr('dy', '0.3em')
    .style('font-size', function (d, i) { return instructorTextScale(d.value.count) })

  instructorText
    .enter()
    .append('text')
    .attr('class', function (d) { return 'instructorText ' + d.value.classes })
    .attr('transform', function (d, i) { return 'translate(' + 150 + ',' + (instructorTextPosScale(d.key) - 2) + ')' })
    .attr('dy', '0.3em')
    .style('text-anchor', 'end')
    .style('font-size', function (d, i) { return instructorTextScale(d.value.count) })
    .text(function (d) {
      if (d.value.name.length > maxTextLength) { return d.value.name.substring(0, maxTextLength) + '...' } else { return d.value.name }
    })
    .on('click', lectureClick)

  var x1 = 150
  var y1
  var x2
  var y2
  var xHalf = x1 + documentWidth / 20

  var instructorLine = svg.selectAll('.instructorLine')
    .data(data)

  instructorLine.exit().remove()

  instructorLine
    .transition()
    .duration(500)
    .attr('class', function (d) { return 'instructorLine ' + d.subjectClass + ' ' + d.courseTypeClass })
    .attr('d', function (d) {
      x2 = width / 2 - (d.title.length * 3)
      y2 = classScale(d.id)
      y1 = instructorTextPosScale(d.courseInstructors[0].displayName)

      return 'M' + x1 + ',' + y1 +
          'C' + xHalf + ',' + y1 +
          ' ' + xHalf + ',' + y2 +
          ' ' + x2 + ',' + y2
    })

  instructorLine
    .enter()
    .append('path')
    .attr('class', function (d) { return 'instructorLine ' + d.subjectClass + ' ' + d.courseTypeClass })
    .attr('d', function (d) {
      x2 = width / 2 - (d.title.length * 3)
      y2 = classScale(d.id)
      y1 = instructorTextPosScale(d.courseInstructors[0].displayName)

      return 'M' + x1 + ',' + y1 +
          'C' + xHalf + ',' + y1 +
          ' ' + xHalf + ',' + y2 +
          ' ' + x2 + ',' + y2
    })
    .style('fill', 'none')
    .style('stroke', function (d) { return 'url(#gradientLeft)' })

  // -------------------------------------------------------------
  //  RightVis

  var subjectText = svg.selectAll('.subjectText')
    .data(nestedSubjectData, function (d) { return d.key })

  subjectText.exit().remove()

  subjectText.transition().duration(500)
    .attr('transform', function (d, i) { return 'translate(' + (width - 150) + ',' + (subjectPosScale(d.key) - 2) + ')' })
    .attr('dy', '0.3em')
    .style('font-size', function (d, i) { return subjectTextScale(d.value.count) })

  subjectText
    .enter()
    .append('text')
    .attr('class', function (d) { return 'subjectText ' + d.value.classes })
    .attr('transform', function (d, i) { return 'translate(' + (width - 150) + ',' + (subjectPosScale(d.key) - 2) + ')' })
    .attr('dy', '0.3em')
    .style('text-anchor', 'start')
    .style('font-size', function (d, i) { return subjectTextScale(d.value.count) })
    .text(function (d) {
      if (d.key.length > maxTextLength) { return d.key.substring(0, maxTextLength) + '...' } else { return d.key }
    })
    .on('click', categoryClick)

  x1 = width - 150
  xHalf = x1 - documentWidth / 20

  var subjectLine = svg.selectAll('.subjectLine')
    .data(data)

  subjectLine.exit().remove()

  subjectLine
    .transition()
    .duration(500)
    .attr('class', function (d) { return 'subjectLine ' + d.subjectClass + ' ' + d.courseTypeClass })
    .attr('d', function (d) {
      x2 = width / 2 + (d.title.length * 3)
      y2 = classScale(d.id)
      y1 = subjectPosScale(d.subjectDescription)

      return 'M' + x1 + ',' + y1 +
          'C' + xHalf + ',' + y1 +
          ' ' + xHalf + ',' + y2 +
          ' ' + x2 + ',' + y2
    })

  subjectLine
    .enter()
    .append('path')
    .attr('class', function (d) { return 'subjectLine ' + d.subjectClass + ' ' + d.courseTypeClass })
    .attr('d', function (d) {
      x2 = width / 2 + (d.title.length * 3)
      y2 = classScale(d.id)
      y1 = subjectPosScale(d.subjectDescription)

      return 'M' + x1 + ',' + y1 +
          'C' + xHalf + ',' + y1 +
          ' ' + xHalf + ',' + y2 +
          ' ' + x2 + ',' + y2
    })
    .style('fill', 'none')
    .style('stroke', function (d) { return 'url(#gradientRight)' })
}

// -------------------------------------------------------------
//  Category Selection

function categoryClick () {
  var selectedClass = cssesc(this.classList[1], { isIdentifier: true })

  svg.selectAll('.classLine').style('opacity', 0.1)
  svg.selectAll('.classCircle').style('opacity', 0.1)
  svg.selectAll('.classText').style('opacity', 0.1)

  svg.selectAll('.instructorLine').style('opacity', 0.1)
  svg.selectAll('.instructorText').style('opacity', 0.1)

  svg.selectAll('.subjectLine').style('opacity', 0.1)
  svg.selectAll('.subjectText').style('opacity', 0.1)

  svg.selectAll('.' + selectedClass).style('opacity', 1)

  d3.select('svg').insert('rect', 'g') // .append('rect')
    .attr('class', 'categoryClickRect')
    .attr('x', 0)
    .attr('y', 0)
    .attr('width', width + margin.right + margin.left)
    .attr('height', height + margin.top + margin.bottom)
    .style('fill', 'rgba(255,255,255,0')
    .on('click', categoryClickRemoval)
}

function categoryClickRemoval () {
  svg.selectAll('.categoryClickRect').remove()

  svg.selectAll('.classLine').style('opacity', 1)
  svg.selectAll('.classCircle').style('opacity', 1)
  svg.selectAll('.classText').style('opacity', 1)

  svg.selectAll('.instructorLine').style('opacity', 1)
  svg.selectAll('.instructorText').style('opacity', 1)

  svg.selectAll('.subjectLine').style('opacity', 1)
  svg.selectAll('.subjectText').style('opacity', 1)
}
// -------------------------------------------------------------
//  lecturer Vis on Class selection

function lectureClick () {
  var lecturerName = this.__data__.value.name

  svg.append('rect')
    .attr('id', 'loadingOverlay')
    .attr('x', 0)
    .attr('y', 0)
    .attr('width', width + margin.right)
    .attr('height', height + margin.bottom)
    .style('fill', 'rgba(255,255,255,.5)')

  requestData(lecturerName, semester)
}

function courseClick () {
  const course = this.__data__.values[0]

  course.schedule = transformSchedule(course)

  selectCourse(course)
}

export { initSetup, requestData }
