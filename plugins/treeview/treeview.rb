description    'Tree Viewer'
dependencies   'engine/engine', 'utils/assets'
export_scripts '*.js', '*.css'
export_assets  'images/*'
require        'yajl/json_gem'

Engine.create('treeview.json', :hidden => true, :cacheable => true, :mime => 'application/json; charset=utf-8') do
  def output(context)
    # Format [[has-children, classes, path, name], ...]
    # Example: [[0, 'file-type-pdf', '/a/b.pdf', 'b.pdf'], ...]
    context.page.children.map do |child|
      classes = child.children.empty? ? 'page' : 'tree'
      classes << " file-type-#{child.extension.downcase}" if !child.extension.empty?
      [child.children.empty? ? 0 : 1, classes, page_path(child), child.name]
    end.to_json
  end
end
