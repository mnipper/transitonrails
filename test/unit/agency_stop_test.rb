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

require 'test_helper'

class AgencyStopTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
