class ScreenPresenter
  attr_reader :screen

  def initialize(screen)
    @screen = screen
  end

  def data
    results = {}
    results.merge!(screen_information)
    results[:blocks] = []
    blocks.sort_by(&:position).each do |block|
      results[:blocks] << BlockPresenter.build(block).data
    end
    results
  end

  private

  def screen_information
    @screen_information ||= {:name => screen.name}
  end

  def blocks
    screen.relevant_blocks
  end


end
