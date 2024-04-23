class Asset < ApplicationRecord
  include AddLma

  acts_as_paranoid

  before_save :add_last_modified
  before_destroy :update_last_modified_at
  before_validation :add_last_modified
end
