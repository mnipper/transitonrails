class Vehicles
  attr_reader :vehicle_type

  def initialize(vehicle_type, vehicles = [])
    @vehicle_type = vehicle_type
    @vehicles = vehicles.inject([]) { |m, v| m << format_vehicle_data(v); m }.compact
  end

  def vehicles
    if vehicle_type == 'bus'
      uniq_vehicles = @vehicles.uniq { |v| v[:destination] }
      other_vehicles = @vehicles - uniq_vehicles
      uniq_vehicles.each do  |vehicle| 
        vehicle[:upcoming_vehicles] = vehicle_minutes(other_vehicles, 2, vehicle[:destination])
      end
      uniq_vehicles
    else
      @vehicles
    end
  end

  private

  def vehicle_minutes(vehicles, limit = 2, destination)
    if destination
      vehicles = vehicles.select{ |v| v[:destination] == destination }
    end
    vehicles.first(limit).collect { |v| v[:minutes] }
  end


  def format_vehicle_data(info)
    vehicle = {}
    vehicle.merge!(vehicle_information(info))
    vehicle.merge!(:upcoming_vehicles => [])
    vehicle[:minutes].blank? ? nil : vehicle
  end


  def vehicle_information(info)
    if vehicle_type == 'bus'
      data = {:suffix => 'wmata',
              :destination => info['DirectionText'],
              :minutes => info['Minutes'],
              :route_id => info['RouteID']}
    elsif vehicle_type == 'rail'
      data = {:suffix => rails_suffix_lut[info['Line']],
              :destination => friendly_station_name_lut[info['DestinationName']] || info['DestinationName'],
              :minutes => info['Min'],
              :route_id => info['Line']}
    else 
      data = {:suffix => '',
              :destination => 'Unknown Destination',
              :minutes => '',
              :route_id => '--'}
    end
    data
  end

  def rails_suffix_lut
    @rails_suffix_lut ||= {'RD' => 'red',
      'OR' => 'orange',
      'YL' => 'yellow',
      'GR' => 'green',
      'BL' => 'blue'}
  end

  def friendly_station_name_lut
    @friendly_station_name_lut ||= {
      'NewCrltn' => 'New Carrollton',
      'W Fls Ch' => 'west Falls Church',
      'Frnconia' => 'Franconia-Springfield',
      'Grosvener-Strathmore' => 'Grosvener'
    }
  end

end
