calendar_service = angular.module 'calendarServiceModule', []


calendar_service.factory 'CalendarService', ["$resource", ($resource) -> 
  getBills: $resource('/bills.json', {}, { exec: { method: 'GET'} })
  searchBills: $resource('/bill_searches/new.json', {}, { exec: { method: 'GET'}})
  createBill: $resource('/bills', {}, {})
]
