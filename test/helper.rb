require 'rack/patches'
require 'olelo'
require 'bacon'
require 'rack/test'

module TestHelper
  def load_plugin(*plugins)
    Olelo::Plugin.logger = Logger.new(File.expand_path(File.join(File.dirname(__FILE__), '..', 'test.log')))
    Olelo::Plugin.dir = File.expand_path(File.join(File.dirname(__FILE__), '..', 'plugins'))
    Olelo::Plugin.load(*plugins)
  end

  def create_repository
    Olelo::Repository.instance = nil
    Olelo::Config['repository.type'] = 'git'
    Olelo::Config['repository.git.path'] = File.expand_path(File.join(File.dirname(__FILE__), '.test'))
    Olelo::Config['repository.git.bare'] = true
    load_plugin('repository/git/repository')
  end

  def destroy_repository
    Olelo::Repository.instance = nil
    FileUtils.rm_rf(Olelo::Config.repository.git.path)
  end

  def create_page(name, content = 'content')
    p = Olelo::Page.new(name)
    Olelo::Page.transaction 'comment' do
      p.content = content
      p.save
    end
  end
end

class Bacon::Context
  include TestHelper
end
