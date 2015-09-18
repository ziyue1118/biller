app = angular.module 'biller', [
  'ngRoute',
  'ngResource',
  'bill_graph',
  'calendarServiceModule',
  'calendar',
  'calendarPopoverDirectiveModule',
  'ui.bootstrap',
  'ui.select',
  'bill_search',
  'bill_create'
]

# for compatibility with Rails CSRF protection

app.config ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
