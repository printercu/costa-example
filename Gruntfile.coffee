fs        = require 'fs'
path      = require 'path'

module.exports = (grunt) ->
  grunt.initConfig
    nrockets:
      dev:
        config:   'etc/nrockets'
        sources:  'app/assets/javascripts'
        targets:  'public/js'
        minify:   false
      dist:
        config:   'etc/nrockets'
        sources:  'app/assets/javascripts'
        targets:  'public/js'
        minify:   true
        tryMinified:  true

    less:
      dist:
        options:
          style: 'compressed'
        files:
          'public/css/main.css': 'app/assets/stylesheets/main.less'
      dev:
        options:
          style: 'nested'
        files:
          'public/css/main.css': 'app/assets/stylesheets/main.less'

    watch:
      options:
        interval: 1000 #5007
      compass:
        tasks: ['less:dev']
        files: 'app/assets/**/*.less'
      browser_js:
        tasks: ['nrockets:dev']
        files: [
          'app/assets/**/*.{js,coffee}'
          'etc/nrockets/*'
        ]

    versionize:
      files: [
        'public/js/main.js'
        'public/css/main.css'
      ]
      version_file: 'etc/assets_version'

    compress:
      main:
        options:
          mode: 'gzip'
        expand: true
        cwd:    'public/'
        src:    ['js/*.js', 'css/*.css']
        dest:   'public/'

  nrockets_precompile = require('nrockets/precompile')
  grunt.registerTask 'nrockets', 'Compile nrockets', (level = 'dev')->
    callback = @async()
    config = grunt.config.data.nrockets[level]
    nrockets_precompile config, callback

  grunt.registerTask 'versionize_clean', 'Remove old versions of assets', ->
    config    = grunt.config.data.versionize
    version   = fs.readFileSync(config.version_file).toString()
    re_old    = /-v[\d]+\.\w+(\.gz)?$/
    re_new    = new RegExp "-v#{version}\\.\\w+(\\.gz)?$"
    config.files.forEach (file) ->
      dir = path.dirname file
      for old_file in fs.readdirSync dir
        if re_old.test(old_file) && !re_new.test(old_file)
          old_file = path.join dir, old_file
          console.log "rm #{old_file}"
          fs.unlinkSync old_file

  grunt.registerTask 'versionize', 'Create links with version number', ->
    version   = Math.round(new Date / 1000)
    config    = grunt.config.data.versionize
    config.files.forEach (file) ->
      dst_file  = file.replace /(\.\w+)$/, "-v#{version}$1"
      console.log "#{file} -> #{dst_file}"
      fs.linkSync file, dst_file
    fs.writeFileSync config.version_file, "#{version}"

  grunt.registerTask 'fixtures', 'Load fixtures', ->
    callback = @async()
    Application = require './etc/application'
    app = new Application(root: path.resolve module.filename, '../')
    app.initialize (err) ->
      return callback err if err
      app.models.Post.loadFixtures callback

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-compress'

  grunt.registerTask 'default', [
    'less:dist'
    'nrockets:dist'
    'versionize'
    'compress'
    'fixtures'
  ]
