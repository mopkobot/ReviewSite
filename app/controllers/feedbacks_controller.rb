class FeedbacksController < ApplicationController
  load_and_authorize_resource
  before_filter :load_review

  def load_review
    @review = Review.find(params[:review_id])
  end

  # GET /feedbacks/1
  # GET /feedbacks/1.json
  def show
    @feedback = Feedback.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/additional
  def additional
    @feedback = Feedback.new

    respond_to do |format|
      format.html # additional.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/new
  # GET /feedbacks/new.json
  def new
    @feedback = Feedback.new
    @review.feedbacks.each do |f|
      if f.user == current_user and f.user_string.nil?
        @feedback = f
        break
      end
    end
    @user_name = current_user.name

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feedback }
    end
  end

  # GET /feedbacks/1/edit
  def edit
    @feedback = Feedback.find(params[:id])
    @user_name = current_user.name
  end

  # POST /feedbacks
  # POST /feedbacks.json
  def create
    @feedback = Feedback.new(params[:feedback])
    @feedback.review = @review
    @feedback.user = current_user
    if params[:submit_final_button]
      @feedback.submitted = true
    end

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to [@review, @feedback], notice: 'Feedback was successfully created.' }
        format.json { render json: [@review, @feedback], status: :created, location: [@review, @feedback] }
      else
        format.html { render action: "new" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1
  # PUT /feedbacks/1.json
  def update
    @feedback = Feedback.find(params[:id])
    if params[:submit_final_button]
      @feedback.submitted = true
    end

    respond_to do |format|
      if @feedback.update_attributes(params[:feedback])
        format.html do
          redirect_to edit_review_feedback_path(@review.id, @feedback.id)
          flash[:success] = 'Feedback was successfully updated.'
        end
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1/submit
  # PUT /feedbacks/1.json
  def submit
    @feedback = Feedback.find(params[:id])
    @feedback.submitted = true

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to welcome_index_path, notice: 'Feedback was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedbacks/1/unsubmit
  # PUT /feedbacks/1.json
  def unsubmit
    @feedback = Feedback.find(params[:id])
    @feedback.submitted = false

    respond_to do |format|
      if @feedback.save
        format.html { redirect_to welcome_index_path, notice: 'Feedback was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedbacks/1
  # DELETE /feedbacks/1.json
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy

    respond_to do |format|
      format.html { redirect_to welcome_index_path }
      format.json { head :no_content }
    end
  end
end
