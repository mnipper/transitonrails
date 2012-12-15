class BlockPresenter
  attr_reader :block

  def initialize(block)
    @block = block
  end

  def data
    data = {}
    data.merge!(:type => block_type)
    data.merge!(:id => block.id)
    data.merge!(:column => block.column)
    data.merge!(:order => block.position)
    data.merge!(:name => block_name)
    data.merge!(:vehicles => vehicles_data)
  end

  private


  def block_type
    @block_type ||= determine_block_type
  end

  def determine_block_type
    type = case(block.agency)
      when *['metrobus','art','dc-circulator'] then 'bus'
      when *['metrorail'] then 'rail'
      when *['cabi'] then 'cabi'
      else 'custom'
      end
    type
  end

  def block_name
    if !block.custom_name.empty?
      name = block.custom_name
    else
      name = api_name
    end
  end

  def api_name
    name = case (block_type)
      when *['bus'] then prediction_info.fetch('StopName', 'Unknown Name')
      when *['rail'] then prediction_info['Trains'].first.fetch('LocationName')
      when *['cabi'] then 'Capital Bikeshare Station'
      else 'Custom Name'
    end
    name
  end

  def vehicles_data
    Vehicles.new(block_type, prediction_info[vehicles_key]).vehicles
  end

  def vehicles_key
    key = case (block_type)
      when *['bus'] then 'Predictions'
      when *['rail'] then 'Trains'
      when *['cabi'] then 'Station'
      else 'Key'
    end
    key
  end


  def prediction_info
    @prediction_info ||= block.prediction_info
  end

end
