require 'json'

class Session

  def initialize(req)
    @req = req
    cookie = @req.cookies['_rails_lite_app']
    @session_cookie = cookie.nil? ? {} : JSON.parse(cookie)
  end

  def [](key)
    @session_cookie[key]
  end

  def []=(key, val)
    @session_cookie[key] = val
  end

  def store_session(res)
    res.set_cookie('_rails_lite_app', {path: '/', value: @session_cookie.to_json})
  end
end
