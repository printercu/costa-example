fs = require 'fs'

module.exports = (callback) ->
  fs.readFile "#{@root}/etc/assets_version", (err, data) =>
    @set 'assets_version', data?.toString()
    callback err
