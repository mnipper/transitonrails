class CirculatorVehicle < BusVehicle

  def self.handle?(type)
    %w(dc-circulator).include? type
  end

  def initialize(opts = {})
    super
    @suffix = 'circulator'
    @route_id = ''
  end

  private

  def bus_minutes
    raw_data['minutes']
  end

end
