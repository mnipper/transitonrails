# == Schema Information
#
# Table name: blocks
#
#  id          :integer          not null, primary key
#  screen_id   :integer
#  stop        :string(255)
#  custom_name :string(255)
#  column      :integer
#  position    :integer
#  custom_body :text
#  limit       :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Block < ActiveRecord::Base
  attr_accessible :stop, :custom_name, :column, :position, :custom_body, :limit

  belongs_to :screen
  has_one :agency_stop
end
