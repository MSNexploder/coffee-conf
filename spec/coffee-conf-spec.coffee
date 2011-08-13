conf = require('../src/coffee-conf')

path = require('path')
vows = require('vows')
assert = require('assert')

vows.describe('Coffee-conf').addBatch(
  'sets default locals': ->
    config = new conf.Config
    config.run "require\nglobal\nprocess\nmodule\nconsole"

    assert.ok

  'uses given locals': ->
    a = 0
    locals = {
      foo: => a++
    }
    config = new conf.Config(locals)
    config.run "foo()"

    assert.equal a, 1


  'added default locals to given locals': ->
    locals = {
      foo: => ""
    }
    config = new conf.Config(locals)
    config.run "require\nglobal\nprocess\nmodule\nconsole\nfoo"

    assert.ok

  'does not override given locals with default locals': ->
    a = 0
    locals = {
      require: => a++
    }
    config = new conf.Config(locals)
    config.run "require()"

    assert.equal a, 1

  'returns result of given code': ->
    config = new conf.Config
    assert.equal config.run("return 1 + 1"), 2

   'uses given context': ->
     a = 0
     context = {
       foo: => a++
     }

     config = new conf.Config({}, context)
     config.run "this.foo()"

     assert.equal a, 1

  'loads config from file': ->
    a = 0
    locals = {
      foo: => a++
    }
    config = new conf.Config(locals)
    config.runFile path.join(__dirname, 'test-config.coffee')

    assert.equal a, 1

  'provides convenience method for running code': ->
    a = 0
    locals = {
      foo: => a++
    }
    conf.run "foo()", locals

    assert.equal a, 1

  'provides convenience method for executing file': ->
    'uses given context': ->
      a = 0
      context = {
        foo: => a++
      }
      conf.runFile path.join(__dirname, 'test-config-this.coffee'), {}, context

      assert.equal a, 1

).export(module)
