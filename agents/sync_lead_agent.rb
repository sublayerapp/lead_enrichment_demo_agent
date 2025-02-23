class SyncLeadAgent < Sublayer::Agents::Base
  trigger(
    AsanaTaskApprovedEventTrigger.new(project_id: ENV["LEAD_ENRICHMENT_ASANA_PROJECT_ID"]) do |event|
      puts "triggered"
      @current_event = event
      asana_task = AsanaGetTaskAction.new(task_gid: event.resource.gid).call

      if asana_task.approval_status == "approved"
        @goal_condition = false
        take_step
      end
    end
  )

  step do
    latest_comment = AsanaGetLatestCommentAction.new(task_gid: @current_event.resource.gid).call
    NotionCreateRowAction.new(
      database_id: ENV["NOTION_LEAD_ENRICHMENT_DEMO_DATABASE_ID"],
      properties: {
        "Name" => {
          "title": [{
            "text": {
              "content": @current_event.resource.name
            }
          }]
        },
        "LinkedIn Profiles" => {
          "rich_text": [{
            "text": {
              "content": latest_comment
            }
          }]
        }
      }).call
  end

  goal_condition { @goal_condition }
  check_status { true }
end
