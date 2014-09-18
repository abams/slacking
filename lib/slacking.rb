require 'slacking/http_client'
require 'slacking/config'
require 'slacking/help'
require 'slacking/io'
require 'slacking/profile'
require 'slacking/version'

module Slacking
  class << self
    include IO
    include Config
    include Profile
    include Help

    def run
      config = get_slack_config
      @token = config[:token]
      @organization = config[:organization]
      listen
    end

    protected

    def client
      @client ||= Slacking::HttpClient.new(@token, @organization)
    end

    private

    def listen
      profile = initialize_profile
      client.post_to_slack(profile) if profile

      return if ENV['TEST']
      listen
    end
  end
end
