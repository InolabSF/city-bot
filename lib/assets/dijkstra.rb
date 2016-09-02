class Dijkstra

  Vertex ||= Struct.new(:name, :neighbours, :cost, :prev)


  def initialize(connctions)
    @vertices = Hash.new{|h,k| h[k]=Vertex.new(k,[],Float::INFINITY)}
    @edges = {}
    connctions.each do |space_connction|
      @vertices[space_connction.start_space_id].neighbours << space_connction.end_space_id
      @vertices[space_connction.end_space_id].neighbours << space_connction.start_space_id
      @edges[[space_connction.start_space_id, space_connction.end_space_id]] = @edges[[space_connction.end_space_id, space_connction.start_space_id]] = space_connction.cost
    end
    @dijkstra_source = nil
  end


  def execute(source)
    return  if @dijkstra_source == source
    q = @vertices.values
    q.each do |v|
      v.cost = Float::INFINITY
      v.prev = nil
    end
    @vertices[source].cost = 0
    until q.empty?
      u = q.min_by {|vertex| vertex.cost}
      break if u.cost == Float::INFINITY
      q.delete(u)
      u.neighbours.each do |v|
        vv = @vertices[v]
        if q.include?(vv)
          alt = u.cost + @edges[[u.name, v]]
          if alt < vv.cost
            vv.cost = alt
            vv.prev = u.name
          end
        end
      end
    end
    @dijkstra_source = source
  end

  def shortest_path(source, target)
    execute(source)
    path = []
    u = target
    while u
      path.unshift(u)
      u = @vertices[u].prev
    end
    #@vertices[target].cost
    return path
  end


end
