class ImportDeleteJob < ActiveJob::Base
  def perform(model, values)
    model.constantize.where(id: values).destroy_all
  end
end
