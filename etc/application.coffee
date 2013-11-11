CostaApplication = require 'costa/core/application'
module.exports = class ExampleApplication extends CostaApplication
  @extendsWithProto()

  initBlocks: [
    'autoload'
    'loadInitializers'
    'initDatabase'
    'initMiddleware'
  ]

  initDatabase: (callback) ->
    BaseRecord = require "#{@root}/app/models/base_record"

    kv = require('redis').createClient()
    process.on 'exit', -> kv.quit()
    BaseRecord.include require 'costa/record/connectors/redis'
    @set 'kv', kv
    BaseRecord.kv = kv

    callback()
