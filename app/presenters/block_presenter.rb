class BlockPresenter
  DESCENDANTS = [RailBlock, BusBlock, CabiBlock]
  attr_reader :block

  def self.build(block)
    klass = DESCENDANTS.detect { |descendant| descendant.handle?(block.agency) }
    klass.new(block)
  end

  def initialize(block)
    @block = block
  end

  def data
    block_data = {}
    block_data.merge!(:id => block.id)
    block_data.merge!(:column => block.column)
    block_data.merge!(:order => block.position)
    block_data.merge!(:name => block_name)
    block_data
  end

  private

  def prediction_info
    @prediction_info ||= block.prediction_info
  end

  def block_name
    if !block.custom_name.empty?
      name = block.custom_name
    else
      name = api_name
    end
  end

  def api_name
    'Custom Name'
  end

end
