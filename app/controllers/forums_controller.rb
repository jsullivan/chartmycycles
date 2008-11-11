class ForumsController < ApplicationController
 
  def index
    @forums = Forum.find(:all, :order => 'created_at DESC')
    @user = current_user
  end

  def topic
    @forum = Forum.find(params[:id])
    @user = current_user
    @posts = Post.find(:all, :conditions => "forum_id = #{@forum.id}", :order => 'updated_at DESC')
  end
  
  def create_post
     if request.post?
      @forum = Forum.find(params[:forum_id])
      @post = params[:post]
      @user  = current_user
      post = Post.new
      post.forum = @forum
      post.update_attributes(@post)
      post.user = current_user
      post.save
      redirect_to :controller => 'forums', :action => 'topic', :id => @forum.id
      else
      redirect_to :action => 'topic', :id => @forum
    end
  end
  
  def new_post
   @forum = Forum.find(params[:forum_id]) 
  end
  
  def details
    @user = current_user
    @post = Post.find(params[:id])
    @comments = @post.comments.find(:all, :order => 'created_at ASC')
  end
  
  def new_comment
    @post = params[:post_id]
  end
  
  def create_comment
    @post = Post.find(params[:post_id])
    @comment = params[:comment]
    @user = current_user
    comment = Comment.new
    comment.user = current_user
    comment.post = @post
    comment.update_attributes(@comment)
    comment.save
    redirect_to :action => 'details' , :id => @post.id
  end
end
