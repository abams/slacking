require 'test_helper'

class SlackingTest < Minitest::Test

  def setup
    ENV['TEST'] = 'true'
    ENV['HOME'] = File.dirname(__FILE__).split('/')[0..-2].join('/') + '/support'
    Slacking.stubs(:get_action).returns('xhibit')
    Slacking::HttpClient.any_instance.stubs(:get_action).returns('message')
  end

  def test_profile
    stub_request(:post, "https://byliner.slack.com/services/hooks/incoming-webhook?token=xhibit").
      with(:body => "{\"text\":\"message\",\"channel\":\"#xhibit\",\"icon_url\":\"xhibit\",\"username\":\"xhibit\"}",
           :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})

    Slacking.run
  end
end
