ActionController = require 'costa/action_controller'

module.exports =
class ApplicationController extends ActionController
  @extendsWithProto()

  @abstract: true

  @includeAll module, prefix: './application_controller',
    'rendering'
    'parameters'
