require "spec_helper"

describe Lita::Handlers::Chinatime, lita_handler: true do
  it { routes_command("chinatime").to(:chinatime) }

  describe "#chinatime" do
    let(:response) { double("Faraday::Response") }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
    end

    it "replies with an image URL on success" do
      allow(response).to receive(:status).and_return(200)
      allow(response).to receive(:body).and_return(<<-HTML.chomp
<?xml version="1.0" encoding="ISO-8859-1" ?>
  <timezone xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://www.earthtools.org/timezone.xsd">
  <version>1.0</version>
  <location>
    <latitude>35</latitude>
    <longitude>103</longitude>
  </location>
  <offset>8</offset>
  <suffix>H</suffix>
  <localtime>8 Mar 2014 22:07:45</localtime>
  <isotime>2014-03-08 22:07:45 +0800</isotime>
  <utctime>2014-03-08 14:07:45</utctime>
  <dst>Unknown</dst>
</timezone>
HTML
        )

      send_command('chinatime')

      expect(replies.last).to eq(' 8 Mar 201410:03:45 PM')
    end
  end
end
