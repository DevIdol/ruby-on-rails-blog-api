class Blog::BlogController < ApplicationController
  include Authenticable
  before_action :authenticate_request, except: [ :index, :show ]
  before_action :set_blog, only: [ :show, :update, :destroy, :toggle_publish ]

  # GET /blogs
  def index
    @blogs = Blog.includes(:user).all  # Ensure @blogs is used here
    respond_to do |format|
      format.html { render :index }
      format.json { render json: blogs_with_user(@blogs), status: :ok }
    end
  end

  # GET /blogs/user/:user_id
  def user_blogs
    authorize_user_for_resource(params[:user_id].to_i)
    blogs = @current_user.blogs.includes(:user)
    render json: blogs_with_user(blogs), status: :ok
  end

  # GET /blogs/:id
  def show
    respond_to do |format|
      format.html { render :show }  # Renders the app/views/blog/blogs/show.html.slim
      format.json { render json: blog_with_user(@blog), status: :ok }
    end
  end

  # POST /blogs
  def create
    blog = BlogService.new(@current_user, blog_params).create_blog

    if blog.persisted?
      render json: blog_with_user(blog), status: :created
    else
      render_error("Blog creation failed", blog.errors.full_messages)
    end
  end

  # PATCH/PUT /blogs/:id
  def update
    authorize_user_for_resource(@blog.user_id)

    blog_service = BlogService.new(@current_user, blog_params)
    updated_blog = blog_service.update_blog(@blog)

    if updated_blog
      render json: blog_with_user(updated_blog), status: :ok
    else
      render_error("Blog update failed", updated_blog.errors.full_messages)
    end
  end

  # DELETE /blogs/:id
  def destroy
    authorize_user_for_resource(@blog.user_id)
    @blog.destroy
    render json: { message: "Blog deleted successfully" }, status: :ok
  end

  # PATCH /blogs/:id/toggle_publish
  def toggle_publish
    authorize_user_for_resource(@blog.user_id)

    blog_service = BlogService.new(@current_user, blog_params)
    updated_blog = blog_service.toggle_publish(@blog)

    if updated_blog
      render json: blog_with_user(updated_blog), status: :ok
    else
      render_error("Failed to toggle publish", updated_blog.errors.full_messages)
    end
  end

  private

  def set_blog
    @blog = Blog.find_by(id: params[:id])
    render json: { message: "Blog not found" }, status: :not_found unless @blog
  end

  def blog_params
    params.permit(:title, :description, :is_publish)
  end

  def render_error(message, errors = [])
    render json: { message: message, errors: errors }, status: :unprocessable_entity
  end

  def blogs_with_user(blogs)
    blogs.as_json(include: { user: { only: [ :id, :username, :email ] } })
  end

  def blog_with_user(blog)
    blog.as_json(include: { user: { only: [ :id, :username, :email ] } })
  end
end
