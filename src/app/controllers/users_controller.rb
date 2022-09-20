class UsersController < ApplicationController
  before_action :set_user, only: [:show, :unsubscribe, :withdrawal]
  before_action :ensure_normal_user, only: [:unsubscribe, :withdrawal]

  def show
  end

  # 退会ページ
  def unsubscribe
  end

  # 退会処理
  def withdrawal
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行しました"
    redirect_to root_path
  end

  protected

  def set_user
    @user = User.find(params[:id])
  end

  # ゲストユーザーは編集できない
  def ensure_normal_user
    if @user.email == 'aaa@aaa.com'
      redirect_to user_path(@user.id), alert: 'ゲストユーザーは退会できません。'
    end
  end
end
