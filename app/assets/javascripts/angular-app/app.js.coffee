app = angular.module 'biller', [
  'ngRoute',
  'calendar'
]

# for compatibility with Rails CSRF protection

app.config ($httpProvider) ->
  $httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content')

app.config ($routeProvider) ->
  $routeProvider.when '/',
    templateUrl: 'templates/calender.html.haml'
    controller: 'CalendarController'