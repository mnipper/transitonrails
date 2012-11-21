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
  attr_accessible :name, :zoom, :latitude, :longitude, :monday_thursday_opening,
  :monday_thursday_closing, :friday_opening, :friday_closing, :saturday_opening,
  :saturday_closing, :sunday_opening, :sunday_closing, :blocks_attributes

  belongs_to :user
  has_many :blocks
  has_many :agency_stops, :through => :blocks
  accepts_nested_attributes_for :blocks, :agency_stops

  after_initialize :assign_default_times

  %w(monday_thursday friday saturday sunday).each do |day_of_week|
    %w(_opening _closing).each do |time_of_day|
      method_name = (day_of_week + time_of_day).to_sym
      send :define_method, method_name do
        read_attribute(method_name).strftime('%I:%M %p')
      end
    end
  end

  private

  def assign_default_times
    return unless new_record?
    Time.zone = 'EST'
    self.monday_thursday_opening = '05:30 AM' if read_attribute(:monday_thursday_opening).nil?
    self.monday_thursday_closing = '12:00 AM' if read_attribute(:monday_thursday_closing).nil?
    self.friday_opening = '05:30 AM' if read_attribute(:friday_opening).nil?
    self.friday_closing = '03:00 AM' if read_attribute(:friday_closing).nil?
    self.saturday_opening = '07:00 AM' if read_attribute(:saturday_opening).nil?
    self.saturday_closing = '03:00 AM' if read_attribute(:saturday_closing).nil?
    self.sunday_opening = '07:00 AM' if read_attribute(:sunday_opening).nil?
    self.sunday_closing = '12:00 AM' if read_attribute(:sunday_closing).nil?
    if self.blocks.empty?
      8.times do
        self.blocks.build
      end
    end
    return true
  end




end
