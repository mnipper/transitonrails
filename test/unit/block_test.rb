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

require 'test_helper'

class BlockTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
