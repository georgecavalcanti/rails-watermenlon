module Sync::ModelsPull
  def self.models
    [
      Sync::Models::Assets.pull_settings,
      Sync::Models::Notes.pull_settings,
      Sync::Models::People.pull_settings,
      Sync::Models::Schedules.pull_settings
    ]
  end
end
