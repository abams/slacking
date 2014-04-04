module Slacking
  module Help
    def display_help
      puts "----"
      puts "Type [username] to create a new profile, or use an existing one"
      puts "Type [username] --image to change an existing profile's image"
      puts "Type [username] --channel to change an existing profile's slack channel"
      puts '----'
    end
  end
end
