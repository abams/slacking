require 'slacking/file_management'

module Slacking
  module Profile
    include FileManagement

    PROFILES_PATH = "#{File.expand_path(File.dirname(__FILE__))}/user_profiles".freeze
    VALID_ATTRIBUTES = %w(image channel)

    protected

    def initialize_profile
      puts "Which profile would you like to use? (type 'help' for help, or 'quit' to quit)"
      @profile_name, options = get_action.split('--').map(&:strip)

      profile = if @profile_name == 'help'
        display_help
        options = 'help'
        nil
      elsif @profile_name == 'quit'
        exit
      else
        fetch_profile
      end

      if options && VALID_ATTRIBUTES.include?(options)
        profile = change_profile_attribute(profile, options)
      end

      if profile
        profile.delete(:is_new)
        write_profile_to_disk profile
      end

      profile if options.nil?
    end

    def fetch_profile
      create_profiles_dir

      profile = read_profile_from_disk

      if !profile
        puts "Creating a new profile, #{@profile_name}."
        profile = generate_profile(username: @profile_name)
      end

      profile
    end

    def generate_profile(profile)
      puts "Please enter an icon url:"
      profile[:icon_url] = get_action

      puts "Please enter the slack channel you would like to post to:"
      profile[:channel] = get_action

      profile[:is_new] = true

      profile
    end

    def change_profile_attribute(profile, attribute)
      if !profile.delete(:is_new)
        puts "Please enter a new #{attribute}:"
        profile[attribute.to_sym] = get_action
      end

      profile
    end
  end
end
