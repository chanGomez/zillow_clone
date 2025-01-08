class CommentsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]#renders devise template to sign user in. 
  before_action :set_comments, except: [:index, :new, :create]
  
def index
  @comments = Comments.all
end

  def show
  end

  def new
    @comments = Comments.new
  end

# def create
#   @comments = Comments.new(comments_params)
#   @comments.user_id = current_user.id # Explicitly set the user_id

#   if @comments.save
#     redirect_to @comments, notice: "Comments was successfully created."
#   else
#     render :new, status: :unprocessable_entity
#   end
# end

  def create
    @listing = Listing.find(params[:listing_id])
    @comment = @listing.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to listing_path(@listing), notice: 'Comment added!'
    else
      redirect_to listing_path(@listing), alert: 'Failed to add comment.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def update
    if @comments.update(comments_params)
      redirect_to @comments
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @comments.destroy
    redirect_to root_path, notice: "Comments was successfully deleted."
  end

  private

  def comments_params
  params.require(:comments).permit(:listing_id, :user_id, :content)
  end

  def set_comments
    @comments = user_signed_in? ? Comments.find(params[:id]) : Comments.published.find(params[:id])
   #if in case of an error or in this case an id that does not exit in the db then send user to home page
  rescue ActiveRecord::RecordNotFound
      redirect_to root_path 
  #root_path is => "/"
  end
end