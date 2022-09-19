class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: [:edit, :update]

  protected

  # パスワード入力無しで編集できる
  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end

  # ゲストユーザーは編集できない
  def ensure_normal_user
    if resource.email == 'aaa@aaa.com'
      redirect_to root_path, alert: 'ゲストユーザーは編集できません。'
    end
  end
end
