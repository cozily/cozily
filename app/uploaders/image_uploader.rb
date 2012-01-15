class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file
  process :convert => :jpg

  def filename
    "original.jpg"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}_#{mounted_as}/#{model.id}"
  end

  def default_url
    "/images/defaults/#{model.class.to_s.underscore}/#{mounted_as}/#{version}.jpg"
  end

  version :micro do
    process :resize_to_fill => [32, 32]
    process :convert => :jpg
    def full_filename(for_file); "micro.jpg"; end
  end

  version :thumb do
    process :resize_to_fill => [80, 80]
    process :convert => :jpg
    def full_filename(for_file); "thumb.jpg"; end
  end

  version :medium do
    process :resize_to_fill => [115, 115]
    process :convert => :jpg
    def full_filename(for_file); "medium.jpg"; end
  end

  version :large do
    process :resize_to_fill_or_pad => [625, 440]
    process :convert => :jpg
    def full_filename(for_file); "large.jpg"; end
  end

  def resize_to_fill_or_pad(width, height)
    manipulate! do |img|
      cols, rows = img[:dimensions]
      if cols < width && rows < height
        resize_and_pad(width, height, "#f0f0f0")
      else
        resize_to_fill(width, height)
      end
    end
  end
end
