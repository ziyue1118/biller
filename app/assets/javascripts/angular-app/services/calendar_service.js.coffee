calendar_service = angular.module 'calendarServiceModule', []

calendar_service.factory 'CalendarService', ["$resource", ($resource) -> 
  getBills: $resource('/bills.json', {}, { exec: { method: 'GET'} })
  searchBills: $resource('/bill_searches/new.json', {}, { exec: { method: 'GET'}})
  createBill: $resource('/bills', {}, {})
  getBill: $resource('/bills/:id.json', {id: '@id'}, {exec: {method: 'GET'}})
  updateBill: $resource('/bills/:id', {}, {exec: {method: 'PUT'}})
  createUser: $resource('/users', {}, {})
  isUniqueUsername: $resource('/users/check/:username.json', {username: '@username'}, {exec: {method: 'GET'}})
]
