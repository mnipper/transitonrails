class BusVehicle < Vehicle

  def self.handle?(type)
    ['bus'].include? type
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
    raw_data['DirectionText'] 
  end 

  def bus_minutes
    raw_data['Minutes']
  end

  def bus_route_id
    raw_data['RouteID']
  end


end
