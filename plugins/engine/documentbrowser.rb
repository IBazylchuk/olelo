description 'Document browser engine'
dependencies 'engine/engine', 'utils/shell'

Engine.create(:documentbrowser, :priority => 1, :layout => true, :cacheable => true, :accepts => 'application/pdf|postscript') do
  def count_pages
    content = @page.content
    if @page.mime == 'application/pdf'
      last_page = -1
      content.scan %r{/Type\s*/Pages.*?/Count\s*(\d+)}m do
        last_page += $1.to_i
      end
    else
      content = Shell.cmd($1 == 'gz' ? 'gunzip' : 'bunzip2').run(content) if @page.mime.to_s =~ /(gz|bz)/
      last_page = $1.to_i - 1 if content =~ /^%%Pages:\s+(\d+)$/
    end
    @last_page = [last_page, 0].max
  end

  def output(context)
    @page = context.page
    @page_nr = context.params[:page].to_i
    count_pages
    render :browser
  end
end

__END__

@@ browser.haml
!= pagination(page_path(@page), @last_page, @page_nr, :output => 'documentbrowser')
%p
  %img{:src=> page_path(@page, :output => 'image', :geometry => '480x>', :trim => 1, :page => @page_nr)}
!= pagination(page_path(@page), @last_page, @page_nr, :output => 'documentbrowser')
%h3= :information.t
%table.zebra
  %tbody
    %tr
      %td= :name.t
      %td= @page.name
    %tr
      %td= :title.t
      %td= @page.title
    - if @page.version
      %tr
        %td= :last_modified.t
        %td!= date @page.version.date
      %tr
        %td= :version.t
        %td.version= @page.version
    %tr
      %td= :type.t
      %td #{@page.mime.comment} (#{@page.mime})
    %tr
      %td= :download.t
      %td
        %a{:href=> page_path(@page, :output => 'download')}= :download.t
