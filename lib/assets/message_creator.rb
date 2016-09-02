require './lib/assets/wit_client'


class MessageCreator

  def initialize(customer_value_id)
    @wit_client = WitClient.new(ENV['WIT_MESSAGE_ACCESS_TOKEN'])
    @customer_value_id = customer_value_id
  end

  def create(t)
    query = t
    unless @customer_value_id.nil?
      query += '_' + @customer_value_id.to_s
    end
    message, contexts = @wit_client.run_actions(query)
    message
  end
end
