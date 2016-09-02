require './lib/assets/facebook_client'
require './lib/assets/sender_handler'
require './lib/assets/recommender.rb'
require './lib/assets/destination_detector'
require './lib/assets/message_creator.rb'
require './lib/assets/operation_handler'


class MessagingHandler

  # constants

  GREETING_TEXT ||=           'greeting_text'

  # text
  AWESOME_TEXT ||=            'Awesome!'
  SEEYOU_TEXT ||=             'Thanks. See you soon!'

  OK_TEXT ||=                 'OK'
  CANCEL_TEXT ||=             'Cancel'

  RATING_TEXT ||=             'Are you sure '
  THANKS_FOR_RATING_TEXT ||=  'Thanks for rating!'

  # postback
  GOTO_POSTBACK ||=           'Go to '
  STOP_POSTBACK ||=           'Stop'
  CONTEXT_UPDATE_POSTBACK ||= 'Update context '
  CANCEL_POSTBACK ||=         'Cancel'


  # initialize
  #
  # @param [String] sender_id facebook user id
  def initialize(sender_id)
    @sender_handler = SenderHandler.new(sender_id)
    @navigation = @sender_handler.get_navigation
    @facebook_client = FacebookClient.new(sender_id)

    @message_creator = MessageCreator.new(@sender_handler.get_customer_value_id)
    @messages = []
  end


  # handle messaging hash which came from facebook messenger platform (https://developers.facebook.com/docs/messenger-platform/webhook-reference)
  #
  # @param [Hash] messaging hash
  def handle_on_facebook(messaging)
    # message
    if messaging.include?('message')
      message = messaging['message']

      # text
      handle_text(message['text']) if message.include?('text')
      # attachments
      handle_attachments(message['attachments']) if message.include?('attachments')
    end

    # postback
    handle_postback(messaging['postback']) if messaging.include?('postback')

    # optin
    #handle_optin(messaging['optin']) if messaging.include?('optin')
  end

  # handle_text
  #
  # @param [String] t text
  def handle_text(t)
    text = t.downcase

    # rating if text is number
    rating = nil
    begin
      rating = Integer(text)
      raise 'rating must be 1~5' if rating <= 0 || rating > 5
    rescue Exception => e
      rating = nil
    end
    rate(rating) and return if rating


    # store natural language
    @navigation.update_text text
    @navigation.save if @navigation.valid?

    # stop conversation
    if text == 'stop'
      @sender_handler.clear
      @messages.push({:text => @message_creator.create(GREETING_TEXT)})

    # before bot starts navigation
    elsif @navigation.not_know_destination_store?
      have_a_conversation_to_detect_store(text)

    else
      @messages.push({:text => @message_creator.create(GREETING_TEXT)})
    end
  end

  # handle attachments
  #
  # @param [Hash] attachments Hash
  def handle_attachments(attachments)
  end


  # handle_postback
  #
  # @param [Hash] postback Hash
  def handle_postback(postback)
    payload = postback['payload']

    case payload

    # Stop
    when STOP_POSTBACK
      stop_navigation

    # When
    when CANCEL_POSTBACK
      @messages.push({:text => OK_TEXT})

    else

      # Update context
      if payload.start_with?(CONTEXT_UPDATE_POSTBACK)
        contexts = {}
        params = payload.sub(CONTEXT_UPDATE_POSTBACK, '').split(';')
        params.each do |param|
          key_value = param.split(':')
          contexts["#{key_value[0]}"] = ["#{key_value[1]}"]
        end
        navigation = Navigation.find_by_id(contexts['navigation_id'])
        contexts.delete('navigation_id')
        navigation.update_contexts(contexts) if navigation
        @messages.push({:text => THANKS_FOR_RATING_TEXT})

      # Go to Store
      elsif payload.start_with?(GOTO_POSTBACK)
        store_id = payload.sub(GOTO_POSTBACK, '').to_i
        store = Store.find_by_id store_id
        return unless store

        @navigation.destination_store_id = store.id
        @navigation.navigation_type = "#{store.category}"
        @navigation.save if @navigation.valid?

        @messages.push({:text => "Below is information about #{store.name}."})
        @messages.push({:text => "ACCESS: #{store.address}\nTEL: #{store.phone_number}\nOPEN: #{store.opening_hour}"})

        stop_navigation

        operation_handler = OperationHandler.new
        operation_handler.add_operation(@navigation, 'rating', DateTime.now)
      end

    end
  end


  # have a conversation to detect store
  #
  # @param text what user says
  def have_a_conversation_to_detect_store(text)
    destination_detector = DestinationDetector.new
    destination_detector.run_with_text(text)

    # update navigation
    @navigation.navigation_type = destination_detector.get_navigation_type
    updated = @navigation.update_contexts(destination_detector.get_contexts)
    @navigation.save if @navigation.valid?

    # recommend
    store_tags = destination_detector.get_store_tags
    message = destination_detector.get_message
    if store_tags
      recommender = Recommender.new
      stores = recommender.get_recommended_stores(@navigation.navigation_type, store_tags)
      @navigation.update_recommendations_by_stores(stores)
      @navigation.save if @navigation.valid?
      @messages = (@messages + recommender.get_recommendations(message, stores))
    elsif message
      @messages.push({:text => updated ? message : @message_creator.create(GREETING_TEXT)})
    else
      @messages.push({:text => @message_creator.create(GREETING_TEXT)})
    end
  end

  # rate store you visited last time
  #
  # @param [Integer] rating store rating
  def rate(rating)
    navigations = Navigation.where("sender_id = ?", @sender_handler.get_sender_id).order("updated_at desc").limit(2)
    return if navigations.empty? || navigations.count < 2

    store = Store.find_by_id(navigations[1].destination_store_id)
    return unless store

    @messages.push({:text => "#{RATING_TEXT}#{store.name} is #{rating}?"})
    @messages.push({
      :button => {
        :buttons => [OK_TEXT, CANCEL_TEXT],
        :payloads => ["#{CONTEXT_UPDATE_POSTBACK}navigation_id:#{navigations[1].id};rating:#{rating}", CANCEL_POSTBACK]
      }
    })
  end

  # stop navigation
  def stop_navigation
    @sender_handler.clear
    @messages.push({:text => SEEYOU_TEXT})
  end


  # post message to facebook
  def post_messages_on_facebook
    @messages.each do |message|
      if message[:text]
        text = message[:text]
        @facebook_client.post_text(text)
      elsif message[:button]
        button = message[:button]
        @facebook_client.post_button(button[:buttons], button[:payloads])
      elsif message[:elements]
        elements = message[:elements]
        @facebook_client.post_elements(
          elements[:titles],
          elements[:subtitles],
          elements[:image_uris],
          elements[:buttons_list],
          elements[:payloads_list]
        )
      elsif message[:image]
        uri = message[:image]
        @facebook_client.post_image(uri)
      end
    end
  end

end
