class RailVehicle < Vehicle

  def self.handle?(type)
    %w(rail).include? type
  end

  def initialize(opts = {})
    super
    @suffix = rail_suffix 
    @destination = rail_destination
    @minutes = rail_minutes
    @route_id = rail_route_id
  end


  private

  def rail_suffix
    rail_suffix_lut[rail_route_id]
  end 

  def rail_route_id
    @rail_route_id ||= raw_data['Line']
  end

  def rail_suffix_lut
    @rails_suffix_lut ||= {'RD' => 'red',
      'OR' => 'orange',
      'YL' => 'yellow',
      'GR' => 'green',
      'BL' => 'blue'}
  end

  def rail_destination
    friendly_station_name_lut[raw_data['DestinationName']] || raw_data['DestinationName']
  end

  def friendly_station_name_lut
    @friendly_station_name_lut ||= {
      'NewCrltn' => 'New Carrollton',
      'W Fls Ch' => 'west Falls Church',
      'Frnconia' => 'Franconia-Springfield',
      'Grosvenor-Strathmore' => 'Grosvenor',
      'VanNess' => 'Van Ness'
    }
  end

  def rail_minutes
    raw_data['Min']
  end

end
