bill_graph = angular.module 'bill_graph', ['calendarServiceModule', 'ui.bootstrap']

bill_graph.controller 'BillGraphController', ($scope, CalendarService) ->

  $scope.start =
    date: ""
    opened: false

  $scope.end =
    date: ""
    opened: false

  $scope.format = "yyyy-MM-dd HH:mm:ss"

  $scope.start_open = ($event) ->
    $scope.start.opened = true

  $scope.end_open = ($event) ->
    $scope.end.opened = true

  $scope.get_bills_and_draw_graph = (start_time, end_time) ->
    CalendarService.getBills.exec({start: start_time, end: end_time}, (
      (data) ->
        $scope.generate_graph(data)
    ))

  $scope.generate_graph = (bills) ->
    $scope.clean_up_graph()
    vis = d3.select("#bill_graph_visualisation")
    width = 1200
    height = 500
    margin =
      top: 30
      right: 30
      bottom: 30
      left: 30

    Object.keys(bills).filter((v) -> v[0] == "$").forEach((v) -> delete bills[v]) # exclude $resolved and $promise
    return if Object.keys(bills).length == 0 # This will check whether there is a bill during the time range

    start_date = Object.keys(bills)[0]
    end_date = Object.keys(bills)[Object.keys(bills).length - 1]

    xScale = d3.time.scale().domain([new Date(start_date), d3.time.day.offset(new Date(end_date), 2)])
                       .rangeRound([margin.left, width - margin.right])
    balances = []
    date_to_balance = []
    Object.keys(bills).forEach((v) -> balances.push(bills[v].balance))
    Object.keys(bills).forEach((v) -> date_to_balance.push('date': new Date(v), 'balance': bills[v].balance))

    lowest = d3.min(balances)
    highest = d3.max(balances)
    time_format = d3.time.format('%b %d')
    yScale = d3.scale.linear().domain([lowest, highest])
                         .range([height - margin.top, margin.bottom])
    xAxis = d3.svg.axis()
                  .scale(xScale)
                  .orient('bottom')
                  .ticks(10)
                  .tickFormat(time_format);

    yAxis = d3.svg.axis()
                  .scale(yScale)
                  .orient('left')
                  .ticks(10);

    line = d3.svg.line().x((d) -> xScale(d.date)).y((d) -> yScale(d.balance));

    # This will make balance above 0 be green and balance below 0 be red
    vis.append("svg:linearGradient")
      .attr("id", "balance-zero")
      .attr("gradientUnits", "userSpaceOnUse")
      .attr("x1", 0).attr("y1", yScale(-1)).attr("x2", 0).attr("y2", yScale(1))
    .selectAll("stop")
      .data([
        {offset: "0%", color: "red"},
        {offset: "50%", color: "red"},
        {offset: "50%", color: "green"},
        {offset: "100%", color: "green"}
      ])
    .enter().append("stop")
      .attr("offset", (d) -> d.offset)
      .attr("stop-color", (d) -> d.color);

    vis.append('svg:path')
       .attr('d', line(date_to_balance))
       .attr('class', 'balance-line');

    tooltip = d3.select("body").append("div")
                .attr("class", "tooltip")
                .style("opacity", 0);
    # This will add the scatter dots on the chart
    vis.selectAll('dot').data(date_to_balance).enter().append("circle")
       .attr("r", 5)
       .attr("cx", (d)-> xScale(d.date))
       .attr("cy", (d)-> yScale(d.balance))
       .on("mouseover", (d)->
          tooltip.transition().duration(200).style("opacity", .7)
          tooltip.html(time_format(d.date) + "<br/>$"  + d.balance).style("left", d3.event.pageX + "px").style("top", (d3.event.pageY - 28) + "px"))
       .on("mouseout", (d)-> tooltip.transition().duration(200).style("opacity", 0))

    # Draw the axis
    vis.append("svg:g").attr("class", "bill-graph-axis").attr("transform", "translate(0," + (height - margin.bottom) + ")").call(xAxis);
    vis.append("svg:g").attr("class", "bill-graph-axis").attr("transform", "translate(" + (margin.left) + ",0)").call(yAxis);


  $scope.clean_up_graph = () ->
    vis = document.getElementById('bill_graph_visualisation')
    vis.removeChild(vis.firstChild) while (vis.firstChild)

  $scope.get_bills_and_draw_graph($scope.start.date, $scope.end.date)



