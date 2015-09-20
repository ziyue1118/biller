sign_up = angular.module 'uniqueUsernameDirectiveModule', ['calendarServiceModule']

sign_up.directive 'uniqueUsername', (CalendarService) ->
  restrict: 'A',
  require: 'ngModel',
  link: (scope, element, attrs, model) ->
    scope.$watch(attrs.ngModel, (value) ->
      CalendarService.isUniqueUsername.exec({username: value},
        (data) ->
          console.log data.is_unique_username
          model.$setValidity('uniqueUsername', data.is_unique_username)
        () ->
          model.$setValidity('uniqueUsername', true)
      ) if value != undefined && value != ""
    )