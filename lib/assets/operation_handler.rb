require './lib/assets/facebook_client'


class OperationHandler


  # initialize
  def initialize()
  end


  # add operation
  #
  # @param [Navigation] navigation Navigation
  # @param [String] operation_name Operation#name
  # @param [DateTime] time_to_execute time to execute the operation
  def add_operation(navigation, operation_name, time_to_execute)
    return unless navigation

    operation = Operation.find_by_name operation_name
    return unless operation

    navigation_operations = NavigationOperation.where("navigation_id = ? AND operation_id = ?", navigation.id, operation.id)
    return unless navigation_operations.empty?

    navigation_operation = NavigationOperation.new
    navigation_operation.navigation_id = "#{navigation.id}"
    navigation_operation.operation_id = "#{operation.id}"
    navigation_operation.time_to_execute = time_to_execute

    navigation_operation.save if navigation_operation.valid?
  end

  # execute operations
  #
  # @param [String] operation_name Operation#name
  # @param [Block] block operation to do
  def execute_operations(operation_name)
    operation = Operation.find_by_name operation_name
    return unless operation

    navigation_operations = NavigationOperation.where("time_to_execute < ? AND operation_id = ?", DateTime.now, operation.id)
    navigation_operations.each do |navigation_operation|
      yield navigation_operation

      navigation_operation.destroy
    end
  end



  # execute rating operation
  #
  # @param [NavigationOperation] navigation_operation NavigationOperation
  def execute_rating_operation(navigation_operation)
    navigation = Navigation.find_by_id(navigation_operation.navigation_id)
    return nil unless navigation

    sender = Sender.find_by_id navigation.sender_id
    return nil unless sender

    store = Store.find_by_id(navigation.destination_store_id)
    rating_text = "How was #{store.name}? Please rate and type 1~5."
    facebook_client = FacebookClient.new(sender.facebook_id)
    facebook_client.post_text(rating_text)
  end

end
