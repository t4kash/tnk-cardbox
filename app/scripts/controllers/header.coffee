'use strict'

angular.module('tnkCardboxApp')
  .controller 'HeaderCtrl', ($scope, $location) ->

    ###*
     * ログアウト
    ###
    $scope.logout = ->
      Parse.User.logOut()
      $location.path "/"
