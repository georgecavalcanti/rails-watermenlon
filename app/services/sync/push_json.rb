class Sync::PushJson
  prepend SimpleCommand

  def initialize(changes, last_pulled_at)
    @last_pulled_at = last_pulled_at.to_i
    @changes = changes
  end

  def call
    SyncJson.create(
      changes: @changes,
      last_pulled_at: @last_pulled_at
    )
  
    nil
  rescue => e
    p "Error push json #{e.to_s}"
  end
end
