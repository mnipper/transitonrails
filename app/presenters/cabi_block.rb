class CabiBlock < BlockPresenter

  def self.handle?(type)
    ['cabi'].include? type
  end

  def data
    block_data = super
    block_data.merge!(:type => block_type)
    block_data.merge!(:stations => stations)
    block_data
  end

  private

  def block_type
    'cabi'
  end

  def stations
    prediction_info.inject([]) do |stations, s|
      stations << {:name => s.fetch(name_key, 'Unknown Name'),
                   :bike_count => s.fetch(bike_count_key, 0),
                   :dock_count => s.fetch(dock_count_key, 0)
      }
      stations
    end
  end

  def name_key
    'name'
  end

  def bike_count_key
    'nbBikes'
  end

  def dock_count_key
    'nbEmptyDocks'
  end

  def api_name
    first_station = prediction_info.first
    first_station ? first_station.fetch(name_key, 'Unknown Name') : 'Unknown Name'
  end

end
