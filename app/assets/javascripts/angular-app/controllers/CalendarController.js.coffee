calendar = angular.module 'calendar', []




calendar.controller 'CalendarController', ($scope) ->
  bills_by_time_div = document.getElementById('bills_by_time');
  angular.extend $scope,
    selectDay: moment()
    # Get the first day of the week midnight moment object.
    _resetTime: (date) ->
      date.day(0).hour(0).minute(0).second(0).millisecond(0)

    # Build the entire days object based on date and month
    _buildWeek: (date, month) ->
      days = []
      # Get bills information from bills_by_time_div
      for i in [0...7]
        days.push
          dayName: date.format("ddd")
          dateOfMonth: date.date()
          isCurrentMonth: date.month() == month.month()
          isToday: date.isSame(new Date(), "day")
          dateKey: date.format("YYYY-MM-DD")
          bills: $scope._extract_bills(date)['bills']
          balance: $scope._extract_bills(date)['balance']
          count: $scope._extract_bills(date)['count']
          date: date.clone()
        date.add(1, "d")
      days

    _extract_bills: (date) ->
      bills = []
      balance = 0
      count = 0
      if bills_by_time_div.getAttribute("data-" + date.format("YYYY-MM-DD"))
        json_object = JSON.parse(bills_by_time_div.getAttribute("data-" + date.format("YYYY-MM-DD")))
        bills = json_object["bills"]
        balance = json_object["balance"]
        count = json_object["count"]
      bills: bills
      balance: balance
      count: count

    _buildMonth: (start, month) ->
      $scope.weeks = []
      startDate = start.clone() #Dont want to change the start
      monthIndex = start.month()
      numOfWeek = 0
      done = false
      while !done
        $scope.weeks.push $scope._buildWeek(startDate.clone(), month)
        startDate.add(1, "w")
        done = numOfWeek++ > 3 && monthIndex != startDate.month()
        monthIndex = startDate.month()

    buildCalender: (selectedTime) ->
      $scope.month = selectedTime.clone()
      start = selectedTime.clone().date(1) #Get the first date of this month
      $scope._resetTime(start.day(0)) #Get the first sunday midnight of the first date of the month
      $scope._buildMonth(start, $scope.month)

    nextMonthCalender: ()->
      next = $scope.month.clone()
      $scope._resetTime(next.month(next.month() + 1).date(1))
      $scope.month.month($scope.month.month() + 1)
      $scope._buildMonth(next, $scope.month)

    previousMonthCalender: ()->
      previous = $scope.month.clone()
      $scope._resetTime(previous.month(previous.month() - 1).date(1))
      $scope.month.month($scope.month.month() - 1)
      $scope._buildMonth(previous, $scope.month)

    select: (day)->
      $scope.selectDay = day
  
  $scope.buildCalender($scope.selectDay)
  # $scope.previousMonthCalender()
  console.log($scope.weeks)

