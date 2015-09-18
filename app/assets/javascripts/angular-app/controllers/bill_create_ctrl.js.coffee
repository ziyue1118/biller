bill_create = angular.module 'bill_create', ['calendarServiceModule', 'ui.select']

bill_create.controller 'BillCreateController', ($scope, CalendarService)->

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


  $scope.bill = { is_expense: "expense" }
  $scope.default_categories = ["Eat", "Travel", "Wear", "Live", "Other"]

  $scope.createBill = (bill) ->
    new_bill = new CalendarService.createBill
    new_bill.amount = bill.amount
    new_bill.category = bill.category
    new_bill.date = bill.date
    new_bill.is_expense = bill.is_expense == "expense"
    new_bill.note = bill.note
    new_bill.$save()
    window.location.href = "/bills"

