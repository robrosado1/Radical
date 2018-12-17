require 'active_support'
require 'active_support/inflector'
require 'active_support/core_ext'
require 'erb'
require 'byebug'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, params = {})
    @params = params.merge(req.params)
    @req = req
    @res = res
    @already_built_response = false
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    if already_built_response?
      raise "Double Redirect Error"
    else
      @already_built_response = true
      res.set_header('Location', url)
      res.status = 302
    end
    @session.store_session(@res)
  end

  def render_content(content, content_type)
    if already_built_response?
      raise "Double Render Error"
    else
      @already_built_response = true
      res['Content-Type'] = content_type
      res.write(content)
    end
    @session.store_session(@res)
  end

  def render(template_name)
    dir = "views/#{self.class.to_s.underscore}/#{template_name}.html.erb"
    template = File.read(dir)
    content = ERB.new(template).result(binding)
    render_content(content, 'text/html')
  end

  def session
    @session ||= Session.new(@req)
  end

  def invoke_action(name)
    self.session
    self.send(name)
    render(name) unless already_built_response?
  end
end
