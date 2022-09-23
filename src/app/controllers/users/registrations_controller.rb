class Users::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_normal_user, only: [:edit, :update]

  protected

  # 新規登録後マイページにリダイレクト
  def after_sign_up_path_for(resource)
    user_path(current_user)
  end

  # パスワード入力無しで編集できる
  def update_resource(resource, params)
    resource.update_without_current_password(params)
  end
  
  # 編集後マイページにリダイレクト
  def after_update_path_for(resource)
    user_path(current_user)
  end

  # ゲストユーザーは編集できない
  def ensure_normal_user
    if resource.email == 'aaa@aaa.com'
      redirect_to user_path(@user.id), alert: 'ゲストユーザーは編集できません。'
    end
  end
end
