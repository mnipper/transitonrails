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
  require 'yajl'

  attr_accessible :stop, :custom_name, :column, :position, :custom_body, :limit, :agency_stop_attributes

  belongs_to :screen
  has_one :agency_stop
  accepts_nested_attributes_for :agency_stop

  delegate :agency, :stop_id, :to => :agency_stop

  after_initialize :initialize_agency_stop

  RAIL_PREDICTION_URL = 'http://api.wmata.com/StationPrediction.svc/json/GetPrediction'
  RAIL_INFO_URL = 'http://api.wmata.com/Rail.svc/json/JStationInfo'
  BUS_PREDICTION_URL = ' http://api.wmata.com/NextBusService.svc/json/JPredictions'

  def rail_prediction
    url = [RAIL_PREDICTION_URL, stop_id].join('/')
    prediction_info = Yajl::Parser.parse(RestClient.get(url, api_key_params))
  end

  def rail_station_info
    params_hash = {:params => {:StationCode => stop_id, :api_key => screen.user.wmata_key}}
    station_info = Yajl::Parser.parse(RestClient.get(RAIL_INFO_URL, params_hash))
  end

  def bus_prediction
    params_hash = {:params => {:StopID => stop_id, :api_key => screen.user.wmata_key}}
    prediction_info = Yajl::Parser.parse(RestClient.get(BUS_PREDICTION_URL, params_hash))
  end


  private

  def api_key_params
    @api_key_params ||= {:params => {:api_key => screen.user.wmata_key}}
  end
  
  def initialize_agency_stop
    return unless new_record?
    self.build_agency_stop if agency_stop.nil?
  end
end
