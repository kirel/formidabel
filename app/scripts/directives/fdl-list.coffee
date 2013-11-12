'use strict';

angular.module('formidabelApp')
  .directive('fdlList', () ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, ngModel) ->
      ngModel.$parsers.push (val) -> val.split(',').map($.trim)
  )
