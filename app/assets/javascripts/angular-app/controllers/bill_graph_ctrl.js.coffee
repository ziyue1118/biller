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
                       .rangeRound([0, width - margin.left - margin.right])
    balances = []
    date_to_balance = []
    Object.keys(bills).forEach((v) -> balances.push(bills[v].balance))
    Object.keys(bills).forEach((v) -> date_to_balance.push('date': new Date(v), 'balance': bills[v].balance))
    console.log date_to_balance
    lowest = d3.min(balances)
    highest = d3.max(balances)
    yScale = d3.scale.linear().domain([lowest,highest])
                         .range([height - margin.top, margin.bottom])
    xAxis = d3.svg.axis()
                  .scale(xScale)
                  .orient('bottom')
                  .ticks(12)
                  .tickFormat(d3.time.format('%b %d'))
                  .tickSize(0)
    yAxis = d3.svg.axis()
                  .scale(yScale)
                  .orient('left')
                  .ticks(12)

   
    vis.append("svg:g").attr("transform", "translate(0," + (height - margin.bottom) + ")").call(xAxis)
    vis.append("svg:g").attr("transform", "translate(" + (margin.left) + ",0)").call(yAxis)

    line = d3.svg.line().x((d) -> xScale(d['date'])).y((d) -> yScale(d['balance'])).interpolate("basis");
    vis.append('svg:path')
       .attr('d', line(date_to_balance))
       .attr('stroke', 'green')
       .attr('stroke-width', 2)
       .attr('fill', 'none');