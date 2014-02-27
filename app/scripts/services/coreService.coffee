'use strict'

angular.module('tnkCardboxApp')
  .service 'coreService', ($location) ->

    ###*
     * ログアウト
    ###
    this.logout = ->
      Parse.User.logOut()
      $location.path "/"

    @
