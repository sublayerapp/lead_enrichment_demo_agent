class AsanaNewStoryEventTrigger < Sublayer::Triggers::Base
  def initialize(project_id:, access_token: nil, &event_handler)
    @project_id = project_id
    @access_token = access_token || ENV["ASANA_ACCESS_TOKEN"]
    @client = Asana::Client.new do |c|
      c.authentication :access_token, @access_token
    end
    @event_handler = event_handler
  end

  def setup(agent)
    project = @client.projects.find_by_id(@project_id)

    events = project.events(wait: 2)

    filtered_events = events.lazy.select do |event|
      (
        event.parent &&
        event.parent.gid == @project_id &&
        event.resource.resource_type == "task" &&
        event.action == "added" &&
        event.resource.name != ""
      )
    end

    filtered_events.each do |event|
      agent.instance_exec(event, &@event_handler)
    end
  end
end
