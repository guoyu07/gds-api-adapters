Pact.service_consumer "GDS API Adapters" do
  has_pact_with "Content register" do
    mock_service :content_register do
      port 3077
    end
  end
end
