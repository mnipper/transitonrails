class RailBlock < BlockPresenter

  def self.handle?(type)
    ['metrorail'].include? type
  end

  def data
    block_data = super
    block_data.merge!(:type => block_type)
    block_data.merge!(:vehicles => vehicles_data)
    block_data
  end

  private

  def block_type
    'rail'
  end

  def api_name
    train = prediction_info[vehicles_key].first || {}
    train.fetch('LocationName', 'Unknown Name')
  end

  def vehicles_data
    @vehicles ||= VehiclesFactory.new({:type => block_type, 
                                       :vehicle_info => vehicle_info}).vehicles
    block_limit? ? @vehicles.take(limit) : @vehicles
  end

  def vehicle_info
    prediction_info[vehicles_key]
  end

  def vehicles_key
    'Trains'
  end

end
