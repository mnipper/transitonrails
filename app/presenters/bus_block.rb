class BusBlock < BlockPresenter

  def self.handle?(type)
    ['metrobus', 'art', 'dc-circulator'].include? type
  end

  def data
    block_data = super
    block_data.merge!(:type => block_type)
    block_data.merge!(:vehicles => vehicles_data)
    block_data
  end

  private

  def block_type
    'bus'
  end

  def api_name
    prediction_info.fetch('StopName', 'Unknown Name')
  end

  def vehicles_data
    VehiclesFactory.new({:type => block.agency,
                         :vehicle_info => vehicle_info, 
                         :unique_key => :destination}).vehicles
  end

  def vehicle_info
    prediction_info.fetch(vehicles_key, [])
  end

  def vehicles_key
    'Predictions'
  end

end
