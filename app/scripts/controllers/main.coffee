'use strict'

flip2 = (fn) -> (a, b) -> fn(b, a)
flip3 = (fn) -> (a, b, c) -> fn(c, b, a)
unary = (fn) -> (a) -> fn(a)

angular.module('formidabelApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.expenses = [
      {name: 'Foo', payers: {Daniel: 5, Jan: 50}, left: []},
      {name: 'Foo', payers: {Tom: 6, Jan: 3, Martin: 0}, left: []}]
    $scope.people = []
    $scope.payed = {}
    $scope.debt = {}

    $scope.validPayer = (add) ->
       add && _.isNumber(add.amount) && (add.existingPayer || add.newPayer)

    $scope.addPayer = (expense) ->
      expense.payers[expense.add.newPayer || expense.add.existingPayer] = expense.add.amount
      expense.add = {}

    $scope.addExpense = (newExpense) ->
      $scope.expenses.push _.extend({}, newExpense, payers: {})
      newExpense.name = null

    $scope.$watch 'expenses', ->
      collectPeople()
      recomputeLeft()
      accumulateExpenses()
      accumulateDebt()
    , true

    collectPeople = ->
      $scope.people = _.union.apply(null, _.map(_.pluck($scope.expenses, 'payers'), _.keys))

    recomputeLeft = ->
      _.each $scope.expenses, (expense) ->
        expense.left = _.reject($scope.people, _.partial(_.has, expense.payers))

    plusmerge = _.partialRight(_.merge, (a, b) -> if a? then a + b else b)

    $scope.expenseTotal = (expense) -> _.reduce(_.values(expense.payers), ((a,b) -> a + b), 0)

    accumulateExpenses = ->
      $scope.payed = plusmerge.apply(null, [{}].concat(_.pluck($scope.expenses, 'payers')))

    expenseSettlement = (expense) ->
      total = $scope.expenseTotal(expense)
      participants = _.size(expense.payers)
      _.merge {}, expense.payers, -> total/participants

    accumulateDebt = ->
      $scope.debt = plusmerge.apply(null, [{}].concat(_.map($scope.expenses, expenseSettlement)))

    collectPeople()
    recomputeLeft()
    accumulateExpenses()
    accumulateDebt()
