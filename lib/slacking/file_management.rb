require 'fileutils'
require 'yaml'

module Slacking
  module FileManagement

    private

    def write_config_to_disk(data)
      File.open("#{config_dir}/config.yml", 'w+') do |f|
        f.write YAML.dump(data)
      end
    end

    def read_config_from_disk
      files = File.open("#{config_dir}/config.yml", 'a+') do |f|
        YAML.load f
      end
    end

    def write_profile_to_disk(data)
      File.open("#{profiles_dir}/#{@profile_name}.yml", 'w+') do |f|
        f.write YAML.dump(data)
      end
    end

    def read_profile_from_disk
      files = File.open("#{profiles_dir}/#{@profile_name}.yml", 'a+') do |f|
        YAML.load f
      end
    end

    def create_config_dir
      return if File.directory? config_dir
      if File.exist? config_dir
        raise "Not a directory: #{config_dir}"
      else
        Dir.mkdir config_dir
      end
    end

    def create_profiles_dir
      return if File.directory? profiles_dir
      if File.exist? profiles_dir
        raise "Not a directory: #{profiles_dir}"
      else
        Dir.mkdir profiles_dir
      end
    end

    def profiles_dir
      @profiles_dir ||= ENV['PROFILES_DIR'] || File.join(home_dir, '.slacking')
    end

    def config_dir
      @config_dir ||= ENV['CONFIG_DIR'] || File.join(home_dir, '.slacking_config')
    end

    def home_dir
      @home_dir ||= begin
        home = ENV['HOME']
        home = ENV['USERPROFILE'] unless home
        if !home && (ENV['HOMEDRIVE'] && ENV['HOMEPATH'])
          home = File.join(ENV['HOMEDRIVE'], ENV['HOMEPATH'])
        end
        home = File.expand_path('~') unless home
        home = 'C:/' if !home && RUBY_PLATFORM =~ /mswin|mingw/
        home
      end
    end
  end
end
