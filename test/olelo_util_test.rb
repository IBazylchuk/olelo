require 'cgi'
require 'digest/md5'
require 'digest/sha2'
require 'open3'
require 'olelo/extensions'
require 'olelo/util'

describe 'Olelo::Util' do
  it 'should have #check' do
    Olelo::Util.check do |errors|
      # do nothing
    end
    lambda do
      Olelo::Util.check do |errors|
        errors << 'Error 1'
        errors << 'Error 2'
      end
    end.should.raise Olelo::MultiError
  end

  it 'should have #escape which escapes space as %20' do
    Olelo::Util.escape('+@ ').should.equal '%2B%40%20'
  end

  it 'should have #unescape which does not unescape +' do
    Olelo::Util.unescape('+%20+').should.equal '+ +'
  end

  it 'should have #escape_html' do
    Olelo::Util.escape_html('<').should.equal '&lt;'
  end

  it 'should have #unescape_html' do
    Olelo::Util.unescape_html('&lt;').should.equal '<'
  end

  it 'should have #escape_json' do
    Olelo::Util.escape_json('a&b<c>').should.equal 'a\u0026b\u003Cc\u003E'
  end

  it 'should have #md5' do
    Olelo::Util.md5('test').should.equal '098f6bcd4621d373cade4e832627b4f6'
  end

  it 'should have #sha256' do
    Olelo::Util.sha256('test').should.equal '9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08'
  end

  it 'should have #build_query' do
    Olelo::Util.build_query(:a => 1, :b => [1, 2, 3]).should.equal 'a=1&b=1&b=2&b=3'
  end
end
