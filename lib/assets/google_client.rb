require 'faraday'
require 'json'
require 'base64'
#require "google_drive"


class GoogleClient

  # initialize
  def initialize
    @server_key = ENV['GOOGLE_SERVER_KEY']
  end


  # text detection by image
  #
  # @param [Array] images image array
  # @return [Hash] response
  def detect_text_by_image(images)
    connection = Faraday.new(:url => "https://vision.googleapis.com/v1/images:annotate") do |faraday|
      faraday.request  :url_encoded
      faraday.response :logger
      faraday.adapter  Faraday.default_adapter
    end

    image_list = []
    images.each do |image|
      image_list.push({ :image => { :content => image }, :features => [ { :type => 'TEXT_DETECTION', :maxResults => 10 } ] })
    end
    body = { :requests => image_list }.to_json

    response = connection.post do |request|
      request.options.timeout = 10
      request.params['key'] = @server_key
      request.headers['Content-Type'] = 'application/json'
      request.body = body
    end

    begin
      JSON.parse(response.body)
    rescue Exception => e
      {}
    end
  end


  # parase text detection
  #
  # @param [Hash] json
  # @return [String] result of text detection
  # @return [Nil] when there are no results
  def parse_detect_text(json)
    return nil unless json
    return nil unless json['responses']
    return nil if json['responses'].empty?
    return nil unless json['responses'].first['textAnnotations']
    return nil if json['responses'].first['textAnnotations'].empty?

    text_annotation = json['responses'].first['textAnnotations'].first
    description = text_annotation['description']
    description
  end

end
