require 'fileutils'
require 'yaml'
require 'httparty'

class Profiles

  CONFIG_PATH = "#{File.expand_path(File.dirname(__FILE__))}/config".freeze
  PROFILES_PATH = "#{File.expand_path(File.dirname(__FILE__))}/profiles".freeze

  def initialize
    @token = get_slack_token
    listen
  end

  def listen
    profile = initialize_profile
    post_to_slack(profile) if profile
    listen
  end

  def initialize_profile
    puts "Which profile would you like to use? (type 'help' for help, or 'quit' to quit)"
    profile_name, options = gets.chomp.split('--').map(&:strip)

    if profile_name == 'help'
      display_help
      options = 'help'
    elsif profile_name == 'quit'
      exit
    end

    case options
    when 'image' then change_image(profile_name)
    when 'channel' then change_channel(profile_name)
    end

    if options.nil?
      profile_for(profile_name)
    end
  end

  def change_image(profile_name)
    profile = profile_for(profile_name)

    if !profile[:is_new]
      puts "Please enter a new image url:"
      profile[:icon_url] = gets.chomp
    end

    File.open("#{PROFILES_PATH}/#{profile_name}.yml", 'w+') do |f|
      profile[:is_new] = false
      f.write YAML.dump profile
    end
  end

  def change_channel(profile_name)
    profile = profile_for(profile_name)

    if !profile[:is_new]
      puts "Please enter a new channel:"
      profile[:channel] = gets.chomp
    end

    File.open("#{PROFILES_PATH}/#{profile_name}.yml", 'w+') do |f|
      profile[:is_new] = false
      f.write YAML.dump profile
    end
  end

  def profile_for(profile_name)
    unless File.directory?(PROFILES_PATH)
      FileUtils.mkdir(PROFILES_PATH)
    end

    profile_file = File.open("#{PROFILES_PATH}/#{profile_name}.yml", 'a+')

    profile = YAML.load(profile_file)

    if !profile
      puts "Creating a new profile, #{profile_name}."
      profile = generate_profile(profile_name, profile_file)
    end

    profile
  end

  def generate_profile(profile_name, profile_file)
    profile = {}
    profile[:username] = profile_name

    puts "Please enter an icon url:"
    profile[:icon_url] = gets.chomp

    puts "Please enter the slack channel you would like to post to:"
    profile[:channel] = gets.chomp

    # Indicate that this is a new profile
    profile[:is_new] = true

    profile_file.write YAML.dump profile

    profile
  end

  def post_to_slack(profile)
    puts "What would you like to say to #{profile[:channel]}, #{profile[:username]}?"
    text = gets.chomp

    headers = { 'Content-Type' => 'application/json' }
    body = {
      text: text,
      channel: "##{profile[:channel]}".sub('##', '#'),
      icon_url: profile[:icon_url],
      username: profile[:username],
    }.to_json

    response = HTTParty.post slack_url, body: body, headers: headers

    handle_response(response)
  end

  def handle_response(response)
    if response.body == 'No hooks'
      puts "Invalid API token\nPlease enter a valid token:"
      @token = gets.chomp
    end
  end

  def slack_url
    "https://byliner.slack.com/services/hooks/incoming-webhook?token=#{@token}"
  end

  def display_help
    puts "Type [username] --image to change the profile's image"
    puts "Type [username] --channel to change the slack channel this profile will post to"
    puts "Type 'profiles' to view a list of your profiles"
  end

  def get_slack_token
    unless File.directory?(CONFIG_PATH)
      FileUtils.mkdir(CONFIG_PATH)
    end

    token_file = File.open("#{CONFIG_PATH}/slack_api_token.txt", 'a+')
    token = token_file.read

    if token.empty?
      puts "Please enter your slack api token:\n"
      token = gets.chomp
      token_file.write token
      token_file.close
    end

    token
  end
end

Profiles.new
