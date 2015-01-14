angular.module('PollerrApp')
  .factory('Poll', function($resource) {
    return $resource('/api/polls/:id', { id: '@id' }, {
      'update'  : { method: 'PUT' },
      'get_live'  : { method: 'GET', url: '/api/live-polls/:id' },
      'get_json'	: { method: 'GET', url: '/api/poll-json/:id' }
    });
  })
  .factory('Question', function($resource) {
    return $resource('/api/questions/:id', { id: '@id' }, {
      'update'  : { method: 'PUT' },
      'get_by_poll' : { method: 'GET', url: '/api/questions_by_poll/:id', isArray: true }
    });
  })
  .factory('PossibleAnswer', function($resource) {
    return $resource('/api/possible_answer/:id', { id: '@id' }, {
      'update'  : { method: 'PUT' },
      'get_by_question' : { method: 'GET', url: '/api/possible_answers_by_question/:id', isArray: true }
    });
  })
  .factory('Reply', function($resource) {
    return $resource('/api/reply/:id', { id: '@id' }, {
      'update'  : { method: 'PUT' }
    });
  })
  .factory('Setting', function($resource) {
    return $resource('/api/setting/:id', { id: '@id' }, {
      'update'  : { method: 'PUT' },
      'get_by_user' : { method: 'GET', url: '/api/settings-by-user/:id', isArray: false }
    });
  })
  .factory('User', function($resource) {
    return $resource('/api/user/:id', { id: '@id' }, {
      'update'  : { method: 'PUT' },
      'query': { isArray: false }
    });
  })
  .factory('Auth', function($resource) {
    return $resource('/api/auth', {}, {
      'login' : { method: 'POST', url: '/api/login', isArray: false },
      'register' : { method: 'POST', url: '/api/register', isArray: false }
    });
  });