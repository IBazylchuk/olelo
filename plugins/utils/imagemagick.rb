description 'ImageMagick'
dependencies 'utils/shell', 'utils/semaphore'

class Olelo::ImageMagick < Olelo::Shell
  def self.semaphore
    @semaphore ||= Semaphore.new
  end

  def initialize
    if (`gm -version` rescue '').include?('GraphicsMagick')
      @prefix = 'gm'
    elsif !(`convert -version` rescue '').include?('ImageMagick')
      raise 'GraphicsMagick or ImageMagick not found'
    end
  end

  def method_missing(name, *args, &block)
    if %w(convert identify).include?(name.to_s)
      super(@prefix, name, *args, &block)
    else
      super
    end
  end

  def self.run(cmd, data)
    semaphore.synchronize { super }
  end
end
