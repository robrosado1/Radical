class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
      pattern, http_method, controller_class, action_name
  end

  def matches?(req)
    (req.path =~ @pattern) && (req.request_method == @http_method.to_s.upcase)
  end

  def run(req, res)
    regex = Regexp.new(@pattern)
    route_params = req.path.match(regex)
    route_params = route_params.names.zip(route_params.captures).to_h
    klass = @controller_class.new(req, res, route_params)
    klass.invoke_action(@action_name)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    self.instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    route = @routes.find {|route| route.matches?(req) }
  end

  def run(req, res)
    match = self.match(req)
    match.nil? ? res.status = "404: No route matches" : match.run(req, res)
  end
end
