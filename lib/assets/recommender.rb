class Recommender


  # constants

  NOTSTORE_TEXT ||=         "Sorry, we don't have the category you need. Any other preference?"

  GO_POSTBACK ||=           'Go'
  GOTO_POSTBACK ||=         'Go to '



  # initialize
  def initialize()
  end


  # return Store model Array
  #
  # @param [String] category store category
  # return [Array] Store Array
  def get_recommended_stores(category, tags)
    tags = [] if tags.include? 'no idea'

    # choose stores to recommend
    recommendations = []
    stores = []
    categorized_stores = Store.where(category: category)
    unless tags.empty?
      joined_stores = categorized_stores.joins(:store_tags)
      tags.each do |tag|
        stores += joined_stores.where(store_tags: { :value => tag })
      end
    else
      stores = categorized_stores
    end
    return recommendations if stores.empty?

    # choose recommendations from stores
    recommendation_count = 3
    for i in 0...recommendation_count
      break if stores.empty?

      index = Random.new.rand(stores.count)
      recommendations.push stores[index]
      stores -= [stores[index]]
    end

    recommendations
  end


  # get recommendation texts
  #
  # prams [String] message message to send
  # prams [Array] stores Store model Array
  # return [Array] Array whicn contains Hash to post messenger
  def get_recommendations(message, stores)
    jsons = [{:text => NOTSTORE_TEXT}]

    # no store
    return jsons unless stores
    return jsons if stores.count == 0

    jsons = []

    # message
    jsons.push({:text => message}) if message

    # recommendations
    titles = []
    subtitles = []
    image_uris = []
    buttons_list = []
    payloads_list = []
    stores.each do |store|
      title = "#{store.name} (#{store.description})"
      subtitle = "　"
      image_uri = "#{store.image_uri}"
      buttons = [GO_POSTBACK]
      payloads = ["#{GOTO_POSTBACK}#{store.id}"]

      titles.push title
      subtitles.push subtitle
      image_uris.push image_uri
      buttons_list.push buttons
      payloads_list.push payloads
    end

    jsons.push({ :elements => {
      :titles => titles,
      :subtitles => subtitles,
      :image_uris => image_uris,
      :buttons_list => buttons_list,
      :payloads_list => payloads_list
    }})
    jsons
  end


end

