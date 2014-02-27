'use strict'

angular.module('tnkCardboxApp')
  .controller 'HeaderCtrl', ($scope, coreService) ->

    ###*
     * ログアウト
    ###
    $scope.logout = ->
      coreService.logout()

