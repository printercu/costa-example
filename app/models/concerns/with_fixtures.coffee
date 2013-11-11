fs    = require 'fs'
path  = require 'path'
flow  = require 'flow-coffee'
yaml  = require 'js-yaml'

module.exports =
class WithFixtures extends require('coffee_classkit').Module
  @extendsWithProto().concern()

  class @ClassMethods
    # TODO: fix this
    Object.defineProperty @::, 'fixturesDir',
      get: ->
        path.join path.resolve(module.filename, '../../../'), 'fixtures', @name.toLowerCase()

    loadFixtures: (callback) ->
      dir = @fixturesDir
      do new flow
        error: callback
        context: @
        blocks: [
          (next) -> fs.readdir dir, next
          (files, next) ->
            next.expectMulti()
            for file in files
              do (file, file_cb = next.multi()) =>
                @loadFixtureFromFile path.join(dir, file), file_cb
          -> callback?()
        ]
      @

    loadFixtureFromFile: (file, callback) ->
      fs.readFile file, (err, data) =>
        return callback err if err
        attrs = yaml.safeLoad data.toString()
        @create attrs, callback
      @
