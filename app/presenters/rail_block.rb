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
    Vehicles.new(block_type, prediction_info[vehicles_key]).vehicles
  end

  def vehicles_key
    'Trains'
  end

end
