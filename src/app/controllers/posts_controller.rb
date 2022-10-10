class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = "投稿が完了しました"
      redirect_to root_path
    else
      flash[:danger] = @post.errors.full_messages
      redirect_to new_post_path
    end
  end

  def index
  end

  protected

  def post_params
    params.require(:post).permit(:title, :post_image, :description).merge(user_id: current_user.id)
  end
end
