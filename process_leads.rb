require "sublayer"
require "yaml"
require "csv"
require "pry"
require "httparty"
require "asana"

# Load any Actions, Generators, and Agents
Dir[File.join(__dir__, "actions", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "generators", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "triggers", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "agents", "*.rb")].each { |file| require file }
Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini
Sublayer.configuration.ai_model = "gemini-2.0-flash"

csv = CSV.read("./ny-investors-20-500.csv", headers: true)

csv[0..9].each do |row|
  new_task = AsanaCreateTaskAction.new(
    project_id: ENV["LEAD_ENRICHMENT_ASANA_PROJECT_ID"],
    name: row[0],
    description: ""
  ).call
end
