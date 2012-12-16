class Vehicle
  attr_reader :suffix, :destination, :minutes, :route_id, :upcoming_vehicles
  DESCENDANTS = [BusVehicle, RailVehicle, CirculatorVehicle]

  def self.build(opts = {})
    klass = DESCENDANTS.detect { |descendant| descendant.handle?(opts[:type]) }
    klass.new(opts)
  end

  def initialize(opts = {})
    @raw_data = opts[:raw_data]
    @suffix = ''
    @destination = 'Unknown'
    @minutes = ''
    @route_id = '--'
    @upcoming_vehicles = []
  end

  def data
    minutes.blank? ? nil : to_hash
  end

  private

  def to_hash
    {
      :suffix => suffix,
      :destination => destination,
      :minutes => minutes,
      :route_id => route_id,
      :upcoming_vehicles => upcoming_vehicles
    }
  end

  def raw_data
    @raw_data
  end

end


