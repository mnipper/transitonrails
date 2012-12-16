class VehiclesFactory
  attr_reader :vehicle_type

  def initialize(opts = {})
    @vehicle_type = opts[:type] ||= 'custom'
    vehicles_info = opts[:vehicle_info] ||= []
    @vehicles = vehicles_info.inject([]) do |arr, raw_data| 
      vehicle_data = Vehicle.build({:type => vehicle_type, :raw_data => raw_data}).data
      arr << vehicle_data unless vehicle_data.nil?
      arr
    end
    @unique_key = opts[:unique_key]
  end

  def vehicles
    if unique_key
      unique_vehicles_with_upcoming_listed
    else
      @vehicles
    end
  end

  private

  def unique_key
    @unique_key
  end

  def unique_vehicles
    if unique_key
      @unique_vehicles ||= @vehicles.uniq { |v| v[unique_key] }
    else
      vehicles
    end
  end

  def removed_vehicles
    @vehicles - unique_vehicles
  end

  def unique_vehicles_with_upcoming_listed
    unique_vehicles.each do  |vehicle| 
      vehicle[:upcoming_vehicles] = removed_vehicles.first(2).collect { |v| v[:minutes] }
    end
  end

end
