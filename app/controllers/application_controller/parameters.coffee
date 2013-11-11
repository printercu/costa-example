Args = require 'costa/support/args'

module.exports =
class Parameters extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  params: ->
    return {} unless @req?.body
    [options, fields] = Args.findOptions arguments
    result = {}
    for field in fields
      if @req.body[field]?
        result[field] = @req.body[field]
    result

  fileParam: (field) ->
    file = @req.files[field]
    file if file?.size
