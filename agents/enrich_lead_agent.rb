class EnrichLeadAgent < Sublayer::Agents::Base
  trigger(
    AsanaNewStoryEventTrigger.new(project_id: ENV["LEAD_ENRICHMENT_ASANA_PROJECT_ID"]) do |event|
      puts "triggered"
      @current_event = event
      @goal_condition = false
      take_step
    end
  )

  step do
    puts "Searching for #{@current_event.resource.name}"

    response = ExaSearchAction.new(
      query: "Platform/talent/recruiting staff at #{@current_event.resource.name}",
      category: "linkedin profile"
    ).call

    results = response["results"]

    unless results.empty?
      AsanaCommentOnTaskAction.new(
        task_gid: @current_event.resource.gid,
        comment: results.map { |result| result["url"] }.join("\n")
      ).call
    end
  end

  goal_condition { @goal_condition }
  check_status { true }
end
