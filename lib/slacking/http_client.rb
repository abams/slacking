require 'slacking/config'
require 'slacking/io'
require "net/http"
require "uri"
require 'json'

module Slacking
  class HttpClient
    include IO
    include Config

    def initialize(token)
      @token = token
    end

    def post_to_slack(profile)
      @profile = profile
      url = URI.parse(slack_url)

      request = Net::HTTP::Post.new("#{url.path}?#{url.query}")
      request.body = request_body
      request.add_field 'Content-Type', 'application/json'

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      handle_response http.request(request)
    end

    protected

    def request_body
      {
        text: message,
        channel: "##{@profile[:channel]}".sub('##', '#'),
        icon_url: @profile[:icon_url],
        username: @profile[:username],
      }.to_json
    end

    private

    def message
      puts "What would you like to say to #{@profile[:channel]}, #{@profile[:username]}?"
      get_action
    end

    def handle_response(response)
      if response.body == 'No hooks'
        @token = get_slack_token('w+')
      else
        puts response.body
      end
    end

    def slack_url
      "https://byliner.slack.com/services/hooks/incoming-webhook?token=#{@token}"
    end
  end
end
