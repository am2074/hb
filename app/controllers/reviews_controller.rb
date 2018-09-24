class ReviewsController < ApplicationController
  before_action :set_review, only: [:show, :edit, :update, :destroy]

  # GET /reviews
  # GET /reviews.json
  def index
    @review = Review.where(company_id: params[:company_id]) 
    @company= Company.friendly.find(params[:company_id])
  end

  # GET /reviews/1
  # GET /reviews/1.json
  def show
  end

  # GET /reviews/new
  def new
    @review = Review.new
    @company = Company.friendly.find(params[:company_id])
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews
  # POST /reviews.json
  def create
    @company = Company.friendly.find(params[:company_id])
    @review = @company.reviews.new(review_params)
    @review.user = current_user

    respond_to do |format|
      if @review.save
        format.html { redirect_to @company, notice: 'Review was successfully created.' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1
  # PATCH/PUT /reviews/1.json
  def update
    
    respond_to do |format|
      if @review.update(review_params)
        format.html {  redirect_to 'reviews#show', notice: 'Review was successfully updated.' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1
  # DELETE /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_back fallback_location: root_path, notice: 'Review was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  def upvote
    @review = Review.find(params[:id])
    @review.upvote_by current_user
    redirect_back fallback_location: root_path
  end

  def downvote
    @review = Review.find(params[:id])
    @review.downvote_by current_user
    redirect_back fallback_location: root_path.hash
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def review_params
      params.require(:review).permit(:review_id, :position, :employment_type, :satisfaction, :company_id, :user_id, :location, :response_time, :application_type, :company_id)
    end
end
