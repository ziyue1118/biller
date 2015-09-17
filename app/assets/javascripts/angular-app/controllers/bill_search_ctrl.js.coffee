bill_search = angular.module 'bill_search', ['calendarServiceModule', 'ui.bootstrap']


bill_search.controller 'BillSearchController', ($scope, CalendarService) ->
  # This is for angular UI bootstrap datepicker
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

  # This is for angular UI pagination
  $scope.currentPage = 1
  $scope.maxSize = 5 # show how many buttons on the pagination
  $scope.itemsPerPage = 15

  $scope.search_bills_by_time_range = (start_time, end_time) ->
    CalendarService.searchBills({start: start_time, end: end_time}, (
      (data) ->
        $scope.bills = data.bills
        $scope.balance = data.balance
        $scope.alert_banner = if $scope.balance > 0 then "success" else "danger"
    ))

  $scope.search_bills_by_time_range($scope.start.date, $scope.end.date)