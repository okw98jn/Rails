class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @favorite = Favorite.new(user_id: current_user.id, post_id: params[:post_id])
    @favorite.save
    @post.create_notification_like!(current_user)
  end

  def destroy
    @favorite = Favorite.find_by(user_id: current_user.id, post_id: params[:post_id])
    @favorite.destroy
  end

  protected

  def set_post
    @post = Post.find(params[:post_id])
  end
end
