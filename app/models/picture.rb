class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      record.errors[attribute] << (options[:message] || "Email incorrect")
    end
  end
end

class Picture < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  attr_accessor :image_data

  validates :email, presence: true, email: true

  before_validation :convert_data_uri_to_upload

  scope :ready, ->{where 'image IS NOT NULL'}

  def split_base64(uri_str)
    if uri_str.match(%r{^data:(.*?);(.*?),(.*)$})
      uri = Hash.new
      uri[:type] = $1 # "image/gif"
      uri[:encoder] = $2 # "base64"
      uri[:data] = $3 # data string
      uri[:extension] = $1.split('/')[1] # "gif"
      return uri
    else
      return nil
    end
  end

  def convert_data_uri_to_upload
    TPrint.log "convert_data_uri_to_upload", image_data.present?
    return unless image_data.present?
    data = split_base64(image_data)
    data_string = data[:data]
    data_binary = Base64.decode64(data_string)

    temp_img_file = Tempfile.new(["data_uri-upload", "." + data[:type].split('/').last], encoding: 'ascii-8bit')

    temp_img_file.write data_binary

    def temp_img_file.content_type
      "image/#{path.split('.').last}"
    end

    self.image = temp_img_file
    temp_img_file.unlink
    true
  end
end
