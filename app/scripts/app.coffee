'use strict'

angular.module('formidabelApp', [
  'ngCookies',
  'ngSanitize',
  'ngRoute',
  'ui.select2'
])
  .config ($routeProvider) ->
    $routeProvider
      .when '/',
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'
      .otherwise
        redirectTo: '/'
