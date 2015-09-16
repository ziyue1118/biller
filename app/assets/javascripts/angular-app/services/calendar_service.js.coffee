calendar_service = angular.module 'calendarServiceModule', []


calendar_service.factory 'CalendarService', ($resource) ->
  $resource('/bills.json', {}, { getBills: { method: 'GET'} })
  $resource('/bill_searches/new.json', {}, { searchBills: { method: 'GET'}})

