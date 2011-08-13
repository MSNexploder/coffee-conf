fs = require 'fs'
path = require 'path'
coffee = require 'coffee-script'

class exports.Config

  # Creates new config reader.
  # Given locals and context are passed down to the executed code.
  #
  # locals are available as top-level objects.
  # The context is available as `this`.
  # Basic top-level objects like `require`, `process` or `console` are passed in automatically.
  constructor: (@locals = {}, @context = {}) ->
    for key, value of default_locals
      @locals[key] ?= value

  # Executes file at given path
  # Returns result of executed coffee code.
  runFile: (file) ->
    @locals.__filename = path.join(process.cwd(), file)
    @locals.__dirname = process.cwd()
    @locals.module.filename = @locals.__filename
    code = @readAndCompile file
    @run code

  # Executes given code.
  # Returns result of executed coffee code.
  run: (code) -> @defineWith code

  readAndCompile: (file) ->
    code = @read file
    coffee.compile code

  read: (file) -> fs.readFileSync file, 'utf8'

  defineWith: (code) ->
    @scoped(code)(@context, @locals)

  scoped: (code) ->
    code = String(code)
    code = "function () {#{code}}" unless code.indexOf('function') is 0
    code = "#{coffeescript_support} with(locals) {return (#{code}).apply(context, args);}"
    new Function('context', 'locals', 'args', code)

coffeescript_support = """
  var __slice = Array.prototype.slice;
  var __hasProp = Object.prototype.hasOwnProperty;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  var __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype;
    return child;
  };
  var __indexOf = Array.prototype.indexOf || function(item) {
    for (var i = 0, l = this.length; i < l; i++) {
      if (this[i] === item) return i;
    }
    return -1;
  };
"""

default_locals = {
  require: require
  global: global
  process: process
  module: module
  console: console
}
