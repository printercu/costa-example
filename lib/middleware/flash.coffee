isArray = require('util').isArray

class Flash
  @KEY: '_flash'

  constructor: (@req) ->
    self = (type, message) ->
      if type and message
        self.future[type] = message
      else if type
        self.messages[type]
      else
        self.messages
    self.__proto__ = @__proto__
    self.messages  = req.session[@constructor.KEY] || {}
    self.future    = req.session[@constructor.KEY] = {}
    return self

  keep: ->
    @future[key] = message for key, message of @messages
    true

module.exports = flash = (options) ->
  options = options or {}
  safe = if options.unsafe? then !options.unsafe else true
  (req, res, next) ->
    return next() if req.flash and safe
    res.flash = req.flash = new Flash req
    next()
