class Tumnaglar
  def initialize(config)
    @image_url_path = config["image_url_path"]
    @root_path = config.dragonfly["datastore_path"]
    @format = 'png'
  end

  def get_image(username)
    image = read_file(username)
    if image.nil?
      image = Dragonfly.app.fetch_url(image_url_path(username))
      image.name = filename(username)
      image.
        encode(@format).
        to_file(local_path(username))
    end
    return image
  end

 private

 def read_file(username)
   image = Dragonfly.app.fetch_file(local_path(username))
   image.data
   return image
 rescue => e
   puts e.backtrace
   return nil
 end

  def image_url_path(username)
    @image_url_path + username
  end

  def local_path(username)
    "#{@root_path}/#{filename username}"
  end

  def filename(username)
    "#{username}.#{@format}"
  end
end

