'use strict'

flip2 = (fn) -> (a, b) -> fn(b, a)
flip3 = (fn) -> (a, b, c) -> fn(c, b, a)
unary = (fn) -> (a) -> fn(a)

angular.module('formidabelApp')
  .controller 'MainCtrl', ($scope) ->
    $scope.expenses = []
      #{name: 'Foo', payers: {Daniel: 5, Jan: 50}, debtors: [], left: []},
      #{name: 'Foo', payers: {Tom: 6, Jan: 3, Martin: 0}, debtors: [], left: []}]
    $scope.people = []
    $scope.payed = {}
    $scope.debt = {}

    $scope.validPayer = (add) ->
       add && _.isNumber(add.amount) && (add.existingPayer || add.newPayer)

    $scope.addPayer = (expense) ->
      expense.payers[expense.add.newPayer || expense.add.existingPayer] = expense.add.amount
      expense.add = {}

    $scope.addExpense = (newExpense) ->
      $scope.expenses.push _.extend({}, newExpense, debtors: [], payers: {})
      newExpense.name = null

    $scope.$watch 'expenses', ->
      collectPeople()
      recomputeLeft()
      accumulateExpenses()
      accumulateDebt()
    , true

    collectPeople = ->
      payers = _.map(_.pluck($scope.expenses, 'payers'), _.keys)
      debtors = _.pluck($scope.expenses, 'debtors')
      $scope.people = _.select(_.union.apply(null, payers.concat(debtors)), _.identity)

    recomputeLeft = ->
      _.each $scope.expenses, (expense) ->
        expense.left = _.reject($scope.people, _.partial(_.has, expense.payers))

    plusmerge = _.partialRight(_.merge, (a, b) -> if a? then a + b else b)

    $scope.expenseTotal = (expense) -> _.reduce(_.values(expense.payers), ((a,b) -> a + b), 0)

    accumulateExpenses = ->
      $scope.payed = plusmerge.apply(null, [{}].concat(_.pluck($scope.expenses, 'payers')))

    # return { debtor: total/paticipants, ... }
    expenseSettlement = (expense) ->
      total = $scope.expenseTotal(expense)
      if _.select(expense.debtors, _.identity).length
        participants = _.size(expense.debtors)
        _.zipObject expense.debtors, _.map(_.range(expense.debtors.length), -> total/participants)
      else
        participants = _.size(expense.payers)
        _.merge({}, expense.payers, -> total/participants)

    accumulateDebt = ->
      $scope.debt = plusmerge.apply(null, [{}].concat(_.map($scope.expenses, expenseSettlement)))

    collectPeople()
    recomputeLeft()
    accumulateExpenses()
    accumulateDebt()
