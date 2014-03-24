'use strict'

angular.module('tnkCardboxApp')
  .controller 'ConfigCtrl', ($scope, $location, coreService, cardAttribute) ->

    if !coreService.getUser()
      coreService.logout()
      return

    $scope.prefectures = cardAttribute.prefectures
    $scope.processing = false
    $scope.errorMessage = ''
    $scope.loading = false
    $scope.userConfig = undefined

    ###*
     * 設定読み込み
    ###
    loadConfig = ->
      $scope.loading = true
      coreService.getUserConfig({
        success: (result) ->
          if result?
            $scope.userConfig = angular.copy result.attributes
            $scope.userConfig.object = result
          $scope.loading = false
        error: (error) ->
          $scope.loading = false
      })

    ###*
     * 設定保存
    ###
    $scope.save = ->
      $scope.processing = true

      coreService.saveUserConfig(
        $scope.userConfig.object
        {"prefecture": $scope.userConfig.prefecture}
        {
          success: (result) ->
            $scope.userConfig = angular.copy result.attributes
            $scope.userConfig.object = result
            $scope.processing = false
            $location.path "/main"
          error: (error) ->
            $scope.errorMessage = "エラー:" + error.code
            $scope.processing = false
        }
      )

    ###*
     * パスワード保存
    ###
    $scope.savePassword = ->
      $scope.processing = true

      coreService.changePassword(
        $scope.password1
        {
          success: (result) ->
            $scope.processing = false
            $location.path "/main"
          error: (error) ->
            $scope.errorMessage = "エラー:" + error.code
            $scope.processing = false
        }
      )


    # init
    loadConfig()
