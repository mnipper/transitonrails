# == Schema Information
#
# Table name: screens
#
#  id                      :integer          not null, primary key
#  user_id                 :integer
#  monday_thursday_opening :datetime
#  monday_thursday_closing :datetime
#  friday_opening          :datetime
#  friday_closing          :datetime
#  saturday_opening        :datetime
#  saturday_closing        :datetime
#  sunday_opening          :datetime
#  sunday_closing          :datetime
#  name                    :string(255)
#  zoom                    :float
#  last_check_in           :datetime
#  latitude                :float
#  longitude               :float
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

class Screen < ActiveRecord::Base
  attr_accessible :name, :zoom, :latitude, :longitude

  belongs_to :user
  has_many :blocks




end
