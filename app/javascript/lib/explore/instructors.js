import * as d3 from 'd3'
import apolloClient from 'apollo'
import COURSES_CONNECTED_BY_INSTRUCTOR_QUERY from '../../graphql/CoursesConnectedByInstructor.gql'

var colorLeft = '#D10F84'
var colorRight = '#00ADF0'
var colorMix = '#2C3194'

var lecturerID

var maxTextLength = 50

var documentWidth = document.body.clientWidth

if (documentWidth > 800) {
  documentWidth = 800
}

var margin = {top: 50, right: 100, bottom: 150, left: 50}
var width = documentWidth - margin.left - margin.right
var height = 900 - margin.top - margin.bottom
var svg
var classScale, instructorTextPosScale, departmentPosScale, instructorTextScale, departmentTextScale

let selectCourse

function initSetup (selectCourseFunction) {
  selectCourse = selectCourseFunction

  svg = d3.select('#visContainer').append('svg')
    .attr('width', width + margin.left + margin.right)
    .attr('height', height + margin.top + margin.bottom)
    .append('g')
    .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

  classScale = d3.scalePoint()
    .range([margin.top, height])

  instructorTextPosScale = d3.scalePoint()
    .range([margin.top, height])

  departmentPosScale = d3.scalePoint()
    .range([margin.top, height])

  instructorTextScale = d3.scaleLinear()
    .range([9, 20])

  departmentTextScale = d3.scaleLinear()
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
  let data = JSON.parse(JSON.stringify(coursesConnectedByInstructor))

  data = data.filter(function (d) {
    return d.term_year === 2018 && d.term_name === 'Spring'
  })

  var random100

  if (data.length > 20) {
    random100 = getRandom(data, 20)
  } else {
    random100 = data
  }

  random100.forEach(function (d) {
    d.departmentClass = d.class_academic_org_description.replace(/ +/g, '_')
    d.courseTypeClass = d.component
  })

  random100.sort(function (a, b) {
    return d3.ascending(a.class_academic_org_description, b.class_academic_org_description)
  })

  monadicView(random100)
}

function requestData (instructorName) {
  lecturerID = instructorName

  apolloClient.query({
    query: COURSES_CONNECTED_BY_INSTRUCTOR_QUERY,
    variables: { instructorName }
  }).then(function (response) {
    loadLecturerData(response.data.courses_connected_by_instructor)
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

  var nestedDepartmentData = d3.nest()
    .key(function (d) { return d.class_academic_org_description })
    .rollup(function (v) {
      return {
        count: v.length,
        classes: v[0].departmentClass
      }
    })
    .entries(data)

  var nestedInstructorData = d3.nest()
    .key(function (d) { return d.course_instructors[0].display_name })
    .rollup(function (v) {
      return {
        count: v.length,
        classes: v[0].departmentClass,
        // classes: function(d) { return d.amount; })
        name: v[0].course_instructors[0].display_name,
        eMail: v[0].course_instructors[0].email
      }
    })
    .entries(data)

  height = ((nestedCourseData.length * 16) + 300)

  d3.select('svg').attr('height', height + margin.top + margin.bottom)

  classScale.range([margin.top, height])
  instructorTextPosScale.range([margin.top + 50, height - 50])
  departmentPosScale.range([margin.top + 50, height - 50])

  classScale.domain(data.map(function (d) { return d.id }))

  instructorTextScale.domain([0, Math.max(d3.max(nestedInstructorData, function (d) { return d.value.count }), 5)])

  departmentTextScale.domain([0, Math.max(d3.max(nestedDepartmentData, function (d) { return d.value.count }), 5)])

  instructorTextPosScale.domain(nestedInstructorData.map(function (d) { return d.key }))

  departmentPosScale.domain(nestedDepartmentData.map(function (d) { return d.key }))

  // -------------------------------------------------------------
  //  Lecturer Name

  svg.select('.lecturerName').remove()

  svg.append('text')
    .attr('class', 'lecturerName')
    .attr('transform', 'translate(-20,-20),rotate(0)')
    .style('text-anchor', 'start')
    .style('font-size', '15px')
    .text(lecturerID)

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
    .attr('class', function (d) { return 'classText ' + d.values[0].departmentClass + ' ' + d.values[0].courseTypeClass })
    .attr('y', function (d) { return classScale(d.key) - 4 })
    .attr('x', function (d) { return width / 2 })
    .style('text-anchor', 'middle')
    .style('font-size', '11px')
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
    .attr('class', function (d) { return 'instructorLine ' + d.departmentClass + ' ' + d.courseTypeClass })
    .attr('d', function (d) {
      x2 = width / 2 - (d.title.length * 2)
      y2 = classScale(d.id)
      y1 = instructorTextPosScale(d.course_instructors[0].display_name)

      return 'M' + x1 + ',' + y1 +
          'C' + xHalf + ',' + y1 +
          ' ' + xHalf + ',' + y2 +
          ' ' + x2 + ',' + y2
    })

  instructorLine
    .enter()
    .append('path')
    .attr('class', function (d) { return 'instructorLine ' + d.departmentClass + ' ' + d.courseTypeClass })
    .attr('d', function (d) {
      x2 = width / 2 - (d.title.length * 2)
      y2 = classScale(d.id)
      y1 = instructorTextPosScale(d.course_instructors[0].display_name)

      return 'M' + x1 + ',' + y1 +
          'C' + xHalf + ',' + y1 +
          ' ' + xHalf + ',' + y2 +
          ' ' + x2 + ',' + y2
    })
    .style('fill', 'none')
    .style('stroke', function (d) { return 'url(#gradientLeft)' })

  // -------------------------------------------------------------
  //  RightVis

  var departmentText = svg.selectAll('.departmentText')
    .data(nestedDepartmentData, function (d) { return d.key })

  departmentText.exit().remove()

  departmentText.transition().duration(500)
    .attr('transform', function (d, i) { return 'translate(' + (width - 150) + ',' + (departmentPosScale(d.key) - 2) + ')' })
    .attr('dy', '0.3em')
    .style('font-size', function (d, i) { return departmentTextScale(d.value.count) })

  departmentText
    .enter()
    .append('text')
    .attr('class', function (d) { return 'departmentText ' + d.value.classes })
    .attr('transform', function (d, i) { return 'translate(' + (width - 150) + ',' + (departmentPosScale(d.key) - 2) + ')' })
    .attr('dy', '0.3em')
    .style('text-anchor', 'start')
    .style('font-size', function (d, i) { return departmentTextScale(d.value.count) })
    .text(function (d) {
      if (d.key.length > maxTextLength) { return d.key.substring(0, maxTextLength) + '...' } else { return d.key }
    })
    .on('click', categoryClick)

  x1 = width - 150
  xHalf = x1 - documentWidth / 20

  var departmentLine = svg.selectAll('.departmentLine')
    .data(data)

  departmentLine.exit().remove()

  departmentLine
    .transition()
    .duration(500)
    .attr('class', function (d) { return 'departmentLine ' + d.departmentClass + ' ' + d.courseTypeClass })
    .attr('d', function (d) {
      x2 = width / 2 + (d.title.length * 2)
      y2 = classScale(d.id)
      y1 = departmentPosScale(d.class_academic_org_description)

      return 'M' + x1 + ',' + y1 +
          'C' + xHalf + ',' + y1 +
          ' ' + xHalf + ',' + y2 +
          ' ' + x2 + ',' + y2
    })

  departmentLine
    .enter()
    .append('path')
    .attr('class', function (d) { return 'departmentLine ' + d.departmentClass + ' ' + d.courseTypeClass })
    .attr('d', function (d) {
      x2 = width / 2 + (d.title.length * 2)
      y2 = classScale(d.id)
      y1 = departmentPosScale(d.class_academic_org_description)

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
  var selectedClass = this.classList[1]

  svg.selectAll('.classLine').style('opacity', 0.1)
  svg.selectAll('.classCircle').style('opacity', 0.1)
  svg.selectAll('.classText').style('opacity', 0.1)

  svg.selectAll('.instructorLine').style('opacity', 0.1)
  svg.selectAll('.instructorText').style('opacity', 0.1)

  svg.selectAll('.departmentLine').style('opacity', 0.1)
  svg.selectAll('.departmentText').style('opacity', 0.1)

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

  svg.selectAll('.departmentLine').style('opacity', 1)
  svg.selectAll('.departmentText').style('opacity', 1)
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

  requestData(lecturerName)
}

function courseClick () {
  const course = this.__data__.values[0]

  selectCourse(course)
}

function getRandom (arr, n) {
  var result = new Array(n)
  var len = arr.length
  var taken = new Array(len)

  if (n > len) { throw new RangeError('getRandom: more elements taken than available') }
  while (n--) {
    var x = Math.floor(Math.random() * len)
    result[n] = arr[x in taken ? taken[x] : x]
    taken[x] = --len
  }
  return result
}

export { initSetup, requestData }
