angular.module('pollerApp')
  .factory('Poll', function($resource) {
    return $resource('/api/polls/:hash', {hash: '@id'}, {
      'update'	: { method: 'PUT', url: '/apis/polls/:id' },
      'delete'	: { method: 'DELETE', url: '/apis/polls/:hash', params: { hash: '@id' } }
    });
  });