class Sync::ParamsPermitPush
  def self.params_permit
    hash = {}

    hash.merge!(Sync::Models::Notes.params_permit)
    hash.merge!(Sync::Models::People.params_permit)
    hash.merge!(Sync::Models::Schedules.params_permit)
    hash.merge!(Sync::Models::Assets.params_permit)

    [hash]
  end
end
