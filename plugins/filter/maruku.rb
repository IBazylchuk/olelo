description  'Maruku/Markdown text filter'
dependencies 'engine/filter'
require      'maruku'

Filter.create :maruku do |context, content|
  Maruku.new(content).to_html
end
