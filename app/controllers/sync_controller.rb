class SyncController < ApplicationController
  def pull
    service = Sync::PullChanges.call(
      pull_params[:lastPulledAt],
      pull_params[:page],
      pull_params[:limit],
      pull_params[:experimentalStrategy],
      pull_params[:migration]
    )

    return render json: service.result
  end

  def push
    service = Sync::PushChanges.call(
      push_params[:changes].to_h,
      push_params[:lastPulledAt]
    )

    if service.success?
      render json: { data: service.result }, status: :ok
    else
      render json: { errors: service.errors }, status: :internal_server_error
    end
  end

  private

  def pull_params
    params.permit(:lastPulledAt, :page, :limit, :experimentalStrategy, :migration)
  end

  def push_params
    params.permit(
      :lastPulledAt,
      changes: Sync::ParamsPermitPush.params_permit
    )
  end
end
