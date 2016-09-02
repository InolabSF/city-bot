require './lib/assets/dijkstra'


class Router

  # initialize
  def initialize(start_space_id, destination_store_id)
    @start_space = Space.find_by_id start_space_id
    @store = Store.find_by_id destination_store_id
    @end_space = @store.space if @store
  end


  # get spaces to pass
  def get_spaces_to_pass
    return nil unless @start_space
    return nil unless @end_space

    dijkstra = Dijkstra.new(SpaceConnection.all)
    path = dijkstra.shortest_path(@start_space.id, @end_space.id)
    path
  end


  # get_route
  def get_route
    return nil unless @start_space
    return nil unless @end_space

    dijkstra = Dijkstra.new(SpaceConnection.all)
    path = dijkstra.shortest_path(@start_space.id, @end_space.id)
    descriptions = []
    last_floor_move = nil
    path.each_with_index do |space_id, index|
      if index >= path.count-1
        push_description(descriptions, last_floor_move) if last_floor_move
        break
      end

      # skip repeating floor change
      floor_change = get_floor_move(space_id, path[index+1])
      last_floor_move = floor_change unless floor_change.blank?
      if floor_change.blank? && !(last_floor_move.blank?)
        push_description(descriptions, last_floor_move)
        last_floor_move = nil
      end

      in_floor_move = get_in_floor_move(space_id, path[index+1])
      next unless in_floor_move
      push_description(descriptions, in_floor_move)
    end

    descriptions
  end


  # push_description
  def push_description(descriptions, description)
    descriptions.push(description) and return descriptions if descriptions.count == 0

    description[0] = description[0].downcase
    descriptions.push "Then, #{description}"
    descriptions
  end

  # get_floor_move
  def get_floor_move(start_space_id, end_space_id)
    end_space = Space.find_by_id end_space_id
    return nil unless end_space
    space_connection = SpaceConnection.where(start_space_id: start_space_id, end_space_id: end_space_id).first
    return nil unless space_connection

    case space_connection.category
    when 'escalator'
      start_space = Space.find_by_id start_space_id
      return nil unless start_space

      text = Space.floor_name(end_space.floor)

      return "Use the escalator at #{start_space.name}, and go to #{text}floor."
    else
      return nil
    end
  end

  # get_in_floor_move
  def get_in_floor_move(start_space_id, end_space_id)
    end_space = Space.find_by_id end_space_id
    return nil unless end_space
    space_connection = SpaceConnection.where(start_space_id: start_space_id, end_space_id: end_space_id).first
    return nil unless space_connection

    case space_connection.category
    when 'walk'
      return "Head to #{end_space.name}."
    else
      return nil
    end
  end


  # get_duration
  def get_duration
    duration = 0
    return duration unless @start_space
    return duration unless @end_space

    dijkstra = Dijkstra.new(SpaceConnection.all)
    path = dijkstra.shortest_path(@start_space.id, @end_space.id)
    path.each_with_index do |space_id, index|
      next if index >= path.count-1

      space_connection = SpaceConnection.where(start_space_id: space_id, end_space_id: path[index+1]).first
      duration += space_connection.duration
    end

    duration
  end

  # get_duration_text
  def get_duration_text
    duration = get_duration
    text = "#{duration} min"
    text = "#{text}s" if duration >= 2

    text
  end

end
