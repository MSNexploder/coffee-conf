# version information
version = require('./version')
exports.package = version.package
exports.version = version.version

exports.Config = require('./config').Config

# convenience methods
#
# Executes file at given path.
# Optional specified locals and context are passed down into the executed code.
# Returns result of executed coffee code.
#
# ### Examples
#     config.runFile 'config.coffee'
#     # given file is executed using default locals and context.
#     config.runFile 'config.coffee', { foo: => bar }
#     # given file is executed using given locals.
#     config.runFile 'config.coffee', {}, { foo: => bar }
#     # given file is executed using given locals and context.
exports.runFile = (filename, locals = {}, context = {}) ->
  config = new exports.Config(locals, context)
  config.runFile filename

  # Executes given code.
  # Optional specified locals and context are passed down into the executed code.
  # Returns result of executed coffee code.
  #
  # ### Examples
  #     config.run 'return 1 + 1'
  #     # given code is executed using default locals and context.
  #     config.run 'foo()', { foo: => bar }
  #     # given code is executed using given locals.
  #     config.run 'this.foo()', {}, { foo: => bar }
  #     # given code is executed using given locals and context.
exports.run = (code, locals = {}, context = {}) ->
  config = new exports.Config(locals, context)
  config.run code
