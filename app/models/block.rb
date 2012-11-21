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
  attr_accessible :stop, :custom_name, :column, :position, :custom_body, :limit, :agency_stop_attributes

  belongs_to :screen
  has_one :agency_stop
  accepts_nested_attributes_for :agency_stop

  delegate :agency, :stop_id, :to => :agency_stop

  after_initialize :initialize_agency_stop


  private
  
  def initialize_agency_stop
    return unless new_record?
    self.build_agency_stop if agency_stop.nil?
  end
end
