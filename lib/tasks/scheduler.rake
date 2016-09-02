require './lib/assets/operation_handler'
require './lib/assets/customer_evaluator'


task :update_models => :environment do
  # Context
  Context.delete_all
  context_hashes = [
    { :id => 1, :name => 'store_tag' },
    { :id => 2, :name => 'will_intent' },
    { :id => 3, :name => 'greeting' },
    { :id => 4, :name => 'place_to_eat', :navigation_type => 'restaurant' },
    { :id => 5, :name => 'food_intent', :navigation_type => 'restaurant' },
    { :id => 6, :name => 'ask_intent' },
    { :id => 7, :name => 'rating' },
    { :id => 8, :name => 'recommendation' }
  ]
  context_hashes.each do |context_hash|
    context = Context.new
    context.id = context_hash[:id]
    context.name = context_hash[:name]
    context.navigation_type = context_hash[:navigation_type] if context_hash[:navigation_type]
    context.save if context.valid?
  end


  # Operation
  Operation.delete_all
  operation_hashes = [
    { :id => 1, :name => 'rating' }
  ]
  operation_hashes.each do |operation_hash|
    operation = Operation.new
    operation.id = operation_hash[:id]
    operation.name = operation_hash[:name]
    operation.save if operation.valid?
  end


  # Mall
  Tag.delete_all
  StoreTag.delete_all
  Store.delete_all

  tag_hashes = [
    { :id => 1, :name => 'category' },
    { :id => 2, :name => 'taste' },
    { :id => 3, :name => 'place' },
    { :id => 4, :name => 'price' }
  ]

  store_hashes = [
    {
      :id => 1,
      :name => "Sanraku",
      :category => "restaurant",
      :description => "Japanese, Sushi",
      :opening_hour => "月～土 11:00AM～10:00PM／日 4:00PM～10:00PM",
      :phone_number => "4157710803",
      :address => "704 Sutter St., San Francisco, CA 94109",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/1.jpg"
    },
    {
      :id => 2,
      :name => "Sanraku",
      :category => "restaurant",
      :description => "Japanese, Sushi",
      :opening_hour => "日～木 11:00AM～9:00PM／金･土 11:00AM～10:00PM",
      :phone_number => "4153696166",
      :address => "Metreon, 135 4th St., San Francisco, CA 94103",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/2.jpg"
    },
    {
      :id => 3,
      :name => "Minamoto Kitchoan",
      :category => "restaurant",
      :description => "Dessert, Japanese",
      :opening_hour => "月～木 9:30AM～7:00PM／金・土 9:30AM～8:00PM／日 11:00AM～6:00PM",
      :phone_number => "4159891645",
      :address => "648 Market St., San Francisco, CA 94104",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/3.jpg"
    },
    {
      :id => 4,
      :name => "Zingari Ristorante",
      :category => "restaurant",
      :description => "Italian",
      :opening_hour => "日・月 3:30PM～11:30PM／火～木 11:30AM～11:30PM／金・土 11:30AM～0:00AM（深夜）、＜ランチ＞火～土 11:30AM～2:30PM、＜ディナー＞日～木 5:00PM～10:30PM／金・土 5:00PM～11:00PM、＜ジャズライブ＞8:00PM～閉店まで",
      :phone_number => "4158858850",
      :address => "501 Post St., San Francisco, CA 94102",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/4.jpg"
    },
    {
      :id => 5,
      :name => "LUPICIA Fresh Tea",
      :category => "restaurant",
      :description => "Tea",
      :opening_hour => "月～土 10:00AM～8:30PM／日 11:00AM～7:00PM",
      :phone_number => "4152270533",
      :address => "Westfield San Francisco Centre 3F / 845 Market St., San Francisco, CA 94103",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/5.jpg"
    },
    {
      :id => 6,
      :name => "San Francisco Chocolate Store",
      :category => "restaurant",
      :description => "Chocolate, Sweets",
      :opening_hour => "9:30AM～9:00PM",
      :phone_number => "4156149440",
      :address => "145 Jefferson St., San Francisco, CA 94133",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/6.jpg"
    },
    {
      :id => 7,
      :name => "Swiss Louis",
      :category => "restaurant",
      :description => "Italian, Seafood",
      :opening_hour => "11:00AM～9:00PM",
      :phone_number => "4154212913",
      :address => "PIER 39 2F, San Francisco, CA 94133",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/7.jpg"
    },
    {
      :id => 8,
      :name => "VOM FASS Oils Vinegars Spirits",
      :category => "restaurant",
      :description => "Beer, Wine",
      :opening_hour => "日～木 10:00AM～7:00PM／金・土 10:00AM～9:00PM",
      :phone_number => "4154046980",
      :address => "Ghirardelli Square / 900 N Point St., San Francisco, CA 94109",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/8.jpg"
    },
    {
      :id => 9,
      :name => "Yank Sing",
      :category => "restaurant",
      :description => "Dumpling, Chinese",
      :opening_hour => "月～金 11:00AM～3:00PM／土・日・祝 10:00AM～4:00PM",
      :phone_number => "4157811111",
      :address => "101 Spear St., San Francisco, CA 94105",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/9.jpg"
    },
    {
      :id => 10,
      :name => "Yank Sing",
      :category => "restaurant",
      :description => "Dumpling, Chinese",
      :opening_hour => "月～金 11:00AM～3:00PM／土・日・祝 10:00AM～4:00PM",
      :phone_number => "4155414949",
      :address => "49 Stevenson St., San Francisco, CA 94105",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/10.jpg"
    },
    {
      :id => 11,
      :name => "Fog Harbor Fish House",
      :category => "restaurant",
      :description => "Seafood",
      :opening_hour => "11:00AM～10:00PM",
      :phone_number => "4154212442",
      :address => "PIER 39 2F, San Francisco, CA 94133",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/11.jpg"
    },
    {
      :id => 12,
      :name => "Pier Market Seafood Restaurant",
      :category => "restaurant",
      :description => "Seafood, Bar",
      :opening_hour => "月～金 11:00AM～10:00PM／土・日 10:30AM～10:00PM",
      :phone_number => "4159897437",
      :address => "PIER 39 1F, San Francisco, CA 94133",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/12.jpg"
    },
    {
      :id => 13,
      :name => "Wipeout Bar & Grill",
      :category => "restaurant",
      :description => "Seafood, Bar",
      :opening_hour => "日～木 9:00AM～9:00PM／金・土 9:00AM～10:00PM",
      :phone_number => "4159865966",
      :address => "PIER 39 1F, San Francisco, CA 94133",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/13.jpg"
    },
    {
      :id => 14,
      :name => "Crystal Jade",
      :category => "restaurant",
      :description => "Chinese, Dumpling",
      :opening_hour => "＜ランチ＞月～金 11:00AM～2:30PM／土・日 10:30AM～3:00PM、＜ディナー＞ 5:00PM～10:00PM",
      :phone_number => "4153991200",
      :address => "4 Embarcadero Center #1, San Francisco, CA 94111",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/sf-bot/14.jpg"
    }
  ]

  store_tag_hashes = [
    { :id => 1,  :tag_id => 1,  :store_id => 1,   :value => 'japanese' },
    { :id => 2,  :tag_id => 1,  :store_id => 1,   :value => 'sushi' },
    { :id => 3,  :tag_id => 2,  :store_id => 1,   :value => 'salty' },
    { :id => 4,  :tag_id => 3,  :store_id => 1,   :value => 'restaurant' },
    { :id => 5,  :tag_id => 4,  :store_id => 1,   :value => '2' },
    { :id => 6,  :tag_id => 1,  :store_id => 2,   :value => 'japanese' },
    { :id => 7,  :tag_id => 1,  :store_id => 2,   :value => 'sushi' },
    { :id => 8,  :tag_id => 2,  :store_id => 2,   :value => 'salty' },
    { :id => 9,  :tag_id => 3,  :store_id => 2,   :value => 'restaurant' },
    { :id => 10, :tag_id => 4,  :store_id => 2,   :value => '2' },
    { :id => 11, :tag_id => 1,  :store_id => 3,   :value => 'japanese' },
    { :id => 12, :tag_id => 1,  :store_id => 3,   :value => 'dessert' },
    { :id => 13, :tag_id => 2,  :store_id => 3,   :value => 'sweet' },
    { :id => 14, :tag_id => 3,  :store_id => 3,   :value => 'bakery' },
    { :id => 15, :tag_id => 4,  :store_id => 3,   :value => '3' },
    { :id => 16, :tag_id => 1,  :store_id => 4,   :value => 'italian' },
    { :id => 17, :tag_id => 1,  :store_id => 4,   :value => 'wine' },
    { :id => 18, :tag_id => 1,  :store_id => 4,   :value => 'cocktail' },
    { :id => 19, :tag_id => 2,  :store_id => 4,   :value => 'salty' },
    { :id => 20, :tag_id => 3,  :store_id => 4,   :value => 'restaurant' },
    { :id => 21, :tag_id => 4,  :store_id => 4,   :value => '3' },
    { :id => 22, :tag_id => 1,  :store_id => 5,   :value => 'Tea' },
    { :id => 23, :tag_id => 3,  :store_id => 5,   :value => 'cafe' },
    { :id => 24, :tag_id => 4,  :store_id => 5,   :value => '2' },
    { :id => 25, :tag_id => 1,  :store_id => 6,   :value => 'dessert' },
    { :id => 26, :tag_id => 2,  :store_id => 6,   :value => 'sweet' },
    { :id => 27, :tag_id => 3,  :store_id => 6,   :value => 'bakery' },
    { :id => 28, :tag_id => 4,  :store_id => 6,   :value => '2' },
    { :id => 29, :tag_id => 1,  :store_id => 7,   :value => 'italian' },
    { :id => 30, :tag_id => 1,  :store_id => 7,   :value => 'seafood' },
    { :id => 31, :tag_id => 1,  :store_id => 7,   :value => 'wine' },
    { :id => 32, :tag_id => 2,  :store_id => 7,   :value => 'salty' },
    { :id => 33, :tag_id => 3,  :store_id => 7,   :value => 'restaurant' },
    { :id => 34, :tag_id => 4,  :store_id => 7,   :value => '2' },
    { :id => 35, :tag_id => 1,  :store_id => 8,   :value => 'wine' },
    { :id => 36, :tag_id => 1,  :store_id => 8,   :value => 'beer' },
    { :id => 37, :tag_id => 2,  :store_id => 8,   :value => 'salty' },
    { :id => 38, :tag_id => 3,  :store_id => 8,   :value => 'bar' },
    { :id => 39, :tag_id => 4,  :store_id => 8,   :value => '2' },
    { :id => 40, :tag_id => 1,  :store_id => 9,   :value => 'chinese' },
    { :id => 42, :tag_id => 2,  :store_id => 9,   :value => 'salty' },
    { :id => 43, :tag_id => 3,  :store_id => 9,   :value => 'restaurant' },
    { :id => 44, :tag_id => 4,  :store_id => 9,   :value => '1' },
    { :id => 45, :tag_id => 1,  :store_id => 10,  :value => 'chinese' },
    { :id => 46, :tag_id => 2,  :store_id => 10,  :value => 'salty' },
    { :id => 47, :tag_id => 3,  :store_id => 10,  :value => 'restaurant' },
    { :id => 48, :tag_id => 4,  :store_id => 10,  :value => '2' },
    { :id => 49, :tag_id => 1,  :store_id => 11,  :value => 'seafood' },
    { :id => 50, :tag_id => 2,  :store_id => 11,  :value => 'salty' },
    { :id => 51, :tag_id => 3,  :store_id => 11,  :value => 'restaurant' },
    { :id => 52, :tag_id => 4,  :store_id => 11,  :value => '2' },
    { :id => 53, :tag_id => 1,  :store_id => 12,  :value => 'seafood' },
    { :id => 54, :tag_id => 1,  :store_id => 12,  :value => 'wine' },
    { :id => 55, :tag_id => 1,  :store_id => 12,  :value => 'beer' },
    { :id => 56, :tag_id => 2,  :store_id => 12,  :value => 'salty' },
    { :id => 57, :tag_id => 3,  :store_id => 12,  :value => 'restaurant' },
    { :id => 58, :tag_id => 3,  :store_id => 12,  :value => 'bar' },
    { :id => 59, :tag_id => 4,  :store_id => 12,  :value => '2' },
    { :id => 60, :tag_id => 1,  :store_id => 13,  :value => 'american' },
    { :id => 61, :tag_id => 1,  :store_id => 13,  :value => 'sandwich' },
    { :id => 62, :tag_id => 2,  :store_id => 13,  :value => 'salty' },
    { :id => 63, :tag_id => 3,  :store_id => 13,  :value => 'restaurant' },
    { :id => 64, :tag_id => 4,  :store_id => 13,  :value => '2' },
    { :id => 65, :tag_id => 1,  :store_id => 14,  :value => 'chinese' },
    { :id => 66, :tag_id => 2,  :store_id => 14,  :value => 'salty' },
    { :id => 67, :tag_id => 3,  :store_id => 14,  :value => 'restaurant' },
    { :id => 68, :tag_id => 4,  :store_id => 14,  :value => '3' },
  ]

  store_hashes.each do |store_hash|
    store = Store.new
    store.id = "#{store_hash[:id]}"
    store.name = store_hash[:name]
    store.category = "#{store_hash[:category]}"
    store.opening_hour = store_hash[:opening_hour]
    store.phone_number = store_hash[:phone_number]
    store.address = "#{store_hash[:address]}"
    store.description = store_hash[:description]
    store.image_uri = store_hash[:image_uri]
    store.save if store.valid?
  end

  tag_hashes.each do |tag_hash|
    tag = Tag.new
    tag.id = tag_hash[:id]
    tag.name = tag_hash[:name]
    tag.save if tag.valid?
  end

  store_tag_hashes.each do |store_tag_hash|
    store_tag = StoreTag.new
    store_tag.id = store_tag_hash[:id]
    store_tag.tag_id = store_tag_hash[:tag_id]
    store_tag.store_id = store_tag_hash[:store_id]
    store_tag.value = store_tag_hash[:value]
    store_tag.save if store_tag.valid?

    store = Store.find_by_id "#{store_tag.store_id}"
    store.store_tags << store_tag
  end


  # CustomerValue
  CustomerValue.delete_all
  customer_value_hashes = [
    {
      :id =>             1,
      :name =>          'Loyal',
      :recency =>        1,
      :frequency =>      1,
      :satisfaction =>   1,
      :strategy =>      '',
      :operation_id =>   2
    },
    {
      :id =>             2,
      :name =>          'Visit a lot but not satisfied',
      :recency =>        1,
      :frequency =>      1,
      :satisfaction =>   0,
      :strategy =>      '',
      :operation_id =>   2
    },
    {
      :id =>             3,
      :name =>          'Recently visited but not satisfied',
      :recency =>        1,
      :frequency =>      0,
      :satisfaction =>   0,
      :strategy =>      '',
      :operation_id =>   2
    },
    {
      :id =>             4,
      :name =>          'Recently visited and satisfied',
      :recency =>        1,
      :frequency =>      0,
      :satisfaction =>   1,
      :strategy =>      '',
      :operation_id =>   2
    },
    {
      :id =>             5,
      :name =>          'Visited before but not satisfied',
      :recency =>        0,
      :frequency =>      0,
      :satisfaction =>   0,
      :strategy =>      '',
      :operation_id =>   2
    },
    {
      :id =>             6,
      :name =>          'Visited before and satisfied',
      :recency =>        0,
      :frequency =>      0,
      :satisfaction =>   1,
      :strategy =>      '',
      :operation_id =>   2
    },
    {
      :id =>             7,
      :name =>          'Used to visit a lot and satisfied',
      :recency =>        0,
      :frequency =>      1,
      :satisfaction =>   1,
      :strategy =>      '',
      :operation_id =>   2
    },
    {
      :id =>             8,
      :name =>          'Used to visit a lot but not satisfied',
      :recency =>        0,
      :frequency =>      1,
      :satisfaction =>   0,
      :strategy =>      '',
      :operation_id =>   2
    }
  ]
  customer_value_hashes.each do |customer_value_hash|
    customer_value = CustomerValue.new
    customer_value.id = customer_value_hash[:id]
    customer_value.name = customer_value_hash[:name]
    customer_value.recency = customer_value_hash[:recency]
    customer_value.frequency = customer_value_hash[:frequency]
    customer_value.satisfaction = customer_value_hash[:satisfaction]
    customer_value.strategy = customer_value_hash[:strategy]
    customer_value.operation_id = customer_value_hash[:operation_id]
    customer_value.save if customer_value.valid?
  end

end


task :execute_operations => :environment do
    operation_handler = OperationHandler.new
    operation_handler.execute_operations('rating') { |navigation_operation| operation_handler.execute_rating_operation(navigation_operation) }
end


task :evaluate_senders => :environment do
  customer_evaluator = CustomerEvaluator.new

  senders = Sender.all
  senders.each do |sender|
    customer_evaluator.evaluate(sender)
  end
end
