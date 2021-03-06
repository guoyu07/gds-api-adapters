module GdsApi
  module TestHelpers
    module Calendars
      CALENDARS_ENDPOINT = Plek.current.find('calendars')

      def calendars_endpoint(in_division: nil)
        endpoint = "#{CALENDARS_ENDPOINT}/bank-holidays"
        endpoint += "/#{in_division}" unless in_division.nil?
        endpoint + '.json'
      end

      def calendars_has_no_bank_holidays(in_division: nil)
        calendars_has_bank_holidays_on([], in_division: in_division)
      end

      def calendars_has_bank_holidays_on(dates, in_division: nil)
        events = dates.map.with_index do |date, idx|
          {
            title: "Caturday #{idx}!",
            date: date.to_date.iso8601,
            notes: "Y'know, for cats!",
            bunting: true
          }
        end

        response =
          if in_division.nil?
            {
              'england-and-wales' => {
                division: 'england-and-wales',
                events: events
              },
              'scotland' => {
                division: 'scotland',
                events: events
              },
              'northern-ireland' => {
                division: 'northern-ireland',
                events: events
              }
            }
          else
            {
              division: in_division,
              events: events
            }
          end

        stub_request(:get, calendars_endpoint(in_division: in_division))
          .to_return(body: response.to_json, status: 200)
      end

      def calendars_has_a_bank_holiday_on(date, in_division: nil)
        calendars_has_bank_holidays_on([date], in_division: in_division)
      end
    end
  end
end
