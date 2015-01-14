angular.module("PollerrApp").filter("labelCase", ->
  (input) ->
    input = input.replace(/([A-Z])/g, " $1")
    input = input.replace(/_/g, " ")
    input[0].toUpperCase() + input.slice(1)
).filter "camelCase", ->
  (input) ->
    input.toLowerCase().replace RegExp(" (\\w)", "g"), (match, letter) ->
      letter.toUpperCase()