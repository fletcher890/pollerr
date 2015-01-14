angular.module("PollerrApp").directive("formField", ($timeout) ->
  restrict: "EA"
  templateUrl: "templates/polls/directives/form-field.html"
  replace: true
  scope:
    record: "="
    field: "@"
    live: "@"
    required: "@"
    type: "@"
    disabled: "="

  link: ($scope, element, attr) ->
    $scope.$on "record:invalid", ->
      $scope[$scope.field].$setDirty()
      return

    $scope.remove = (field) ->
      delete $scope.record[field]

      $scope.blurUpdate()
      return

    $scope.blurUpdate = ->
      if $scope.live isnt "false"
        $scope.record.$update (updatedRecord) ->
          $scope.record = updatedRecord
          return

      return

    saveTimeout = undefined
    $scope.update = ->
      $timeout.cancel saveTimeout
      saveTimeout = $timeout($scope.blurUpdate, 1000)
      return

    return
).directive("nestedField", ($timeout) ->
  restrict: "EA"
  templateUrl: "templates/polls/directives/nested-form-field.html"
  replace: true
  scope:
    record: "="
    question: "="
    field: "@"
    live: "@"
    type: "@"
    required: "@"
    index: "@"

  link: ($scope, element, attr) ->
    $scope.$on "record:invalid", ->
      $scope[$scope.field].$setDirty
      return

    $scope.remove = (idx) ->
      $scope.question.possible_answer.splice idx, 1
      return

    $scope.blurUpdate = ->
      if $scope.live isnt "false"
        $scope.record.$update (updatedRecord) ->
          $scope.record = updatedRecord
          return

      return

    saveTimeout = undefined
    $scope.update = ->
      $timeout.cancel saveTimeout
      saveTimeout = $timeout($scope.blurUpdate, 1000)
      return

    return
).directive("pollQuestion", ($timeout) ->
  restrict: "EA"
  templateUrl: "templates/polls/directives/poll-question.html"
  replace: true
  scope:
    record: "="
    question: "="
    live: "@"
    field: "@"
    required: "@"
    reply: "="
    index: "@"

  link: ($scope, element, attr) ->
    $scope.reply.answer_attributes.push question_id: $scope.question.id
    $scope.$on "record:invalid", ->
      $scope[$scope.field].$setDirty
      $scope[$scope.field].$setInvalid
      return

    $scope.addQuestionID = ->

    $scope.blurUpdate = ->
      if $scope.live isnt "false"
        $scope.record.$update (updatedRecord) ->
          $scope.record = updatedRecord
          return

      return

    saveTimeout = undefined
    $scope.update = ->
      $timeout.cancel saveTimeout
      saveTimeout = $timeout($scope.blurUpdate, 1000)
      return

    return
).directive "takePoll", ($timeout, flash) ->
  restrict: "EA"
  replace: true
  templateUrl: "templates/polls/directives/take-poll.html"
  scope:
    poll: "="
    questions: "="
    reply: "="
    temp: "="
    settings: "="

  link: ($scope, element, attrs) ->
    $scope.password = {}
    $scope.access = (password) ->
      if $scope.poll.password is password.value
        $scope.temp = "take-poll"
      else
        flash.success = "You have entered the wrong phrase"
      return

    $scope.save = ->
      $scope.reply.$save ->
        console.log $scope.settings.complete_message
        $scope.temp = "complete"
        return

      return

    return
