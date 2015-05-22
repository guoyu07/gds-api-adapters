require 'test_helper'
require 'gds_api/content_register'
require 'gds_api/test_helpers/content_register'

describe GdsApi::ContentRegister do
  include GdsApi::TestHelpers::ContentRegister
  include PactTest

  before do
    @api_adapter = GdsApi::ContentRegister.new('http://localhost:3077')
  end

  describe "#put_entry method" do
    it "creates an entry in the content register" do
      content_id = SecureRandom.uuid
      entry = {
        "format" => 'organisation',
        "title" => 'Organisation',
        "base_path" => "/government/organisations/organisation"
      }

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
  end
end
