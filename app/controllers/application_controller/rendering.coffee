lingo = require 'lingo'

module.exports =
class Rendering extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    Object.defineProperty @::, 'viewPath',
      get: ->
        return @_viewPath if @hasOwnProperty '_viewPath'
        mod = if matched = /(\w+)Controller/.exec @name
          lingo.underscore matched[1]
        else
          '_global'
        @_viewPath = mod
      set: (val) -> @_viewPath = val

  render: (data = {}) ->
    data.flash = @req.flash
    @res.render "#{@constructor.viewPath}/#{@action}", data
