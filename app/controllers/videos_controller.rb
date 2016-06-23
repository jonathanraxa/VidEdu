class VideosController < ApplicationController
    # before_filter :authenticate_user!

  before_action :set_video, only: [:show, :edit, :update, :destroy]



  def index

    
      if (current_user)
        @videos = current_user.videos.order('created_at DESC')
      else
        redirect_to pages_featured_path
      end
      
  end

  def oldest_to_new
      @videos = Video.order('created_at ASC')
  end

  def a_to_z
      @videos = Video.order("title ASC")
  end

  def z_to_a
      @videos = Video.order("title DESC")
  end

  def most_recent
    @videos = Video.order('created_at DESC')
  end

  def highest_rating
    if(1==1)
      @videos = Video.order('created_at DESC').limit(5).all
    end
  end

  def new
    @video = Video.new
     
     if current_user
       u = current_user.id
       @subject = Subject.where user_id: u
     end
  end

  def show
    @video = Video.find(params[:id])
   
    if (@video.user_id)
      u = @video.user_id
      @user = User.find(@video.user_id)
    end

    if current_user
       u = current_user.id
       @subject = Subject.where user_id: u
     end

    @comment = Comment.new
    @comments = Comment.where user_id: 4
    @comments = Comment.order('created_at DESC')

  end

   def update
    respond_to do |format|
      if @video.update(video_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { render :show, status: :ok, location: @video }
      else
        format.html { render :edit }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @video = Video.find(params[:id])
     u = current_user.id
     @subject = Subject.where user_id: u
  end


  def create
     @video = Video.new(video_params)
     @video.user_id=current_user.id if current_user


    if @video.save


      flash[:success] = "Video Created!"
       redirect_to videos_path
    else
      render :new
    end
    puts @video.title
  end


 def destroy
    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def featured
     @videos = Video.order('created_at DESC')
  end

  # def find
  #   @video = Video.find(:all, :conditions=>["title = ? OR subject = ?",
  #     params[:search_string], params[:search_string]])
  # end

  def search
    if params[:search].present?

      @videos = Video.search(params[:search])
      @subjects = Subject.search(params[:search])

    else
      @videos = Video.all
    end
    
  end


  private


    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

  def video_params
    params.require(:video).permit(:link, :subject, :name, :note_summary, :note, :review, :subject_id, :rating, :search, :find, :featured,:yt_description,:view_count,:category_title,:channel_title,:user_id,)
  end
end