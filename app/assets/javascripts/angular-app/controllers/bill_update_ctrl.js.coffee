bill_update = angular.module 'bill_update', ['calendarServiceModule', 'ui.select', 'ngRoute']

bill_update.controller 'BillUpdateController', ($scope, CalendarService, $route, $routeParams, $location) ->

  # For datetimepicker
  $scope.isOpened = false
  $scope.format = "yyyy-MM-dd HH:mm:ss"

  $scope.open = ($event) ->
    $scope.isOpened = true

  # For select ui
  $scope.clear = ($event, $select) ->
    $event.stopPropagation()
    # to allow empty field, in order to force a selection remove the following line
    $select.selected = undefined
    # reset search query
    $select.search = undefined
    # focus and open dropdown
    $select.activate()

  $scope.refreshResults = ($select) ->
    if $select.search
      # manually add user input and set selection
      $select.selected = $select.search

  $scope.default_categories = ["Eat", "Travel", "Wear", "Live", "Other"]

  # This is the hack that to get id from the url, but this should be refactored.
  # /bills/379a1032-681e-4795-95ac-bd58ab584655/edit ==> 379a1032-681e-4795-95ac-bd58ab584655
  getId = (path) ->
    path.match(/\/bills\/(.*)\/edit/)[1]

  CalendarService.getBill.exec({ id: getId(window.location.pathname) }, (data) ->
    $scope.bill = data.bill
    $scope.bill.is_expense = if data.bill.is_expense then "expense" else "earn"
  )

  $scope.updateBill = (bill) ->
    bill.is_expense = bill.is_expense == "expense"
    bill_id = getId(window.location.pathname)
    CalendarService.updateBill.exec({ id: bill_id }, bill)
    window.location.href = "/bills/" + bill_id
