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
    prediction_info[vehicles_key].first.fetch('LocationName')
  end

  def vehicles_data
    VehiclesFactory.new({:type => block_type, 
                         :vehicle_info => vehicle_info}).vehicles
  end

  def vehicle_info
    prediction_info[vehicles_key]
  end

  def vehicles_key
    'Trains'
  end

end
