sign_up = angular.module 'equalValidationDirectiveModule', []

sign_up.directive 'equalValidation', () ->
  restrict: 'A',
  require: 'ngModel',
  link: (scope, elem, attrs, model) ->
    return if !attrs.equalValidation

    scope.$watch(attrs.equalValidation, (value) ->
      model.$setValidity('equalValidation', value == model.$viewValue) if model.$viewValue != undefined && model.$viewValue != ''
    )

    model.$parsers.push((value) ->
      model.$setValidity('equalValidation', true) if value == undefined || value == ''
      isValid = value == scope.$eval(attrs.equalValidation)
      model.$setValidity('equalValidation', isValid)
      if isValid then value else undefined
    )
