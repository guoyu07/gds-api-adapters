require 'test_helper'
require 'gds_api/content_store'
require 'gds_api/test_helpers/content_store'

describe GdsApi::ContentStore do
  include GdsApi::TestHelpers::ContentStore

  before do
    @base_api_url = Plek.current.find("content-store")
    @api = GdsApi::ContentStore.new(@base_api_url)
  end

  describe "#content_item" do
    it "returns the item" do
      base_path = "/test-from-content-store"
      content_store_has_item(base_path)

      response = @api.content_item(base_path)

      assert_equal base_path, response["base_path"]
    end

    it "raises if the item doesn't exist" do
      content_store_does_not_have_item("/non-existent")

      assert_raises(GdsApi::HTTPNotFound) do
        @api.content_item("/non-existent")
      end
    end

    it "raises if the item doesn't exist" do
      content_store_does_not_have_item("/non-existent")

      assert_raises GdsApi::HTTPNotFound do
        @api.content_item("/non-existent")
      end
    end

    it "raises if the item is gone" do
      content_store_has_gone_item("/it-is-gone")

      assert_raises(GdsApi::HTTPGone) do
        @api.content_item("/it-is-gone")
      end
    end

    it "raises if the item is gone" do
      content_store_has_gone_item("/it-is-gone")

      assert_raises GdsApi::HTTPGone do
        @api.content_item("/it-is-gone")
      end
    end
  end
end
