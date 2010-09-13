description  'XSLT filter which transforms XML'
dependencies 'engine/filter'

class Olelo::XSLT < Filter
  def configure(options)
    super
    content = File.read(File.join(File.dirname(__FILE__), options[:stylesheet]))
    @xslt   = Nokogiri::XSLT(content)
  end

  def params(context)
    context.page.attributes.merge('title' => context.page.title, 'path' => context.page.path)
  end

  def filter(context, content)
    @xslt.apply_to(Nokogiri::XML(content, nil, 'UTF-8'),
                   Nokogiri::XSLT.quote_params(params(context)))
  end
end

Filter.register :xslt, Olelo::XSLT
