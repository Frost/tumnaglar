class Tumnaglar
  def initialize(config)
    @image_url_path = config["image_url_path"]
    @root_path = config.dragonfly["datastore_path"]
    @format = 'png'
  end

  def get_image(filename)
    image = read_file(filename)
    if image.nil?
      image = Dragonfly.app.fetch_url(image_url_path(filename))
      image.name = filename(filename)
      image.
        encode(@format).
        to_file(local_path(filename))
    end
    return image
  end

 private

 def read_file(filename)
   image = Dragonfly.app.fetch_file(local_path(filename))
   image.data
   return image
 rescue => e
   puts e.backtrace
   return nil
 end

  def image_url_path(filename)
    @image_url_path + filename
  end

  def local_path(filename)
    "#{@root_path}/#{filename filename}"
  end

  def filename(filename)
    "#{filename}.#{@format}"
  end
end

