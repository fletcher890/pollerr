angular.module("PollerrApp").factory("Poll", ($resource) ->
  $resource "/api/polls/:id",
    id: "@id"
  ,
    update:
      method: "PUT"

    get_live:
      method: "GET"
      url: "/api/live-polls/:id"

    get_json:
      method: "GET"
      url: "/api/poll-json/:id"

).factory("Question", ($resource) ->
  $resource "/api/questions/:id",
    id: "@id"
  ,
    update:
      method: "PUT"

    get_by_poll:
      method: "GET"
      url: "/api/questions_by_poll/:id"
      isArray: true

).factory("PossibleAnswer", ($resource) ->
  $resource "/api/possible_answer/:id",
    id: "@id"
  ,
    update:
      method: "PUT"

    get_by_question:
      method: "GET"
      url: "/api/possible_answers_by_question/:id"
      isArray: true

).factory("Reply", ($resource) ->
  $resource "/api/reply/:id",
    id: "@id"
  ,
    update:
      method: "PUT"

).factory("Setting", ($resource) ->
  $resource "/api/setting/:id",
    id: "@id"
  ,
    update:
      method: "PUT"

    get_by_user:
      method: "GET"
      url: "/api/settings-by-user/:id"
      isArray: false

).factory("User", ($resource) ->
  $resource "/api/user/:id",
    id: "@id"
  ,
    update:
      method: "PUT"

    query:
      isArray: false

).factory "Auth", ($resource) ->
  $resource "/api/auth", {},
    login:
      method: "POST"
      url: "/api/login"
      isArray: false

    register:
      method: "POST"
      url: "/api/register"
      isArray: false

