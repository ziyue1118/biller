app = angular.module 'biller', [
  'ngRoute',
  'ngResource',
  'bill_graph',
  'calendarServiceModule',
  'calendar',
  'calendarPopoverDirectiveModule',
  'equalValidationDirectiveModule',
  'uniqueUsernameDirectiveModule',
  'ui.bootstrap',
  'ui.select',
  'bill_search',
  'bill_create',
  'bill_update',
  'sign_up'
]

# for compatibility with Rails CSRF protection

app.config ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')
