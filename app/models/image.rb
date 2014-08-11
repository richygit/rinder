class Image < ActiveRecord::Base
  
  def self.next_image(user)
    return nil if user.nil?
    Image.joins("LEFT JOIN votes ON votes.image_id = images.id and votes.user_id = #{Image.sanitize(user.name)}").where("votes.id IS NULL").order('rand()').first
  end
end
