sign_up = angular.module 'sign_up', ['calendarServiceModule', 'ui.bootstrap']


sign_up.controller 'SignUpController', ($scope, CalendarService, $modal, $log)->
  $scope.user = {}

  $scope.createUser = (user) ->
    new_user = new CalendarService.createUser
    new_user.username = user.username
    new_user.password = user.password
    new_user.email = user.email
    new_user.$save()
    window.location.href = "/"

  $scope.open = () ->
    modalInstance = $modal.open(
      animation: true,
      templateUrl: 'signUp.html',
      controller: 'ModalInstanceCtrl',
      resolve:
        user: () ->
          $scope.user
    )
    modalInstance.result.then(
      (user) ->
        $scope.user = user
        $scope.createUser($scope.user)
      () ->
        $log.info('Modal dismissed at: ' + new Date())
    )

sign_up.controller 'ModalInstanceCtrl', ($scope, $modalInstance, user)->

  $scope.user = {}

  $scope.submit = () ->
    $modalInstance.close($scope.user)

  $scope.cancel = () ->
    $modalInstance.dismiss('cancel')
