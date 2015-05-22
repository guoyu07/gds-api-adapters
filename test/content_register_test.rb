require 'test_helper'
require 'gds_api/content_register'
require 'gds_api/test_helpers/content_register'

describe GdsApi::ContentRegister do
  include GdsApi::TestHelpers::ContentRegister
  include PactTest

  before do
    @api_adapter = GdsApi::ContentRegister.new('http://localhost:3077')
  end

  def content_id
    "16894762-dd99-40ca-9cbf-eb18a1567c0a"
  end

  def entry
    {
      "format" => 'organisation',
      "title" => 'Organisation',
      "base_path" => "/government/organisations/organisation"
    }
  end

  describe "#put_entry" do
    it "responds with 201 created if the entry does not exist" do
      content_register.given("an empty content register")
        .upon_receiving("PUT new entry")
        .with(
          method: :put,
          path: "/entry/#{content_id}",
          body: entry
        )
        .will_respond_with(
          status: 201,
          body: entry.merge(content_id: content_id)
        )

      response = @api_adapter.put_entry(content_id, entry)
      assert_equal 201, response.code
    end

    it "responds with 200 OK if the entry does exist" do
      content_register.given("an entry exists at /entry/#{content_id}")
        .upon_receiving("PUT new entry")
        .with(
          method: :put,
          path: "/entry/#{content_id}",
          body: entry
        )
        .will_respond_with(
          status: 200,
          body: entry.merge(content_id: content_id)
        )

      response = @api_adapter.put_entry(content_id, entry)
      assert_equal 200, response.code
    end
  end
end
