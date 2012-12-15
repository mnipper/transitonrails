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
  BUS_PREDICTION_URL = 'http://api.wmata.com/NextBusService.svc/json/JPredictions'


  #Calls WMATA Route for MetroRail Info
  #
  # @return [Array of Hashes] Trains
  #   Car [ String ] Number of cars (i.e. "8")
  #   Destination [ String ] Destination Name (i.e "Glenmont")
  #   DesinationCode [ String ]
  #   DestinationName [ String ]
  #   Group [ String ]
  #   Line [ String ] Code of station color (i.e. "RD")
  #   LocationCode [ String ] Code of location of this stop
  #   LocationName [ String ] Name of location of this stop
  #   Min [  String ] How many minutes away it is:w
  #
  def metrorail_prediction_info
    url = [RAIL_PREDICTION_URL, stop_id].join('/')
    prediction_info = Yajl::Parser.parse(RestClient.get(url, api_key_params))
  end

  #Calls WMATA Route for MetroRail Info
  #
  # @return [ String ] Code String of station code (i.e "B35")
  # @return [ String ] Lat Latitude of station
  # @return [ String ] Lon Longitude of station
  # @return [ String ] LineCode1/2/3/4 Code of station (i.e. "RD")
  # @return [ String ] Name Name of station (i.e. "New York Avenue")
  # @return [ String ] StationTogether1/2
  #
  def metrorail_stop_info
    params_hash = {:params => {:StationCode => stop_id, :api_key => screen.user.wmata_key}}
    station_info = Yajl::Parser.parse(RestClient.get(RAIL_INFO_URL, params_hash))
  end

  #Calls WMATA Route for Bus Prediction
  #
  # @return [ Array of Hashes ] Predictions
  #   DirectionNum [String] "1"
  #   DirectionText [String] "South to Congress Heights Station"
  #   Minutes [ Integer ] Number of minute until it arrives
  #   RouteID [ String ] String of Route Number (i.e. "92")
  #   VehicleID [ String ] String of Vehicle Number
  # @return [ String ] StopName Name of the stop (i.e. "Florida Ave + N Capitol St")
  #
  def metrobus_prediction_info
    params_hash = {:params => {:StopID => stop_id, :api_key => screen.user.wmata_key}}
    prediction_info = Yajl::Parser.parse(RestClient.get(BUS_PREDICTION_URL, params_hash))
  end

  def cabi_prediction_info
    {}
  end

  def stop_info
    send("#{agency}_stop_info")
  end

  def prediction_info
    send("#{agency}_prediction_info")
  end

  def column
    read_attribute(:column) || 1
  end

  def position
    read_attribute(:position) || 1
  end


  private

  def api_key_params
    {:params => {:api_key => screen.user.wmata_key}}
  end
  
  def initialize_agency_stop
    return unless new_record?
    self.build_agency_stop if agency_stop.nil?
  end
end
