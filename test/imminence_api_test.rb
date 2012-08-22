require "test_helper"
require "gds_api/imminence"

class ImminenceApiTest < MiniTest::Unit::TestCase

  ROOT = "https://imminence.test.alphagov.co.uk"

  def api_client
    GdsApi::Imminence.new('test')
  end

  def dummy_place
    {
      "access_notes" => nil,
      "address1" => "Cauldwell Street",
      "address2" => "Bedford",
      "fax" => nil,
      "general_notes" => nil,
      "geocode_error" => nil,
      "location" => [52.1327584352089, -0.4702813074674147],
      "name" => "Town Hall",
      "phone" => nil,
      "postcode" => "MK42 9AP",
      "source_address" => "Town Hall, Cauldwell Street, Bedford",
      "text_phone" => nil,
      "town" => nil,
      "url" => "http://www.bedford.gov.uk/advice_and_benefits/registration_service.aspx"
    }
  end

  def test_no_second_address_line
    c = api_client
    url = "#{ROOT}/places/wibble.json?limit=5&lat=52&lng=0"
    place_info = dummy_place.merge "address2" => nil
    c.expects(:get_json).with(url).returns([place_info])
    places = c.places("wibble", 52, 0)

    assert_equal 1, places.size
    assert_equal "Cauldwell Street", places[0]["address"]
  end

  def test_search_for_places
    c = api_client
    url = "#{ROOT}/places/wibble.json?limit=5&lat=52&lng=0"
    c.expects(:get_json).with(url).returns([dummy_place])
    places = c.places("wibble", 52, 0)

    assert_equal 1, places.size
    place = places[0]
    assert_equal 52.1327584352089, place["latitude"]
    assert_equal -0.4702813074674147, place["longitude"]
    assert_equal "Cauldwell Street, Bedford", place["address"]
  end

  def test_empty_location
    # Test behaviour when the location field is an empty array
    c = api_client
    url = "#{ROOT}/places/wibble.json?limit=5&lat=52&lng=0"
    place_info = dummy_place.merge("location" => [])
    c.expects(:get_json).with(url).returns([place_info])
    places = c.places("wibble", 52, 0)

    assert_equal 1, places.size
    place = places[0]
    assert_nil place["latitude"]
    assert_nil place["longitude"]
  end
end
