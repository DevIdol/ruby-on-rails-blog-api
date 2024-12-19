class BlogService
  def initialize(user, params)
    @user = user
    @params = params
  end

  def create_blog
    @user.blogs.create(@params)
  end

  def update_blog(blog)
    blog.update(@params) ? blog : nil
  end

  def toggle_publish(blog)
    blog.update(is_publish: !blog.is_publish) ? blog : nil
  end
end
