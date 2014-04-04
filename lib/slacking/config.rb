require 'slacking/file_management'

module Slacking
  module Config
    include FileManagement

    protected

    def get_slack_token(write_options = 'a+')
      create_config_dir
      config = read_config_from_disk || {}

      unless config[:token]
        puts "Please enter your slack api token:\n"
        config.merge!(token: get_action)
        write_config_to_disk(config)
      end

      config[:token]
    end
  end
end
