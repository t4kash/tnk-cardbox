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
    $scope.userConfigObject = undefined

    ###*
     * 設定読み込み
    ###
    loadConfig = ->
      $scope.loading = true
      coreService.getUserConfig({
        success: (result) ->
          if result?
            $scope.userConfigObject = result
            $scope.userConfig = angular.copy result.attributes
          $scope.loading = false
        error: (error) ->
          $scope.loading = false
      })

    ###*
     * 保存
    ###
    $scope.save = ->
      $scope.processing = true

      coreService.saveUserConfig(
        $scope.userConfigObject
        {"prefecture": $scope.userConfig.prefecture}
        {
          success: (result) ->
            $scope.userConfigObject = result
            $scope.userConfig = angular.copy result.attributes
            $scope.processing = false
            $location.path "/main"
          error: (error) ->
            $scope.errorMessage = "エラー:" + error.code
            $scope.processing = false
        }
      )


    # init
    loadConfig()
