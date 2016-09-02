require './lib/assets/wit_client'


class DestinationDetector


  def initialize
    @wit_client = WitClient.new(ENV['WIT_CORE_ACCESS_TOKEN'])

    @message = nil
    @contexts = nil
    @navigation_type = nil
    @store_tags = nil
  end



  def run_with_text(text)
    @message, @contexts = @wit_client.run_actions(text)

    store_tag_key = nil; store_tag_value = nil
    @contexts.each do |key, value|
      next unless key.start_with?('store_tag_')
      @navigation_type = key.sub('store_tag_', '')
      store_tag_key = key
      store_tag_value = value
      break
    end
    @contexts.delete(store_tag_key) if store_tag_key
    @contexts['store_tag'] = store_tag_value if store_tag_value
    @store_tags = @contexts['store_tag'] if @contexts['store_tag']
  end


  def get_message
    @message
  end

  def get_contexts
    @contexts
  end

  def get_navigation_type
    @navigation_type
  end

  def get_store_tags
    @store_tags
  end

end

