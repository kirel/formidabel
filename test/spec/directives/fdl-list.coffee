'use strict'

describe 'Directive: fdlList', () ->
  beforeEach module 'formidabelApp'

  element = {}

  it 'should make hidden element visible', inject ($rootScope, $compile) ->
    element = angular.element '<fdl-list></fdl-list>'
    element = $compile(element) $rootScope
    expect(element.text()).toBe 'this is the fdlList directive'
