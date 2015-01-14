google.load "visualization", "1.0",
  packages: ["corechart"]

Graph = (selector, data, kind) ->
  @selector = selector
  @data = data
  @kind = kind
  return

instantiateGraphs = ->
  Graph.instances.forEach (instance) ->
    instance.render()
    return

  return

Graph::getData = ->
  _this = this
  
  # create the data table
  dataWithCaptions = @data.data.map((element, index, array) ->
    [
      _this.data.x_axis.series[index]
      element
    ]
  )
  return google.visualization.arrayToDataTable([[
    @data.x_axis.legend
    @data.y_axis.legend
  ]].concat(dataWithCaptions))
  data

Graph::getKind = ->
  kinds =
    column: "ColumnChart"
    pie: "PieChart"

  kinds[@kind]

Graph::render = ->
  
  # Set chart options
  options =
    title: @data.title
    width: 800
    height: 300
    colors: [
      "#85B5BB"
      "#3D7930"
      "#FFC6A5"
      "#FFFF42"
      "#DEF3BD"
      "#00A5C6"
      "#DEBDDE"
      "#000000"
    ]

  
  # Instantiate and draw our chart, passing in some options.
  chart = new google.visualization[@getKind()]($(@selector)[0])
  chart.draw @getData(), options
  return

Graph.instances = []