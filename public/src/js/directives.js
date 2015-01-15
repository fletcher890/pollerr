angular.module('PollerrApp')
  .directive('formField', function($timeout){
    return {

      restrict: 'EA',
      templateUrl: 'templates/polls/directives/form-field.html',
      replace: true,
      scope: {
        record: '=',
        field: '@',
        live: '@',
        required: '@',
        type: '@',
        disabled: '='
      },
      link: function($scope, element, attr) {

        $scope.$on('record:invalid', function () {
          $scope[$scope.field].$setDirty();
        });

        $scope.remove = function(field) {
          delete $scope.record[field];
          $scope.blurUpdate();
        }

        $scope.blurUpdate = function () {

          if($scope.live !== 'false'){
            $scope.record.$update(function(updatedRecord) {
              $scope.record = updatedRecord;
            });
          }

        }

        var saveTimeout;

        $scope.update = function() {
          $timeout.cancel(saveTimeout);
          saveTimeout = $timeout($scope.blurUpdate, 1000);
        }

      }

    };
  })

  .directive('nestedField', function($timeout){

    return {

      restrict: 'EA',
      templateUrl: 'templates/polls/directives/nested-form-field.html',
      replace: true,
      scope: {
        record: '=',
        question: '=',
        field: '@',
        live: '@',
        type: '@',
        required: '@',
        index: '@'
      },
      link: function($scope, element, attr) {

        $scope.$on('record:invalid', function() {
          $scope[$scope.field].$setDirty;
        });

        $scope.remove = function(idx) {
          $scope.question.possible_answer.splice(idx, 1);
        }

        $scope.blurUpdate = function () {

          if($scope.live !== 'false'){
            $scope.record.$update(function(updatedRecord) {
              $scope.record = updatedRecord;
            });
          }

        }

        var saveTimeout;

        $scope.update = function() {
          $timeout.cancel(saveTimeout);
          saveTimeout = $timeout($scope.blurUpdate, 1000);
        }

      }

    }

  })

  .directive('pollQuestion', function($timeout) {

    return {

      restrict: 'EA',
      templateUrl: 'templates/polls/directives/poll-question.html',
      replace: true,
      scope: {
        record: '=',
        question: '=',
        live: '@',
        field: '@',
        required: '@',
        reply: '=',
        index: '@'
      },

      link: function($scope, element, attr) {

        $scope.reply.answer_attributes.push({
          question_id: $scope.question.id
        });

        $scope.$on('record:invalid', function() {
          $scope[$scope.field].$setDirty;
          $scope[$scope.field].$setInvalid;
        });

        $scope.addQuestionID = function() {
        }

        $scope.blurUpdate = function () {

          if($scope.live !== 'false'){
            $scope.record.$update(function(updatedRecord) {
              $scope.record = updatedRecord;
            });
          }

        }

        var saveTimeout;

        $scope.update = function() {
          $timeout.cancel(saveTimeout);
          saveTimeout = $timeout($scope.blurUpdate, 1000);
        }

      }

    }

  })

  .directive('takePoll', function($timeout, flash) {
    return {
      restrict: 'EA',
      replace: true,
      templateUrl: 'templates/polls/directives/take-poll.html',
      scope: {
        poll: '=',
        questions: '=',
        reply: '=',
        temp: '=',
        settings: '='
      },
      link: function($scope, element, attrs) {
        $scope.password = {};
       
        $scope.access = function(password) {
          if($scope.poll.password == password.value) {
            $scope.temp = 'take-poll';
          } else {
            flash.success = 'You have entered the wrong phrase';  
          }
        }

        $scope.save = function() {
          $scope.reply.$save(function() {
            console.log($scope.settings.complete_message)
            $scope.temp = 'complete';
          });
        }

      },

    }
  })

  .directive('usernameUnique', function($resource, $timeout) {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function($scope, element, attrs, ngModel) {
        var stop_timeout;
        return $scope.$watch(function(){
          return ngModel.$modelValue;
        }, function(name) {
          $timeout.cancel(stop_timeout);
          if (name === '') {
            ngModel.$setValidity('unique', true);
          } 
        
          var Model = $resource("/api/user/unique");

          if(typeof name != 'undefined'){
            stop_timeout = $timeout(function() {
              Model.query({
                name: name,
              }, function(models) {
                console.log(models.length)
                return ngModel.$setValidity('unique', models.length === 0);
              });
            }, 200);
          }

        });
      }
    }
  });

