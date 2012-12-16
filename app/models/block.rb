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
  require 'open-uri'

  attr_accessible :stop, :custom_name, :column, :position, :custom_body, :limit, :agency_stop_attributes

  belongs_to :screen
  has_one :agency_stop
  accepts_nested_attributes_for :agency_stop

  delegate :agency, :stop_id, :to => :agency_stop

  after_initialize :initialize_agency_stop

  RAIL_PREDICTION_URL = 'http://api.wmata.com/StationPrediction.svc/json/GetPrediction'
  RAIL_INFO_URL = 'http://api.wmata.com/Rail.svc/json/JStationInfo'
  BUS_PREDICTION_URL = 'http://api.wmata.com/NextBusService.svc/json/JPredictions'
  CABI_PREDICTION_URL = 'http://www.capitalbikeshare.com/stations/bikeStations.xml'
  ART_PREDICTION_URL = 'http://realtime.commuterpage.com/RTT/Public/Utility/File.aspx?ContentType=SQLXML&Name=RoutePositionET.xml'



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

  #Calls Route cor CaBi station information
  #
  # @return [ String ] id The id of the station
  # @return [ String ] name The name of the station
  # @return [ String ] terminalName number associated with station (31505)
  # @return [ String ] nbBikes Number of available bikes
  # @return [ String ] nbEmptyDocks Number of empty docks
  #
  def cabi_prediction_info
      station = Nokogiri::XML(open(CABI_PREDICTION_URL)).css("stations station id:contains('#{stop_id}')").first.parent
      station.children.inject({}) { |m, child| m[child.name] = child.content; m }
  end

  #TODO: When buses are actually running put this back in with correct attributes
  def art_prediction_info
    station = Nokogiri::XML(open("http://realtime.commuterpage.com/RTT/Public/Utility/File.aspx?ContentType=SQLXML&Name=RoutePositionET.xml&PlatformTag=#{stop_id}"))
    station.children.inject({}) { |m, child| m[child.name] = child.content; m }
    {}
  end

  def dc_circulator_prediction_info
    station = Nokogiri::XML(open("http://webservices.nextbus.com/service/publicXMLFeed?command=predictions&a=dc-circulator&stopId=#{stop_id}"))
    station.search('predictions').inject([]) { |m, prediction| m << format_circulator_prediction(prediction); m }.first
  end

  def format_circulator_prediction(prediction)
    stop_name = prediction.attributes['stopTitle'].value
    route_name = prediction.attributes['routeTitle'].value
    routes = prediction.search('direction').inject([]) do |m, dir|
      destination = dir.attributes['title'].value
      m << {:vehicles => dir.search('prediction').inject([]) do |vehicle_array, vehicle|
                            vehicle_array << vehicle.attributes.inject({}) do |arr, (k,v)|
                              arr[k] = v.value
                              arr
                            end.merge!({'DirectionText' => destination, 'RouteID' => route_name})
                            vehicle_array
                          end
           }
    end
    formatted = {'StopName' => stop_name,
                 'RouteName' => route_name,
                 'Predictions' => routes.first[:vehicles] }
    formatted
  end

  def stop_info
    send("#{agency_method}_stop_info")
  end

  def prediction_info
    send("#{agency_method}_prediction_info")
  end

  def agency_method
    agency.gsub('-','_')
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
