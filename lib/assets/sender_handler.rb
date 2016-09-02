require './lib/assets/facebook_client'


class SenderHandler

  # initialize
  #
  # @param [String] facebook_id facebook user id
  def initialize(facebook_id)
    @sender = Sender.find_by_facebook_id(facebook_id)
    @facebook_client = FacebookClient.new(facebook_id)

    # create sender
    unless @sender
      @sender = Sender.new
      @sender.facebook_id = facebook_id

      navigation = create_new_navigation

      @sender.navigation_id = navigation.id
      @sender.save if @sender.valid?

      navigation.sender_id = @sender.id
      navigation.save if navigation.valid?
    end
  end

  # clear
  def clear
    navigation = create_new_navigation

    @sender.navigation_id = navigation.id
    @sender.save if @sender.valid?

    navigation.sender_id = @sender.id
    navigation.save if navigation.valid?

    @sender
  end

  # create new navigation
  #
  # @return [Navigation] navigation
  def create_new_navigation
    navigation = Navigation.new
      # facebook params
    json = @facebook_client.get_graph
    navigation.timezone = "#{json['timezone']}".to_i if json['timezone']
    navigation.first_name = "#{json['first_name']}" if json['first_name']
    navigation.last_name = "#{json['last_name']}" if json['last_name']
    navigation.gender = "#{json['gender']}" if json['gender']
    navigation.locale = "#{json['locale']}" if json['locale']
      #
    #navigation.gender = (Random.new.rand(2) == 0) ? 'male' : 'female'
    #locales = ['ja_JP', 'en_US', 'es_MX', 'en_CA', 'en_UK', 'en_AU']
    #navigation.locale = locales[Random.new.rand(locales.count)]
    #navigation.created_at = (Random.new.rand(24*7)).hours.ago
      #
    navigation.arrived = 0

    navigation.save if navigation.valid?

    navigation
  end

  # get navigation
  #
  # @return [Navigation] Navigation model
  def get_navigation
    Navigation.find_by_id @sender.navigation_id
  end

  def get_sender_id
    @sender.id
  end

  def get_customer_value_id
    @sender.customer_value_id
  end

end
