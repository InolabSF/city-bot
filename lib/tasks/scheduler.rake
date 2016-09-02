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

  store_tag_hashes = [
    { :id => 1,  :tag_id => 1,  :store_id => 1,   :value => 'japanese' },
    { :id => 2,  :tag_id => 1,  :store_id => 1,   :value => 'ramen' },
    { :id => 3,  :tag_id => 2,  :store_id => 1,   :value => 'salty' },
    { :id => 4,  :tag_id => 2,  :store_id => 1,   :value => 'heavy' },
    { :id => 5,  :tag_id => 2,  :store_id => 1,   :value => 'oily' },
    { :id => 6,  :tag_id => 2,  :store_id => 1,   :value => 'casual' },
    { :id => 8,  :tag_id => 3,  :store_id => 1,   :value => 'restaurant' },
    { :id => 9,  :tag_id => 4,  :store_id => 1,   :value => '2' },
  ]

  store_hashes = [
    {
      :id => 1,
      :name => "Orenchi Beyond",
      :category => "restaurant",
      :description => "Ramen, Japanese",
      :opening_hour => "Open 10:00 AM - 8:30 PM",
      :phone_number => "415.284.9276",
      :address => "174 Valencia St, San Francisco, CA 94103",
      :image_uri => "https://dl.dropboxusercontent.com/u/30701586/images/westfield/logos/auyfpsph6shjs6veq5kh.jpg"
    }
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
