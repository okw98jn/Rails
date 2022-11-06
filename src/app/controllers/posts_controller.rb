class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :set_category
  before_action :cannot_changed_other_user_post, only: [:edit, :update, :destroy]

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
    @posts = Post.all.page(params[:page]).per(10)
    @result = "全ての投稿"
  end

  def search
    keyword = params[:keyword]
    if keyword != ""
      @posts = Post.search(keyword).page(params[:page]).per(10)
      @result = "#{keyword}の検索結果(#{@posts.count}件)"
    else
      @posts = Post.all.page(params[:page]).per(10)
      @result = "全ての投稿"
    end
  end

  def search_category
    category = Category.find(params[:id])
    # posts = Post.where(category_id: category.id)
    posts = category.posts
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(10)
    @result = "#{category.name}の検索結果(#{@posts.count}件)"
  end

  def post_favorite_rank
    posts = Post.all
    posts = posts.sort { |a, b| b.favorites.count <=> a.favorites.count }
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(10)
    @result = "いいねランキング"
  end

  def post_comment_rank
    posts = Post.all
    posts = posts.sort { |a, b| b.comments.count <=> a.comments.count }
    @posts = Kaminari.paginate_array(posts).page(params[:page]).per(10)
    @result = "コメントランキング"
  end

  def show
    @user = @post.user
    @materials = @post.materials.where.not(material_name: "")
    @procedures = @post.procedures.where.not(process_image: "", explanation: "")
    @comment = Comment.new
    @comments = @post.comments.includes(:user).order(updated_at: :desc)
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "投稿を編集しました"
      redirect_to post_path(@post.id)
    else
      flash[:danger] = @post.errors.full_messages
      redirect_to edit_post_path(@post.id)
    end
  end

  def destroy
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to user_path(current_user.id)
  end

  protected

  def set_post
    @post = Post.find(params[:id])
  end

  def set_category
    @categories = Category.all
  end

  def post_params
    params.require(:post).permit(:title, :post_image, :description, :time, :number_of_persons, :category_id,
                                materials_attributes: [:id, :material_name, :quantity, :_destroy],
                                procedures_attributes: [:id, :explanation, :process_image, :_destroy]).merge(user_id: current_user.id)
  end

  # 他のユーザーの投稿は編集できない
  def cannot_changed_other_user_post
    unless @post.user_id == current_user.id
      redirect_to user_path(current_user.id), alert: '他のユーザーの投稿は編集できません'
    end
  end
end
