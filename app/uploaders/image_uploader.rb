class ImageUploader < CarrierWave::Uploader::Base
  include PublicUploader
  include CarrierWave::RMagick
  include CarrierWave::Meta
  include Sprockets::Rails::Helper

  process store_meta: [{md5sum: true}]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}/"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    if original_filename
      # hash = Digest::MD5.hexdigest(File.dirname(current_path))
      name = file.basename.split('_').last.gsub(/\.$/, '')
      # ["#{name}-#{hash}", file.extension].compact.select(&:present?).join('.')
      [name, file.extension].compact.select(&:present?).join('.')
    end
  end

  version :thumb do
    process resize_to_fit: [60, 60]
  end

  version :small do
    process resize_to_fill: [200, 200]
  end
end
