module AddLma
  extend ActiveSupport::Concern

  def add_last_modified
    self.last_modified_at = ((Time.now).to_f * 1000).to_i
  end

  def update_last_modified_at
    self.update_column(:last_modified_at, ((Time.now).to_f * 1000).to_i)
  end
end
