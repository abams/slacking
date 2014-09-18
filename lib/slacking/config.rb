require 'slacking/file_management'

module Slacking
  module Config
    include FileManagement

    protected

    def get_slack_config(write_options = 'a+')
      create_config_dir
      config = read_config_from_disk || {}

      unless config[:token]
        puts "Please enter your slack api token:\n"
        config.merge!(token: get_action)
      end

      unless config[:organization]
        puts "Please enter your slack organization (i.e. https://{organization}.slack.com):\n"
        config.merge!(organization: get_action)
      end

      write_config_to_disk(config)

      config
    end
  end
end
