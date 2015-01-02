angular.module('PollerrApp')
  .controller('DashboardController', function($scope, $rootScope, Poll, $location, $route) {
    $scope.date = new Date();
    $rootScope.PAGE = 'dashboard'

    $scope.click = function(where) {
      $location.url(where);
    }

  })
  .controller('NavigationController', function($scope, $rootScope, $location) {
    $scope.click = function(where) {
      if(where == 'dashboard'){
        where = '';
      }
      $location.url(where);
    }
  })
  .controller('AuthController', function($scope, $rootScope, $location, $routeParams) {
    var init = function() {
      console.log($routeParams);
      if( $routeParams.logout ) {
        $location.url('login');
      }
      if( $routeParams.login ) {
        console.log('login')
      }
    }
    console.log('12312312')
    init();
  })
  .controller('PollsController', function ($scope, $rootScope, Poll, $location, $route) {
    $rootScope.PAGE = 'polls'
    $scope.polls = Poll.query();
    $scope.fields = ['title']

    $scope.sort = function(field) {
      $scope.sort.field = field;
      $scope.sort.order = !$scope.sort.order;
    }

    $scope.sort.field = 'title';
    $scope.sort.order = false;

    $scope.show = function(id) {
      $location.url('polls/' + id);
    };

    $scope.new = function() {
      $location.url('polls/new')
    }

    $scope.delete = function (idx) {
      var poll_to_delete = $scope.polls[idx];
      Poll.delete({ id: poll_to_delete.id }, function(successResult){
        $scope.polls.splice(idx, 1);
      }, function(errorResult) {
        alert('Something went wrong!');
      });
    }

  })

  .controller('NewPollController', function ($scope, $rootScope, Poll, $location) {
    $rootScope.PAGE = 'polls';
    $scope.poll = new Poll({
      title: ''
    });

    $scope.save = function() {

      if($scope.newPoll.$invalid) {
        $scope.$broadcast('record:invalid');
      } else {
        $scope.poll.$save();
        $location.url('/polls');
      }

    };

    $scope.checkPasswordProtected = function() {
      return $scope.poll.password_protected == 'Y'
    }

  })

  .controller('SinglePollController', function ($scope, $rootScope, $location, Poll, Question, Reply, $routeParams, $route) {
    $rootScope.PAGE = 'polls';
    $scope.activeTab = $routeParams.tab || 'questions'
    $scope.poll = Poll.get({ id: $routeParams.id });
    $scope.graphData = Poll.get_json({ id: $routeParams.id }, function(data) {
      Graph.instances.push(new Graph("#polls_per_month", data, "column"));
      instantiateGraphs();
    });

    // function instantiateGraphs(){
    //   console.log('12312312')
    // }

    $scope.edit = function() {
      $location.url('polls/' + $scope.poll.id + '/edit');
    }

    $scope.add_question  = function(){
      $location.url('polls/' + $scope.poll.id + '/questions/new');
    }

    $scope.delete = function () {
      $scope.poll.$delete();
      $location.url('/polls');
    }

    $scope.show_question = function(id, qid){
      $location.url('/polls/' + id + '/questions/' + qid + '/edit');
    }

    $scope.delete_question = function(idx){
      var question_to_delete = $scope.poll.question[idx];
      Question.delete({ id: question_to_delete.id }, function(successResult) {
          // do something on success
          $scope.poll.question.splice(idx, 1);
      }, function(errorResult) {
        alert('Something went wrong!')
      });
    }

    $scope.reroute = function(where) {
      $location.path('polls/' + $scope.poll.id + '/' + where, false);
    }

    $scope.showReply = function(reply) {
      $scope.activeReply = Reply.get({ id: reply });
    }

  })

  .controller('EditPollController', function ($scope, $rootScope, $location, Poll, $routeParams, flash) {
    $rootScope.PAGE = 'polls'
    $scope.poll = Poll.get({ id: $routeParams.id });

    $scope.save = function() {
      $scope.poll.$update();
      flash.success = 'You have successfully updated the poll';  
      $location.url('/polls/' + $routeParams.id);
    }

    $scope.checkPasswordProtected = function() {
      return $scope.poll.password_protected == 'Y'
    }

  })

  .controller('NewQuestionController', function ($scope, $rootScope, $location, Poll, Question, Setting, $routeParams, flash) {
    $rootScope.PAGE = 'polls';
    Poll.get({ id: $routeParams.id }, function(data){
      $scope.poll = data
      $scope.settings = Setting.get_by_user({ id: data.user_id });
    });
    $scope.question = new Question({
      poll_id: parseInt($routeParams.id),
      title: '',
      kind: 'open',
      possible_answer_attributes: [] 
    });

    $scope.addInput = function(){
      
      $scope.question.possible_answer_attributes.push({
        title: ""
      });

    }

    $scope.save = function() {

      if($scope.newQuestion.$invalid) {
        $scope.$broadcast('record:invalid');
      } else {
        $scope.question.$save();
        $location.url('/polls/' + $routeParams.id);
      }

    };

    $scope.poll_location = function(id) {
      $location.url('/polls/' + id);
    }

    $scope.checkKind = function() {
      return $scope.question.kind == 'open'
    }

  })

  .controller('EditQuestionController', function ($scope, $rootScope, $location, Poll, Question, $routeParams, flash) {
    $rootScope.PAGE = 'polls';
    $scope.poll = Poll.get({ id: $routeParams.id });
    $scope.question = Question.get({ id: $routeParams.qid });

    $scope.addInput = function(){

      $scope.question.possible_answer.push({
        title: ""
      });

    }

    $scope.wipePossibleAnswers = function() {
      $scope.question.possible_answer.length = 0;
    }

    $scope.save = function() {
      $scope.question.$update();
      flash.success = 'You have successfully updated the question';  
      $location.url('/polls/' + $routeParams.id);
    }

    $scope.poll_location = function(id) {
      $location.url('/polls/' + id);
    }

    $scope.checkKind = function() {
      return $scope.question.kind == 'open'
    }

  })

  .controller('TakePollController', function($scope, $rootScope, $location, Poll, Question, Reply, Setting, $routeParams, flash) {
    $rootScope.PAGE = '/take-survey/:username/:id';

    Poll.get_live({ id: $routeParams.id }, function(successResult) {
      
      if(typeof successResult.title === 'undefined'){
        $scope.template = 'not-found';
      } else {
        
        if(successResult.password_protected == 'Y') {
          $scope.template = 'password';
        } else {
          $scope.template = 'take-poll';
        }

        $scope.poll = successResult;
        $scope.settings = Setting.get_by_user({ id: successResult.user_id });

      }

    });


    $scope.questions = Question.get_by_poll({ id: $routeParams.id });
    $scope.reply = new Reply({
      poll_id: parseInt($routeParams.id),
      answer_attributes: [] 
    });

  })

  .controller('SettingsController', function($scope, $rootScope, $location, Setting, User, $routeParams, flash) {
    $rootScope.PAGE = 'settings';
    $scope.user_record = User.query();

    $scope.save = function() {
      if($scope.settingsForm.$invalid) {
        $scope.$broadcast('record:invalid');
      } else {
        $scope.user_record.$update();
        flash.success = 'You have successfully updated your settings';
        $location.url('/settings/');
      }
    }

  });