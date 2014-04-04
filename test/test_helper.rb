require 'rubygems'
require 'bundler'
Bundler.require :test

require 'minitest/autorun'
require 'webmock/minitest'
require 'mocha/setup'
require 'slacking'

# Support files
Dir["#{File.expand_path(File.dirname(__FILE__))}/support/*.rb"].each do |file|
  require file
end
