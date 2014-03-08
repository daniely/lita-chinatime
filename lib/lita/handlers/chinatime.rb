require 'date'

module Lita
  module Handlers
    class Chinatime < Handler
      route %r{^chinatime$}i, :chinatime, command: true, help: { 'chinatime' => 'display current time in China' }

      def chinatime(response)
        # 35 103 is loc of china
        resp = http.get('http://www.earthtools.org/timezone/35/103')

        raise 'Not found' if resp.status == 404

        date_time = extract_date_time(resp)
        response.reply format_date_time(DateTime.parse(date_time))
      rescue
        reponse.reply error
      end

      private

      def extract_date_time(resp)
        resp.body.match(/<localtime>(.*)<\/localtime>/)[1]
      end

      def format_date_time(date_time)
        date_time.strftime('%e %b %Y %l:%m:%S %p')
      end

      def error
        "Sorry, but there was a problem getting the time."
      end
    end

    Lita.register_handler(Chinatime)
  end
end
