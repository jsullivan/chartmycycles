class ForumsController < ApplicationController
 
  def index
    @forums = Forum.find(:all, :order => 'created_at DESC')
    @user = current_user
    @abouts = About.find(:all, :order => 'created_at ASC')
  end

  def topic
    @forum = Forum.find(params[:id])
    @user = current_user
    @posts = Post.find(:all, :conditions => "forum_id = #{@forum.id}", :order => 'updated_at DESC')
  end
  
  def about
    @user = User.find(params[:id])
    @abouts = About.find(:all, :order => 'created_at ASC')
  end
  
  def about_details
    @user = current_user
    @about = About.find(params[:id])
    @comments = @about.about_comments.find(:all, :order => 'created_at ASC')
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
      if params[:post][:title].length < 1
        post.title = "Untitled"
      end
      post.save
      email = {
        :title => post.title,
        :body => post.body,
        :email => @user.email,
        :id => post.id,
        :topic => @forum.topic
      }
      Postoffice.deliver_newpost(email)
      
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
  
  def new_about_comment
     @about = params[:about_id]
   end

   def create_about_comment
     @about = About.find(params[:about_id])
     @about_comment = params[:about_comment]
     @user = current_user
     about_comment = AboutComment.new
     about_comment.user = current_user
     about_comment.about = @about
     about_comment.update_attributes(@about_comment)
     about_comment.save
     redirect_to :action => 'about_details' , :id => @about.id
   end
end
