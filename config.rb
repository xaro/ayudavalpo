activate :livereload

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
  activate :relative_assets
end

set :protocol, "http://"
set :host, "ayudavalpo.com/"
set :port, 80

helpers do
  def host_with_port
    [host, optional_port].compact.join(':')
  end

  def optional_port
    port unless port.to_i == 80
  end

  def image_url(source)
    protocol + host_with_port + image_path(source)
  end
end

configure :development do
  # Used for generating absolute URLs
  set :host, Middleman::PreviewServer.host
  set :port, Middleman::PreviewServer.port
end

# Compile coffeescript without encapsulating each file in a function
CoffeeScript.class_eval do
  class << self
    def compile_with_bare(*args)
      options = args.pop if args.last.is_a?(Hash)
      (options ||= {})[:bare] = true
      args << options
      compile_without_bare(*args)
    end

    alias_method :compile_without_bare, :compile
    alias_method :compile, :compile_with_bare
  end
end
