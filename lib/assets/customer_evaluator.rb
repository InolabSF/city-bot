class CustomerEvaluator

  # initialize
  def initialize
  end

  # evaluate sender
  #
  # @param [Sender] sender Sender model
  def evaluate(sender)
    threshold_of_recency = 7
    threshold_of_frequency = 0.2
    threshold_of_rating = 3.5
    senconds_of_day = 24 * 60 * 60

    # recency
    recency = 0
    newest_navigation = Navigation.where("sender_id = ?", sender.id).order('updated_at desc').limit(1).first
    if newest_navigation
      days_since_last_update = (DateTime.now.to_time.to_i - newest_navigation.updated_at.to_time.to_i) / senconds_of_day
      recency = 1 if days_since_last_update <= threshold_of_recency
    end

    navigations = Navigation.where("sender_id = ? AND updated_at > ?", sender.id, 1.years.ago)

    # frequency
    frequency = 0
    oldest_navigation = Navigation.where("sender_id = ?", sender.id).order('updated_at asc').limit(1).first
    days_since_first_update = (DateTime.now.to_time.to_i - oldest_navigation.updated_at.to_time.to_i) / senconds_of_day if oldest_navigation
    if days_since_first_update
      if days_since_first_update == 0
        frequency = 1
      else
        frequency = 1 if navigations.count / days_since_first_update > threshold_of_frequency
      end
    end

    # satisfaction
    satisfaction = 0
    if navigations
      navigation_contexts = []
      context = Context.find_by_name 'rating'
      navigations.each do |navigation|
        navigation_contexts = navigation_contexts + NavigationContext.where("context_id = ? AND navigation_id = ?", context.id, navigation.id)
      end

      number_of_ratings = navigation_contexts.count
      if number_of_ratings > 0
        sum_of_ratings = 0
        navigation_contexts.each do |navigation_context|
          sum_of_ratings = sum_of_ratings + navigation_context.value.to_i
        end
        satisfaction = 1 if sum_of_ratings / number_of_ratings > threshold_of_rating
      end
    end

    # customer value
    customer_value = CustomerValue.where("recency = ? AND frequency = ? AND satisfaction = ?", recency, frequency, satisfaction).first
    sender.customer_value_id = customer_value.id if customer_value
    sender.save if sender.valid?
  end

end
