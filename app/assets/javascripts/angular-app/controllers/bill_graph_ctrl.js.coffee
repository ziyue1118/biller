bill_graph = angular.module 'bill_graph', ['calendarServiceModule']

bill_graph.controller 'BillGraphController', ($scope, CalendarService, $element) ->

  CalendarService.getBills(
    (data) -> 
      $scope.bills = data
      $scope.generate_graph($scope.bills)
  )

  $scope.generate_graph = (bills) ->
    vis = d3.select("#bill_graph_visualisation")
    width = 1200
    height = 500
    margin =
      top: 20
      right: 20
      bottom: 20
      left: 50

    Object.keys(bills).filter((v) -> v[0] == "$").forEach((v) -> delete bills[v]) # exclude $resolved and $promise
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
    yScale = d3.scale.linear().domain([lowest, highest])
                         .range([height - margin.top, margin.bottom])
    xAxis = d3.svg.axis()
                  .scale(xScale)
                  .orient('bottom')
                  .ticks(10)
                  .tickFormat(d3.time.format('%b %d'))
    yAxis = d3.svg.axis()
                  .scale(yScale)
                  .orient('left')
                  .ticks(10)

    line = d3.svg.line().x((d) -> xScale(d['date'])).y((d) -> yScale(d['balance'])).interpolate("basis");

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

    vis.append("svg:g").attr("class", "bill-graph-axis").attr("transform", "translate(0," + (height - margin.bottom) + ")").call(xAxis);
    vis.append("svg:g").attr("class", "bill-graph-axis").attr("transform", "translate(" + (margin.left) + ",0)").call(yAxis);