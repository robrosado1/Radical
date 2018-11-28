require 'byebug'

class Static
  # attr_reader :app

  def initialize(app)
    @app = app
  end

  def call(env)
    regexp = Regexp.new('/public/*')
    # @app.call(env)
    dirname = __FILE__.methods
    if regexp.match(env["PATH_INFO"])
      debugger
      Rack::Response.write(File.read(env["PATH_INFO"]))
    else
      Rack::Response.write(['404', {'Content-type' => 'text/html'}, ['Could not be found']])
    end
  end
end
