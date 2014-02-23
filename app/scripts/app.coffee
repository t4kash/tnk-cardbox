'use strict'

TNK_CARD_APP_ID = "4ofkpZSUMjDDFQowUnV7rrdTPb01XXhuKncyQt5b"
TNK_CARD_JS_KEY = "BSr5oeZvUrD3ZZZly8W170VQ81A9Q0stDU0f61iL"

Parse.initialize(TNK_CARD_APP_ID, TNK_CARD_JS_KEY)

angular.module('tnkCardboxApp', [
  'ngRoute'
  'ngCsv'
])
  .config ['$routeProvider', ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'
      .when '/main',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .when '/card',
        templateUrl: 'views/card.html'
        controller: 'CardCtrl'
      .when '/card/:objectId',
        templateUrl: 'views/card.html'
        controller: 'CardCtrl'
      .otherwise
        redirectTo: '/'
  ]

