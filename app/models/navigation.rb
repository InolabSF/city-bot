class Navigation < ActiveRecord::Base
  has_many :navigation_contexts, dependent: :destroy
  has_many :messages, dependent: :destroy


  # update params by text
  #
  # @param [String] text free text
  def update_text(text)
    # message
    if text
      message = Message.new
      message.text = text
      if message.valid?
        message.save
        self.messages << message
      end
    end
  end

  # update params by contexts
  #
  # @param [Hash] contexts contexts in conversation
  # @return [Bool] if updated
  def update_contexts(contexts)
    updated = false

    # contexts
    navigation_contexts = self.navigation_contexts
    navigation_contexts = [] unless navigation_contexts
    contexts.each do |context_name, context_values|
      context = Context.find_by_name context_name
      next unless context

      if context.navigation_type
        self.navigation_type = context.navigation_type
        updated = true
      end

      navigation_contexts.each do |navigation_context|
        next if context.id != navigation_context.context_id
        navigation_context.destroy
      end

      context_values.each do |context_value|
        new_navigation_context = NavigationContext.new
        new_navigation_context.context_id = context.id
        new_navigation_context.value = "#{context_value}"
        next unless new_navigation_context.valid?
        new_navigation_context.save
        self.navigation_contexts << new_navigation_context
      end
    end

    updated
  end

  # update recommended_stores
  #
  # @param [Array] recommended_stores recommended Store models
  def update_recommendations_by_stores(recommended_stores)
    recommendations = []
    recommended_stores.each { |store| recommendations.push("#{store.id}") }
    update_contexts({'recommendation' => recommendations})
  end


  # if doesn't know destination_store?
  #
  # @return [Bool] true or false
  def not_know_destination_store?
    self.destination_store_id.blank?
  end

end
