'use strict'

TNK_CARD_APP_ID = "@@TNK_CARD_APP_ID"
TNK_CARD_JS_KEY = "@@TNK_CARD_JS_KEY"

Parse.initialize(TNK_CARD_APP_ID, TNK_CARD_JS_KEY)

angular.module('tnkCardboxApp', [
  'ngRoute'
  'ngCsv'
])
  .config(['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
      .when '/main',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/config',
        templateUrl: 'views/config.html'
        controller: 'ConfigCtrl'
      .when '/card',
        templateUrl: 'views/card.html'
        controller: 'CardCtrl'
      .when '/card/:objectId',
        templateUrl: 'views/card.html'
        controller: 'CardCtrl'
      .otherwise
        redirectTo: '/'
  ])
  .run(['$rootScope', ($rootScope) ->
    $rootScope.cards = null
  ])

