class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def new
    @post = Post.new
    @materials = @post.materials.build
    @procedures = @post.procedures.build
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:notice] = "投稿が完了しました"
      redirect_to user_path(current_user.id)
    else
      flash[:danger] = @post.errors.full_messages
      redirect_to new_post_path
    end
  end

  def index
  end

  protected

  def post_params
    params.require(:post).permit(:title, :post_image, :description,
                                materials_attributes: [:id, :material_name, :quantity, :_destroy],
                                procedures_attributes: [:id, :explanation, :process_image]).merge(user_id: current_user.id)
  end
end
