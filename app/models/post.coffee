marked  = require 'marked'
hljs    = require 'highlight.js'
_       = require 'lodash'

module.exports =
class Post extends require './base_record'
  @extendsWithProto()

  @include require './concerns/with_fixtures'

  @MARKED_OPTIONS =
    highlight: (code, lang) ->
      code = 'coffeescript' if code is 'coffee'
      try
        return hljs.highlight(lang, code).value
      catch error
        return hljs.highlightAuto(code).value

  @exportAttrs 'body', 'body_md', 'title', 'created_at'

  @validatesPresenceOf 'body_md', 'title'

  @beforeCreate (callback) ->
    @created_at = new Date
    callback()

  @beforeSave (callback) ->
    @compileBody()
    callback()

  @all: (callback) ->
    @maxId (err, max_id) =>
      return callback err if err
      @getMulti [1..max_id], (err, items) ->
        return callback err if err
        callback err, _.compact items

  compileBody: ->
    @body = marked @body_md, @constructor.MARKED_OPTIONS
