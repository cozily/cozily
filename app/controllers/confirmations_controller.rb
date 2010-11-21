class ConfirmationsController < Clearance::ConfirmationsController
  private

  def url_after_create
    dashboard_path
  end
end