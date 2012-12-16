# == Schema Information
#
# Table name: agency_stops
#
#  id         :integer          not null, primary key
#  block_id   :integer
#  agency     :string(255)
#  stop_id    :string(255)
#  exclusions :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AgencyStop < ActiveRecord::Base
  attr_accessible :agency, :stop_id, :exclusions
  validates_inclusion_of :agency, :in => AGENCIES

  belongs_to :block
end
