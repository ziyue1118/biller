calendar = angular.module 'calendar', ['calendarServiceModule']

calendar.controller 'CalendarController', ($scope, CalendarService, $element) ->

  CalendarService.getBills.exec(
    (data)-> 
      $scope.bills = data
      $scope.buildCalender($scope.selectDay)
  )

  angular.extend $scope,
    selectDay: moment()
    # Get the first day of the week midnight moment object.
    _resetTime: (date) ->
      date.day(0).hour(0).minute(0).second(0).millisecond(0)

    # Build the entire days object based on date and month
    _buildWeek: (date, month) ->
      days = []
      for i in [0...7]
        days.push
          dayName: date.format("ddd")
          dateOfMonth: date.date()
          isCurrentMonth: date.month() == month.month()
          isToday: date.isSame(new Date(), "day")
          dateKey: date.format("YYYY-MM-DD")
          bills: $scope._extract_bills(date).bills
          balance: $scope._extract_bills(date).balance
          count: $scope._extract_bills(date).count
          date: date.clone()
        date.add(1, "d")
      days

    _extract_bills: (date) ->
      bills = []
      balance = 0
      count = 0
      if $scope.bills[date.format("YYYY-MM-DD")] != undefined
        bill_object = $scope.bills[date.format("YYYY-MM-DD")]
        bills = bill_object.bills
        balance = bill_object.balance
        count = bill_object.count
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
