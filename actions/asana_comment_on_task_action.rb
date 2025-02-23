class AsanaCommentOnTaskAction < AsanaBase
  def initialize(task_gid:, comment:, **kwargs)
    super(**kwargs)
    @task_gid = task_gid
    @comment = comment
  end

  def call
    @client.stories.create_story_for_task(task_gid: @task_gid, text: @comment)
  end
end
