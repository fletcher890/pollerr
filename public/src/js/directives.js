angular.module('pollerApp')
  .directive('formField', function($timeout){
    return {

      restrict: 'EA',
      templateUrl: 'templates/polls/directives/form-field.html',
      replace: true,
      scope: {
        record: '=',
        field: '@',
        live: '@',
        required: '@'
      },
      link: function($scope, element, attr) {

        $scope.$on('record:invalid', function(){
          $scope[$scope.field].$setDirty;
        });

        $scope.remove = function(field) {
          delete $scope.record[field];
          $scope.blurUpdate();
        }

        $scope.blurUpdate = function () {

          if($scope.live !== 'false'){
            $scope.record.$update(function(updateRecord) {
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
  });