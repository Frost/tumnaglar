class Tumnaglar
  def initialize(config)
    @image_url_path = config["image_url_path"]
    @root_path = config.dragonfly["datastore_path"]
    @max_age = config.storage["max_age"]
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
    puts image.file
    return image
  end

 private

 def read_file(filename)
   image = Dragonfly.app.fetch_file(local_path(filename))
   image.data
   if stale(image)
     puts "stale cache: #{filename}"
     return nil
   else
     return image
   end
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

  def stale(image)
    ctime = File.ctime(image.path)
    ctime < Time.new - @max_age
  end
end

