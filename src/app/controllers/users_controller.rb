class UsersController < ApplicationController
  before_action :set_user, only: [:show, :unsubscribe, :withdrawal]
  before_action :ensure_normal_user, only: [:unsubscribe, :withdrawal]
  before_action :authenticate_user!
  before_action :cannot_changed_other_user, only: [:unsubscribe, :withdrawal]

  def index
    @users = User.where(is_deleted: false).where.not(id: current_user.id).page(params[:page]).per(4)
  end

  def show
    @posts = @user.posts.order(created_at: :desc)
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

  # ゲストユーザーは退会できない
  def ensure_normal_user
    if @user.email == 'aaa@aaa.com'
      redirect_to user_path(@user.id), alert: 'ゲストユーザーは退会できません。'
    end
  end

  # 他のユーザーの操作はできない
  def cannot_changed_other_user
    unless @user.id == current_user.id
      redirect_to user_path(current_user.id), alert: '他のアカウントは操作できません'
    end
  end
end
