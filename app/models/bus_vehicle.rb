class BusVehicle < Vehicle

  def self.handle?(type)
    %w(metrobus art).include? type
  end

  def initialize(opts = {})
    super
    @suffix = 'wmata'
    @destination = bus_destination
    @minutes = bus_minutes
    @route_id = bus_route_id
  end

  private

  def bus_destination 
    destination_data = raw_data['DirectionText'] 
    direction = format_bus_direction(destination_data);
    location = format_bus_location(destination_data);
    {:direction => direction,
     :dest_location => location}
  end 

  def format_bus_direction(string)
    direction = string.downcase.match(/south|east|north|west/)[0]
    case(direction)
    when 'south' then 'Southbound'
    when 'north' then 'Northbound'
    when 'east' then  'Eastbound'
    when 'west' then  'WestBound'
    else ''
    end
  end

  def format_bus_location(string)
    string.gsub(location_strings, '')
  end

  def location_strings
    /South to|North to|West to|East to|Southbound|Northbound|Eastbound|Westbound/
  end

  def bus_minutes
    raw_data['Minutes']
  end

  def bus_route_id
    raw_data['RouteID']
  end


end
