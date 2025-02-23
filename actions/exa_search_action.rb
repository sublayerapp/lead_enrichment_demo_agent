class ExaSearchAction < Sublayer::Actions::Base
  def initialize(query:, category:)
    @query = query
    @category = category
  end

  def call
    results = HTTParty.post(
      "https://api.exa.ai/search",
      headers: {
        "Content-Type" => "application/json",
        "Authorization" => "Bearer #{ENV["EXA_API_KEY"]}"
      },
      body: {
        query: @query,
        useAutoprompt: true,
        type: "neural",
        category: @category,
        numResults: 10
      }.to_json
    )
  end
end
