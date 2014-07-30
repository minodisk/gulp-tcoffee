through = require 'through2'
{PluginError, replaceExtension} = require 'gulp-util'
CoffeeScript = require 'typed-coffee-script'

PLUGIN_NAME = 'gulp-tcoffee'

module.exports = (opts) ->
  through.obj (file, enc, callback) ->
    return callback() if file.isNull()
    throw new PluginError PLUGIN_NAME, 'Not supports Stream' if file.isStream()
    throw new PluginError PLUGIN_NAME, 'Supports Buffer only' unless file.isBuffer()

    input = file.contents.toString 'utf8'
    csAst = CoffeeScript.parse input, opts.csAst
    jsAst = CoffeeScript.compile csAst, opts.jsAst
    js = CoffeeScript.js jsAst, opts.js
    file.contents = new Buffer js, 'utf8'
    file.path = replaceExtension file.path, '.js'

    @push file
    callback()
