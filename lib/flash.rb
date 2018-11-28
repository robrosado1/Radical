require 'json'

class Flash
  attr_reader :now

  def initialize(req)
    cookie = req.cookies['_rails_lite_app_flash']
    @now = cookie.nil? ? {} : JSON.parse(cookie)
    @flash_cookie = {}
  end

  def [](key)
    debugger
    @now[key.to_s] || @flash_cookie[key.to_s]
    debugger
  end

  def []=(key, value)
    @flash_cookie[key.to_s] = value
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_app_flash', path: '/', value: @flash_cookie.to_json)
  end

end
