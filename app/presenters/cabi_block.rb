class CabiBlock < BlockPresenter

  def self.handle?(type)
    ['cabi'].include? type
  end

  def data
    block_data = super
    block_data.merge!(:type => block_type)
    block_data.merge!(:bike_count => bike_count)
    block_data.merge!(:dock_count => dock_count)
    block_data
  end

  private

  def block_type
    'cabi'
  end

  def api_name
    prediction_info['name']
  end

  def bike_count
    prediction_info['nbBikes']
  end

  def dock_count
    prediction_info['nbEmptyDocks']
  end

end
